Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420Ab3FWKQK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 06:16:10 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:38013 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab3FWKQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 06:16:04 -0400
Date: Sun, 23 Jun 2013 12:15:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Greg KH <greg@kroah.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Status of __cpuinit removal
Message-ID: <20130623101559.GC19021@gmail.com>
References: <519AA53F.1020107@zytor.com>
 <20130520231203.GA21682@kroah.com>
 <20130528092038.GC32068@gmail.com>
 <CAP=VYLo047g+U3GJhkObJtNPubFNpHuGUJAF7oOh_7dPtSFd9A@mail.gmail.com>
 <20130612005605.GA7469@kroah.com>
 <20130620174659.GA17945@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130620174659.GA17945@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Gortmaker <paul.gortmaker@windriver.com> wrote:

> As some of you are probably aware, a decision to remove __cpuinit and
> variants was made, since the cost/complexity outweighs the amount of
> memory reclaim that it provides.  Details of that decision are at:
> 
> 	https://lkml.org/lkml/2013/5/20/589
> 
> It seems that the suggestion to do this was partly motivated by the
> fix in commit 5e427ec2 ("x86: Fix bit corruption at CPU resume time").
> It is a good example of the nasty type of bugs that can be created
> with improper use of the various types of __init prefixes.
> 
> I have created a patch queue against the latest linux-next tree (Jun20)
> that removes all the variants of __cpuinit and the asm __CPUINIT variants,
> and the surrounding infrastructure for section handling of it.  There
> are no Kconfig changes; this is complex enough.  We can independently
> revisit later whether keeping CPU_HOTPLUG makes sense or not.
> 
> I have done this in 33 commits.  I decided against a giant monolithic
> patch for several reasons:

[...]

>  scripts/mod/modpost.c                         | 52 ++++------------------
>  307 files changed, 895 insertions(+), 1036 deletions(-)

Cool, thanks Paul for addressing all this!

Thanks,

	Ingo
