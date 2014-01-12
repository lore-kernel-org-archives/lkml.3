Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751214AbaALJG4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 04:06:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42492 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbaALJGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 04:06:39 -0500
Date: Sun, 12 Jan 2014 10:06:27 +0100
From: Borislav Petkov <bp@suse.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Matt Fleming <matt@console-pimps.org>, "H. Peter Anvin" <hpa@zytor.com>,
        joeyli <jlee@suse.com>, Alessandro Zummo <a.zummo@towertech.it>,
        Matthew Garrett <matthew.garrett@nebula.com>, Elliott@hp.com,
        samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>,
        werner@suse.com, trenn@suse.de, JBeulich@suse.com,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-acpi@vger.kernel.org, Toshi Kani <toshi.kani@hp.com>
Subject: Re: [RFT][PATCH] ACPI / init: Run acpi_early_init() before
 efi_enter_virtual_mode() (was: Re: [RFC PATCH 00/14] Support timezone of
 ACPI TAD and EFI TIME)
Message-ID: <20140112090627.GB3668@pd.tnic>
References: <1387439053-8711-1-git-send-email-jlee@suse.com>
 <3476450.BMEcId2Lgj@vostro.rjw.lan>
 <20131221122148.GB29501@console-pimps.org>
 <2530951.HFPX8MI38t@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2530951.HFPX8MI38t@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 12, 2014 at 01:30:23AM +0100, Rafael J. Wysocki wrote:
> I don't see any adverse effects of the patch below on a couple of my test
> boxes, but (a) they are Intel-based and (b) they are non-EFI, so it would be
> good to give it a go on as many machines as reasonably possible.
> 
> Thanks,
> Rafael
> 
> ---
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: ACPI / init: Run acpi_early_init() before efi_enter_virtual_mode()
> 
> According to Matt Fleming, if acpi_early_init() was executed befpre
> efi_enter_virtual_mode(), the EFI initialization could benefit from
> it, so make that happen.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  init/main.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-pm/init/main.c
> ===================================================================
> --- linux-pm.orig/init/main.c
> +++ linux-pm/init/main.c
> @@ -615,6 +615,7 @@ asmlinkage void __init start_kernel(void
>  	calibrate_delay();
>  	pidmap_init();
>  	anon_vma_init();
> +	acpi_early_init();
>  #ifdef CONFIG_X86
>  	if (efi_enabled(EFI_RUNTIME_SERVICES))
>  		efi_enter_virtual_mode();
> @@ -641,7 +642,6 @@ asmlinkage void __init start_kernel(void
>  
>  	check_bugs();
>  
> -	acpi_early_init(); /* before LAPIC and SMP init */
>  	sfi_init_late();
>  
>  	if (efi_enabled(EFI_RUNTIME_SERVICES)) {
>

Looks good both on kvm+OVMF and on my Dell EFI box.

Tested-by: Borislav Petkov <bp@suse.de>

Toshi has a big EFI box though - if he could run it too, that would be
great :-)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
