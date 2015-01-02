Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbbABXIl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 18:08:41 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56471 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbbABXIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 18:08:40 -0500
Date: Sat, 3 Jan 2015 00:08:37 +0100
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
Message-ID: <20150102230837.GA4482@amd>
References: <20150102051142.GF4873@amd>
 <54A67A38.3000207@nod.at>
 <20150102194616.GA27538@amd>
 <54A7103E.6020500@nod.at>
 <20150102222936.GA29018@amd>
 <alpine.LRH.2.00.1501022331060.30884@twin.jikos.cz>
 <20150102224646.GB29018@amd>
 <alpine.LNX.2.00.1501022348070.16297@pobox.suse.cz>
 <20150102225420.GC29018@amd>
 <54A72306.2050908@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54A72306.2050908@nod.at>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2015-01-03 00:00:22, Richard Weinberger wrote:
> Am 02.01.2015 um 23:54 schrieb Pavel Machek:
> > On Fri 2015-01-02 23:49:52, Jiri Kosina wrote:
> >> On Fri, 2 Jan 2015, Pavel Machek wrote:
> >>
> >>>> You also want to protect against binaries that are evil on purpose,
> >>>> right?
> >>>
> >>> Umm. No. Not by default. We don't want to break crashme or trinity by
> >>> default.
> >>
> >> I thought trinity is issuing syscalls directly (would make more sense than 
> >> going through glibc, wouldn't it?) ... haven't checked the source though.
> > 
> > Patch in this thread wanted to insert delays into kernel on SIGSEGV
> > processing. That's bad idea by default.
> 
> No. This is not what this patch does.
> 
> > But changing glibc to do sleep(30); abort(); instead of abort(); to
> > slow down bruteforcing of canaries makes some kind of sense... and
> > should be ok by default.
> 
> As I saidn only focusing one the specific stack canary case is not enough.

Ok, so I am now saying "adding random delays to the kernel, hoping
they slow attacker down" is bad idea. Feel free to add my NAK to the
patch.

If really neccessary, "kill_me_slowly()" syscall would be acceptable,
but it seems just sleep(); abort(); combination is enough.

glibc should cover 99% cases where this matters, please just fix glibc,
others will follow.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
