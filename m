Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350AbaAOHUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 02:20:00 -0500
Received: from smtp.nue.novell.com ([195.135.221.5]:46176 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbaAOHTz (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Wed, 15 Jan 2014 02:19:55 -0500
Subject: Re: [RFT][PATCH] ACPI / init: Run acpi_early_init() before
 efi_enter_virtual_mode()
From: joeyli <jlee@suse.com>
To: Toshi Kani <toshi.kani@hp.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Matt Fleming <matt@console-pimps.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Matthew Garrett <matthew.garrett@nebula.com>, Elliott@hp.com,
        samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>,
        werner@suse.com, trenn@suse.de, JBeulich@suse.com,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-acpi@vger.kernel.org, Borislav Petkov <bp@suse.de>
In-Reply-To: <1389731547.1792.296.camel@misato.fc.hp.com>
References: <1387439053-8711-1-git-send-email-jlee@suse.com>
	 <3476450.BMEcId2Lgj@vostro.rjw.lan>
	 <20131221122148.GB29501@console-pimps.org>
	 <2530951.HFPX8MI38t@vostro.rjw.lan>
	 <1389672548.24105.252.camel@linux-s257.site> <52D57B54.7080509@zytor.com>
	 <1389731547.1792.296.camel@misato.fc.hp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Jan 2014 15:18:02 +0800
Message-ID: <1389770282.24105.259.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 二，2014-01-14 於 13:32 -0700，Toshi Kani 提到：
> > > +       acpi_early_init();
> > >         timekeeping_init();
> > >         time_init();
> > >         sched_clock_postinit();
> > > @@ -641,7 +642,6 @@ asmlinkage void __init start_kernel(void)
> > >  
> > >         check_bugs();
> > >  
> > > -       acpi_early_init(); /* before LAPIC and SMP init */
> > >         sfi_init_late();
> > >  
> > >         if (efi_enabled(EFI_RUNTIME_SERVICES)) {
> > > 
> > 
> > Hi Toshi,
> > 
> > Could you try this variant, too?  If this works as well then we end
> up
> > solving two problems in one patch...
> 
> Hi Peter,
> 
> Yes, this version works fine as well.
> 
> Tested-by: Toshi Kani <toshi.kani@hp.com>
> 
> Thanks,
> -Toshi

Thanks a lot for your testing.

I will re-send a formal patch with changelog to everybody.

Regards
Joey Lee



