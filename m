Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbbACWgu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 17:36:50 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47919 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbbACWgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 17:36:47 -0500
Date: Sat, 3 Jan 2015 23:36:44 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Richard Weinberger <richard@nod.at>
Cc: Jiri Kosina <jkosina@suse.cz>, Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Aaron Tomlin <atomlin@redhat.com>,
        DaeSeok Youn <daeseok.youn@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, vdavydov@parallels.com,
        Rik van Riel <riel@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andy Lutomirski <luto@amacapital.net>,
        Brad Spengler <spender@grsecurity.net>
Subject: Re: [PATCH] [RFC] Deter exploit bruteforcing
Message-ID: <20150103223644.GB27979@amd>
References: <20150102194616.GA27538@amd>
 <54A7103E.6020500@nod.at>
 <20150102222936.GA29018@amd>
 <alpine.LRH.2.00.1501022331060.30884@twin.jikos.cz>
 <20150102224646.GB29018@amd>
 <alpine.LNX.2.00.1501022348070.16297@pobox.suse.cz>
 <20150102225420.GC29018@amd>
 <54A72306.2050908@nod.at>
 <20150102230837.GA4482@amd>
 <54A7BA45.1050005@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54A7BA45.1050005@nod.at>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >> No. This is not what this patch does.
> >>
> >>> But changing glibc to do sleep(30); abort(); instead of abort(); to
> >>> slow down bruteforcing of canaries makes some kind of sense... and
> >>> should be ok by default.
> >>
> >> As I saidn only focusing one the specific stack canary case is not enough.
> > 
> > Ok, so I am now saying "adding random delays to the kernel, hoping
> > they slow attacker down" is bad idea. Feel free to add my NAK to the
> > patch.
> 
> The patch does not add random delays nor is hope involved.
> 
> It has a very clear purpose, it makes brute force attacks to forking
> services unattractive.
> Exploits often use the fact that after fork() the child has the same memory
> as the parent and therefore an attacker can start fruitful brute force attacks
> to brute stack canaries, offsets, etc. as the new child will always have mostly
> the same memory layout as before.
> 
> But I'll happily add your NAK to this series.

Please do.

> > If really neccessary, "kill_me_slowly()" syscall would be acceptable,
> > but it seems just sleep(); abort(); combination is enough.
> 
> The goal of the patch is not to protect only against brute forcing the stack canary.
> It should protect against all kind of brute forcing using forking services.
> 
> > glibc should cover 99% cases where this matters, please just fix glibc,
> > others will follow.
> 
> There are a lot of systems out there without glibc.

Only "interesting" systems that are without glibc are androids, and
they usually run very old kernels.

If you implement sleep() in glibc, distros will enable it and you'll
protect all the desktop users.

If you implement it in kernel, it will not be compatible-enough to be
enabled by default, and you'll be protecting special "high security"
distros at most.

> And many applications make system calls without going though any libc wrapper.
> Hey, we want also protect esoteric distros like http://sta.li. :-)

No, we don't. We want to maximize number of protected users. And
patching glibc does that. (And then you can patch bionic. And then the
small players will follow).

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
