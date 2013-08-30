Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab3H3VEC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 17:04:02 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:35493 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab3H3VEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 17:04:00 -0400
MIME-Version: 1.0
In-Reply-To: <20130830205404.GF13318@ZenIV.linux.org.uk>
References: <CA+55aFx1oq7+jce8vLWRitASVMugCojYe3gmhXwhLx4K9Au3XQ@mail.gmail.com>
	<CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com>
	<52200DAE.2020303@hp.com>
	<CA+55aFyhTR15GBS4VNoRkcFyubEJU7a+Pzd-6VZeKoU8qB0q5Q@mail.gmail.com>
	<5220E56A.80603@hp.com>
	<CA+55aFzv9BZ2+B2NrNRRtTqnfgbH3LRSvSsUZVsy-g9OpM-8HA@mail.gmail.com>
	<5220F090.5050908@hp.com>
	<CA+55aFzqJ5So9Hj1H0C86e4s13FuEEC_n6ubgJ6SexEDB5rYHg@mail.gmail.com>
	<5220FD51.2010709@hp.com>
	<CA+55aFzhiLMdSCnePX0OgFUXo7KC+aomM8URppDuV+7xUaaSpw@mail.gmail.com>
	<20130830205404.GF13318@ZenIV.linux.org.uk>
Date: Fri, 30 Aug 2013 14:03:59 -0700
X-Google-Sender-Auth: Be9SiIRfzB-xTmM2p_TFijSizN0
Message-ID: <CA+55aFwwKEaTBX9Uoexpote7dOHBq+TiJ=RifzTpVL_jh24A9w@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Waiman Long <waiman.long@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 1:54 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Not really.  Sure, you'll retry it if you race with d_move(); that's not
> the real problem - access past the end of the object containing ->d_name.name
> would screw you and that's what ->d_lock is preventing there.  Delayed freeing
> of what ->d_name is pointing into is fine, but it's not the only way to get
> hurt there...

Umm? We follow d->d_name.name without d_lock under RCU all the time -
that's what the pathname lookup is all about, after all.

Yes, yes, you haev to be careful and cannot just blindly trust the
length: you also have to check for NUL character as you are copying it
and stop if you hit it. But that's trivial.

Why would d_prepend be any different?

            Linus
