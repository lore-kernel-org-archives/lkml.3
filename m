Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab3HaWte (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 18:49:34 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:35037 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab3HaWtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 18:49:32 -0400
MIME-Version: 1.0
In-Reply-To: <20130831212355.GN13318@ZenIV.linux.org.uk>
References: <5220E56A.80603@hp.com>
	<CA+55aFzv9BZ2+B2NrNRRtTqnfgbH3LRSvSsUZVsy-g9OpM-8HA@mail.gmail.com>
	<5220F090.5050908@hp.com>
	<CA+55aFzqJ5So9Hj1H0C86e4s13FuEEC_n6ubgJ6SexEDB5rYHg@mail.gmail.com>
	<5220FD51.2010709@hp.com>
	<CA+55aFzhiLMdSCnePX0OgFUXo7KC+aomM8URppDuV+7xUaaSpw@mail.gmail.com>
	<20130830205404.GF13318@ZenIV.linux.org.uk>
	<CA+55aFwwKEaTBX9Uoexpote7dOHBq+TiJ=RifzTpVL_jh24A9w@mail.gmail.com>
	<20130830214452.GH13318@ZenIV.linux.org.uk>
	<CA+55aFyyrihbLyMRSW9ahviNFiwi-NBKbcjeKW6fouWUW8fj6g@mail.gmail.com>
	<20130831212355.GN13318@ZenIV.linux.org.uk>
Date: Sat, 31 Aug 2013 15:49:31 -0700
X-Google-Sender-Auth: EYiiN_1K1n46-xLukx-iLR9WB-w
Message-ID: <CA+55aFwxQ2zN+kbt0Atob-Rims4B1pxgFniXbbA=YDAfb+wWAg@mail.gmail.com>
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

On Sat, Aug 31, 2013 at 2:23 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Hmm...  OK, most of these suckers are actually doing just one component;
> we can look into 'print the ancestors as well' later, but the minimal
> variant would be something like this and it already covers a lot of those
> guys.  Comments?

Doesn't look wrong, but remember the /proc debugging thing? We
definitely wanted more than just one pathname component, and I don't
think that's completely rare.

So I think it would be better to prepare for that, and simply print to
a local buffer, and then use the "string()" function on the end
result. Rather than do it directly from the dentry like you do, and
then having to do that widen() thing because you couldn't do the
strnlen() that that code wanted..

Hmm?

          Linus
