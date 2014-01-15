Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbaAONKN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 08:10:13 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51543 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752027AbaAONKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 08:10:06 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <matthew.garrett@nebula.com>, Elliott@hp.com,
        samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>,
        werner@suse.com, trenn@suse.de, JBeulich@suse.com,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-acpi@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] ACPI / init: Run acpi_early_init() before timekeeping_init()
Date: Wed, 15 Jan 2014 14:24:04 +0100
Message-ID: <3042669.sJyHAYrJIM@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc8+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <52D67C3B.4050503@zytor.com>
References: <1389770748-32698-1-git-send-email-jlee@suse.com> <52D67C3B.4050503@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 15, 2014 04:16:59 AM H. Peter Anvin wrote:
> Rafael, you want to take this one?

Yes, I can take it.

Thanks!

> On 01/14/2014 11:25 PM, Lee, Chun-Yi wrote:
> > This is a variant patch from Rafael J. Wysocki's
> > ACPI / init: Run acpi_early_init() before efi_enter_virtual_mode()
> > 
> > According to Matt Fleming, if acpi_early_init() was executed before
> > efi_enter_virtual_mode(), the EFI initialization could benefit from
> > it, so Rafael's patch makes that happen.
> > 
> > And, we want accessing ACPI TAD device to set system clock, so move
> > acpi_early_init() before timekeeping_init(). This final position is
> > also before efi_enter_virtual_mode().
> > 
> > v2:
> > Move acpi_early_init() before timekeeping_init() to prepare setting
> > system clock with ACPI TAD.
> > 
> > v1:
> > Rafael J. Wysocki
> > ACPI / init: Run acpi_early_init() before efi_enter_virtual_mode()
> > 
> > Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
> > Cc: Matt Fleming <matt@console-pimps.org>
> > Cc: H. Peter Anvin <hpa@zytor.com>
> > Cc: Borislav Petkov <bp@suse.de>
> > Cc: Matthew Garrett <matthew.garrett@nebula.com>
> > Tested-by: Toshi Kani <toshi.kani@hp.com>
> > Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> > ---
> >  init/main.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/init/main.c b/init/main.c
> > index febc511..b6d93c8 100644
> > --- a/init/main.c
> > +++ b/init/main.c
> > @@ -565,6 +565,7 @@ asmlinkage void __init start_kernel(void)
> >  	init_timers();
> >  	hrtimers_init();
> >  	softirq_init();
> > +	acpi_early_init();
> >  	timekeeping_init();
> >  	time_init();
> >  	sched_clock_postinit();
> > @@ -641,7 +642,6 @@ asmlinkage void __init start_kernel(void)
> >  
> >  	check_bugs();
> >  
> > -	acpi_early_init(); /* before LAPIC and SMP init */
> >  	sfi_init_late();
> >  
> >  	if (efi_enabled(EFI_RUNTIME_SERVICES)) {
> > 
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
