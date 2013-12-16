Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab3LPSCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 13:02:16 -0500
Received: from mga14.intel.com ([143.182.124.37]:63805 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754743Ab3LPSCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 13:02:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,496,1384329600"; 
   d="scan'208";a="328262377"
Date: Mon, 16 Dec 2013 10:07:02 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: intel-mid: make X86_INTEL_MID depending on SFI
Message-ID: <20131216180702.GA6250@psi-dev26.jf.intel.com>
References: <1387049004-21622-1-git-send-email-david.a.cohen@linux.intel.com>
 <20131216101359.GB21304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131216101359.GB21304@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 11:13:59AM +0100, Ingo Molnar wrote:
> 
> * David Cohen <david.a.cohen@linux.intel.com> wrote:
> 
> > Despite our intention to not make Intel MID dependent of SFI, it does
> > not reflect the current situation.
> > If SFI is not selected, Intel MID can't select APB_TIMER otherwise this
> > happens:
> > 
> > arch/x86/built-in.o: In function `apbt_set_mapping':
> > arch/x86/kernel/apb_timer.c:91: undefined reference to `sfi_get_mtmr'
> > arch/x86/kernel/apb_timer.c:109: undefined reference to `sfi_free_mtmr'
> > arch/x86/kernel/apb_timer.c:112: undefined reference to `sfi_get_mtmr'
> > arch/x86/kernel/apb_timer.c:91: undefined reference to `sfi_get_mtmr'
> > arch/x86/kernel/apb_timer.c:109: undefined reference to `sfi_free_mtmr'
> > arch/x86/kernel/apb_timer.c:112: undefined reference to `sfi_get_mtmr'
> > 
> > This patch solves such problem by adding SFI as dependence of
> > X86_INTEL_MID. As soon as we make Intel MID completely independent of
> > SFI this patch is safe to be reverted.
> > 
> > Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> > ---
> > 
> > This patch is intended to be applied on kernel 3.13-rc release.
> > 
> > As a matter of curiosity, CONFIG_APB_TIMER does depend on CONFIG_SFI. But looks
> > like CONFIG_X86_INTEL_MID is able to bypass it.
> > Maybe we need to check Kconfig itself too?
> > 
> >  arch/x86/Kconfig | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index 00fa3b7d2abe..5802476d4e91 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -447,6 +447,7 @@ config X86_INTEL_MID
> >  	depends on PCI
> >  	depends on PCI_GOANY
> >  	depends on X86_IO_APIC
> > +	depends on SFI
> >  	select DW_APB_TIMER
> >  	select APB_TIMER
> >  	select INTEL_SCU_IPC
> 
> Can SFI be selected instead? That's what CONFIG_X86_MDFLD does, and 
> it's a conceptual extension of 'select DW_APB_TIMER'.

Right. It makes sense indeed to move SFI line from X86_MDFLD to
X86_INTEL_MID.
But it remembers me I'll have to rework this patch, since X86_MDFLD
doesn't exist in my -next branch anymore:
https://patchwork.kernel.org/patch/3179421/

Br, David Cohen

> 
> Thanks,
> 
> 	Ingo
