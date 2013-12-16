Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab3LPKOF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 05:14:05 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:61433 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab3LPKOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 05:14:02 -0500
Date: Mon, 16 Dec 2013 11:13:59 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: intel-mid: make X86_INTEL_MID depending on SFI
Message-ID: <20131216101359.GB21304@gmail.com>
References: <1387049004-21622-1-git-send-email-david.a.cohen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387049004-21622-1-git-send-email-david.a.cohen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Cohen <david.a.cohen@linux.intel.com> wrote:

> Despite our intention to not make Intel MID dependent of SFI, it does
> not reflect the current situation.
> If SFI is not selected, Intel MID can't select APB_TIMER otherwise this
> happens:
> 
> arch/x86/built-in.o: In function `apbt_set_mapping':
> arch/x86/kernel/apb_timer.c:91: undefined reference to `sfi_get_mtmr'
> arch/x86/kernel/apb_timer.c:109: undefined reference to `sfi_free_mtmr'
> arch/x86/kernel/apb_timer.c:112: undefined reference to `sfi_get_mtmr'
> arch/x86/kernel/apb_timer.c:91: undefined reference to `sfi_get_mtmr'
> arch/x86/kernel/apb_timer.c:109: undefined reference to `sfi_free_mtmr'
> arch/x86/kernel/apb_timer.c:112: undefined reference to `sfi_get_mtmr'
> 
> This patch solves such problem by adding SFI as dependence of
> X86_INTEL_MID. As soon as we make Intel MID completely independent of
> SFI this patch is safe to be reverted.
> 
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> ---
> 
> This patch is intended to be applied on kernel 3.13-rc release.
> 
> As a matter of curiosity, CONFIG_APB_TIMER does depend on CONFIG_SFI. But looks
> like CONFIG_X86_INTEL_MID is able to bypass it.
> Maybe we need to check Kconfig itself too?
> 
>  arch/x86/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 00fa3b7d2abe..5802476d4e91 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -447,6 +447,7 @@ config X86_INTEL_MID
>  	depends on PCI
>  	depends on PCI_GOANY
>  	depends on X86_IO_APIC
> +	depends on SFI
>  	select DW_APB_TIMER
>  	select APB_TIMER
>  	select INTEL_SCU_IPC

Can SFI be selected instead? That's what CONFIG_X86_MDFLD does, and 
it's a conceptual extension of 'select DW_APB_TIMER'.

Thanks,

	Ingo
