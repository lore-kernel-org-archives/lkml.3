Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbbABWyY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 17:54:24 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54929 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbbABWyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 17:54:22 -0500
Date: Fri, 2 Jan 2015 23:54:20 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Richard Weinberger <richard@nod.at>, Kees Cook <keescook@chromium.org>,
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
Message-ID: <20150102225420.GC29018@amd>
References: <1419457167-15042-1-git-send-email-richard@nod.at>
 <CAGXu5jKxzyjzoY_khgZu7TbxMhfG3jiXGObiaiUhx6g5-k9c6Q@mail.gmail.com>
 <20150102051142.GF4873@amd>
 <54A67A38.3000207@nod.at>
 <20150102194616.GA27538@amd>
 <54A7103E.6020500@nod.at>
 <20150102222936.GA29018@amd>
 <alpine.LRH.2.00.1501022331060.30884@twin.jikos.cz>
 <20150102224646.GB29018@amd>
 <alpine.LNX.2.00.1501022348070.16297@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1501022348070.16297@pobox.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2015-01-02 23:49:52, Jiri Kosina wrote:
> On Fri, 2 Jan 2015, Pavel Machek wrote:
> 
> > > You also want to protect against binaries that are evil on purpose,
> > > right?
> > 
> > Umm. No. Not by default. We don't want to break crashme or trinity by
> > default.
> 
> I thought trinity is issuing syscalls directly (would make more sense than 
> going through glibc, wouldn't it?) ... haven't checked the source though.

Patch in this thread wanted to insert delays into kernel on SIGSEGV
processing. That's bad idea by default.

But changing glibc to do sleep(30); abort(); instead of abort(); to
slow down bruteforcing of canaries makes some kind of sense... and
should be ok by default.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
