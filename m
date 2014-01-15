Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaAOMR4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 07:17:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46868 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbaAOMRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 07:17:51 -0500
Message-ID: <52D67C3B.4050503@zytor.com>
Date: Wed, 15 Jan 2014 04:16:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <matthew.garrett@nebula.com>
CC: Elliott@hp.com, samer.el-haj-mahmoud@hp.com,
        Oliver Neukum <oneukum@suse.de>, werner@suse.com, trenn@suse.de,
        JBeulich@suse.com, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-acpi@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] ACPI / init: Run acpi_early_init() before timekeeping_init()
References: <1389770748-32698-1-git-send-email-jlee@suse.com>
In-Reply-To: <1389770748-32698-1-git-send-email-jlee@suse.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael, you want to take this one?

On 01/14/2014 11:25 PM, Lee, Chun-Yi wrote:
> This is a variant patch from Rafael J. Wysocki's
> ACPI / init: Run acpi_early_init() before efi_enter_virtual_mode()
> 
> According to Matt Fleming, if acpi_early_init() was executed before
> efi_enter_virtual_mode(), the EFI initialization could benefit from
> it, so Rafael's patch makes that happen.
> 
> And, we want accessing ACPI TAD device to set system clock, so move
> acpi_early_init() before timekeeping_init(). This final position is
> also before efi_enter_virtual_mode().
> 
> v2:
> Move acpi_early_init() before timekeeping_init() to prepare setting
> system clock with ACPI TAD.
> 
> v1:
> Rafael J. Wysocki
> ACPI / init: Run acpi_early_init() before efi_enter_virtual_mode()
> 
> Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
> Cc: Matt Fleming <matt@console-pimps.org>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Matthew Garrett <matthew.garrett@nebula.com>
> Tested-by: Toshi Kani <toshi.kani@hp.com>
> Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> ---
>  init/main.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/init/main.c b/init/main.c
> index febc511..b6d93c8 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -565,6 +565,7 @@ asmlinkage void __init start_kernel(void)
>  	init_timers();
>  	hrtimers_init();
>  	softirq_init();
> +	acpi_early_init();
>  	timekeeping_init();
>  	time_init();
>  	sched_clock_postinit();
> @@ -641,7 +642,6 @@ asmlinkage void __init start_kernel(void)
>  
>  	check_bugs();
>  
> -	acpi_early_init(); /* before LAPIC and SMP init */
>  	sfi_init_late();
>  
>  	if (efi_enabled(EFI_RUNTIME_SERVICES)) {
> 

