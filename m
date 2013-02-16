Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490Ab3BPArm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 19:47:42 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:55093 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab3BPArl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 19:47:41 -0500
X-Greylist: delayed 564 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Feb 2013 19:47:41 EST
Date: Sat, 16 Feb 2013 00:38:15 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Shentino <shentino@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] SIGKILL vs. SIGSEGV on late execve() failures
In-Reply-To: <20130216000435.GY4503@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.03.1302160021490.10334@linux-mips.org>
References: <20130214053656.GS4503@ZenIV.linux.org.uk> <CA+55aFz1JjGSCdqXpVz3oH-PWFDE3Qdxt3EVxqC2i=nfLqf0Jw@mail.gmail.com> <20130215215946.GX4503@ZenIV.linux.org.uk> <CAGDaZ_pMLScoO811es3AZxzAnSiS5ixku-DeuEi4FwX8mNv3cQ@mail.gmail.com>
 <20130216000435.GY4503@ZenIV.linux.org.uk>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2013, Al Viro wrote:

> > > +                               send_sig(SIGSEGV, current, 0);
> > 
> > This might be a stupid miscue on my part, but shouldn't it be
> > force_sig instead of send_sig?
> > 
> > I've got this crazy hunch that having SEGV masked might muck something up.
> 
> How would you manage to have it masked at that point?  setup_new_exec()
> is inevitable after success of flush_old_exec() and it will do
> flush_signal_handlers() for us.

 So just to be completely safe here -- is your proposed change going to 
affect processes being traced anyhow?  E.g. won't GDB see some sort of a 
limbo state when the child is terminated this way?  According to ptrace(2) 
man page SIGKILL is the only exception to the usual child signal trapping 
policy.

  Maciej
