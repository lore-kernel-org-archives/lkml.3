Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab3H3UnO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 16:43:14 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:53968 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288Ab3H3UnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 16:43:12 -0400
MIME-Version: 1.0
In-Reply-To: <5220FD51.2010709@hp.com>
References: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com>
	<1375758759-29629-2-git-send-email-Waiman.Long@hp.com>
	<CA+55aFyMeK+bAvkqi_HpShqm7Des6uriVP_xp+BJqD0ASCVL0g@mail.gmail.com>
	<1377751465.4028.20.camel@pasglop>
	<20130829070012.GC27322@gmail.com>
	<CA+55aFwzY_1tD5vmaDgwAGLXNSGw4XS8vEp9vOpN6NPm5+Mxow@mail.gmail.com>
	<CA+55aFx1oq7+jce8vLWRitASVMugCojYe3gmhXwhLx4K9Au3XQ@mail.gmail.com>
	<CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com>
	<52200DAE.2020303@hp.com>
	<CA+55aFyhTR15GBS4VNoRkcFyubEJU7a+Pzd-6VZeKoU8qB0q5Q@mail.gmail.com>
	<5220E56A.80603@hp.com>
	<CA+55aFzv9BZ2+B2NrNRRtTqnfgbH3LRSvSsUZVsy-g9OpM-8HA@mail.gmail.com>
	<5220F090.5050908@hp.com>
	<CA+55aFzqJ5So9Hj1H0C86e4s13FuEEC_n6ubgJ6SexEDB5rYHg@mail.gmail.com>
	<5220FD51.2010709@hp.com>
Date: Fri, 30 Aug 2013 13:43:11 -0700
X-Google-Sender-Auth: B6T5-T7wDzkGg0MBbGcxw3tIzRM
Message-ID: <CA+55aFzhiLMdSCnePX0OgFUXo7KC+aomM8URppDuV+7xUaaSpw@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
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

On Fri, Aug 30, 2013 at 1:15 PM, Waiman Long <waiman.long@hp.com> wrote:
>
> The prepend_path() isn't all due to getcwd. The correct profile should be

Ugh. I really think that prepend_path() should just be rewritten to
run entirely under RCU.

Then we can remove *all* the stupid locking, and replace it with doing
a read-lock on the rename sequence count, and repeating if requited.

That shouldn't even be hard to do, it just requires mindless massaging
and being careful.

             Linus
