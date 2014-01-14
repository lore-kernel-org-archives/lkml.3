Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbaANSBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 13:01:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54263 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbaANSBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 13:01:43 -0500
Message-ID: <52D57B54.7080509@zytor.com>
Date: Tue, 14 Jan 2014 10:00:52 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: joeyli <jlee@suse.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Toshi Kani <toshi.kani@hp.com>
CC: Matt Fleming <matt@console-pimps.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Matthew Garrett <matthew.garrett@nebula.com>, Elliott@hp.com,
        samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>,
        werner@suse.com, trenn@suse.de, JBeulich@suse.com,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-acpi@vger.kernel.org, Borislav Petkov <bp@suse.de>
Subject: Re: [RFT][PATCH] ACPI / init: Run acpi_early_init() before efi_enter_virtual_mode()
References: <1387439053-8711-1-git-send-email-jlee@suse.com>	 <3476450.BMEcId2Lgj@vostro.rjw.lan>	 <20131221122148.GB29501@console-pimps.org>	 <2530951.HFPX8MI38t@vostro.rjw.lan> <1389672548.24105.252.camel@linux-s257.site>
In-Reply-To: <1389672548.24105.252.camel@linux-s257.site>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2014 08:09 PM, joeyli wrote:
> 
> This patch works to me on Acer Gateway Z5WT2 UEFI notebook and Intel
> UEFI development board.
> 
> Does it possible move acpi_early_init() to before timekeeping_init()?
> The position is also before efi_enter_virtual_mode() and that will be
> useful for parsing ACPI TAD to set system clock:
> 
> diff --git a/init/main.c b/init/main.c
> index febc511..b6d93c8 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -565,6 +565,7 @@ asmlinkage void __init start_kernel(void)
>         init_timers();
>         hrtimers_init();
>         softirq_init();
> +       acpi_early_init();
>         timekeeping_init();
>         time_init();
>         sched_clock_postinit();
> @@ -641,7 +642,6 @@ asmlinkage void __init start_kernel(void)
>  
>         check_bugs();
>  
> -       acpi_early_init(); /* before LAPIC and SMP init */
>         sfi_init_late();
>  
>         if (efi_enabled(EFI_RUNTIME_SERVICES)) {
> 

Hi Toshi,

Could you try this variant, too?  If this works as well then we end up
solving two problems in one patch...

	-hpa



