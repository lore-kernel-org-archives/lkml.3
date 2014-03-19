Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759082AbaCSLc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 07:32:59 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:43270 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758612AbaCSLc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 07:32:58 -0400
Date: Wed, 19 Mar 2014 12:32:54 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, linux-kernel@vger.kernel.org,
        acme@infradead.org, eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH 4/4] perf/x86/uncore: modularize Intel uncore driver
Message-ID: <20140319113254.GA18351@gmail.com>
References: <1395133004-23205-1-git-send-email-zheng.z.yan@intel.com>
 <1395133004-23205-4-git-send-email-zheng.z.yan@intel.com>
 <20140319084917.GE27632@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140319084917.GE27632@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, Mar 18, 2014 at 04:56:44PM +0800, Yan, Zheng wrote:
> > This patch adds support for building Intel uncore driver as module.
> > It adds clean-up code and config option for the Intel uncore driver
> > 
> > Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> > ---
> >  arch/x86/Kconfig                              |  7 ++++
> >  arch/x86/configs/i386_defconfig               |  1 +
> >  arch/x86/configs/x86_64_defconfig             |  1 +
> >  arch/x86/kernel/cpu/Makefile                  |  3 +-
> >  arch/x86/kernel/cpu/perf_event_intel_uncore.c | 48 ++++++++++++++++++++++++---
> >  5 files changed, 55 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index 0af5250..8e4e247 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -1103,6 +1103,13 @@ config X86_CPUID
> >  	  with major 203 and minors 0 to 31 for /dev/cpu/0/cpuid to
> >  	  /dev/cpu/31/cpuid.
> >  
> > +config X86_INTEL_UNCORE
> > +	tristate "Intel uncore performance monitoring support"
> > +	depends on CPU_SUP_INTEL
> > +	---help---
> > +	  This adds a driver to access the Uncore performance monitoring Units
> > +	  of Intel processors.
> > +
> 
> Ingo do you agree with this config option placement?

Yeah, the modularization looks mostly good to me, but its name should 
lie within the PERF namespace, i.e. CONFIG_PERF_PMU_X86_INTEL_UNCORE=y.

Thanks,

	Ingo
