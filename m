Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933601AbaDCAEP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 20:04:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:41066 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933004AbaDCAEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 20:04:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,783,1389772800"; 
   d="scan'208";a="486148432"
Date: Wed, 2 Apr 2014 17:02:18 -0700
From: "David E. Box" <david.e.box@linux.intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/platforms for v3.15
Message-ID: <20140403000218.GA27709@linux.intel.com>
References: <20140401082757.GA23451@gmail.com>
 <CA+55aFzKCVnqYussDpt8Fkoi28SthKRd3oKnSW4GnED+s6QdVQ@mail.gmail.com>
 <533AF612.8020505@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533AF612.8020505@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

My apologies for not getting to address hpa's issues sooner. FWIW I simply
didn't want to force a dependancy on the mbi driver for those drivers that run
on both big core and soc systems, risking that the driver wouldn't run on big
core systems that don't have the mbi compiled in. Luckily we should be able to
make the mbi modular and simply default m and avoid this issue.

David Box

On Tue, Apr 01, 2014 at 10:23:30AM -0700, H. Peter Anvin wrote:
> Hi Linus,
> 
> This one is largely my fault, but it is not for not asking the questions.
> 
> This patch is part of the work of modularizing the IOSF drivers, because
> of course standard distros don't want to compile them in.  However, this
> results in odd problems when IOSF-aware drivers (some of which are
> present on non-IOSF hardware, as there are drivers that operate on both
> PCI and IOSF, some of which are still coming down the pipe toward mainline.)
> 
> It is these dual-mode drivers that make things a bit more complicated
> than it ought to be.
> 
> I have explicitly asked David to work on modularizing the IOSF core,
> even though it is small, exactly to avoid this mess.  However, that
> change didn't make it in time, and I guess I should just have said "no"
> at that point.
> 
> I did not want to not have an option to disable it for EXPERT
> configurations, because we also have people working very hard at shaving
> down the size of the x86 kernel so that Linux rather than "random RTOS
> of the month" can be used in deep embedded configurations.
> 
> On this issue:
> 
> >  (a) people don't know about, so asking people about it is f*cking
> > retarded to begin with
> 
> Well, that is why it is an EXPERT option.
> 
> +	bool "IOSF MBI support" if EXPERT
> 
> 	-hpa
