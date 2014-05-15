Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbaEOPfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 11:35:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50976 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbaEOPfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 11:35:47 -0400
Date: Thu, 15 May 2014 17:35:44 +0200
From: chrubis@suse.cz
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Darren Hart <dvhart@linux.intel.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Jakub Jelinek <jakub@redhat.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux API <linux-api@vger.kernel.org>,
        "Carlos O'Donell" <carlos@redhat.com>
Subject: Re: futex(2) man page update help request
Message-ID: <20140515153544.GB6926@rei.Home>
References: <537346E5.4050407@gmail.com>
 <CF98E3EF.90564%dvhart@linux.intel.com>
 <537407ED.8050606@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537407ED.8050606@zytor.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> > However, unless I'm sorely mistaken, the larger problem is that glibc
> > removed the futex() call entirely, so these man pages don't describe
> > something users even have access to anymore. I had to revert to calling
> > the syscalls directly in the futextest test suite because of this:
> > 
> > http://git.kernel.org/cgit/linux/kernel/git/dvhart/futextest.git/tree/inclu
> > de/futextest.h#n67
> > 
> 
> This really comes down to the fact that we should have a libinux which
> contains the basic system call wrapper machinery for Linux specific
> things and nothing else.
> 
> syscall(3) is toxic and breaks randomly on some platforms.

+1

And while cleaning the LTP[1] testcases, we are slowly extracting the
special cases into commont code.

[1] http://linux-test-project.github.io/

-- 
Cyril Hrubis
chrubis@suse.cz
