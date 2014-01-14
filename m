Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbaANQcB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:32:01 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:28874 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbaANQb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:31:59 -0500
Message-ID: <1389716758.1792.282.camel@misato.fc.hp.com>
Subject: Re: [RFT][PATCH] ACPI / init: Run acpi_early_init() before
 efi_enter_virtual_mode() (was: Re: [RFC PATCH 00/14] Support timezone of
 ACPI TAD and EFI TIME)
From: Toshi Kani <toshi.kani@hp.com>
To: Borislav Petkov <bp@suse.de>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Matt Fleming <matt@console-pimps.org>,
        "H. Peter Anvin" <hpa@zytor.com>, joeyli <jlee@suse.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Matthew Garrett <matthew.garrett@nebula.com>, Elliott@hp.com,
        samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>,
        werner@suse.com, trenn@suse.de, JBeulich@suse.com,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-acpi@vger.kernel.org
Date: Tue, 14 Jan 2014 09:25:58 -0700
In-Reply-To: <1389665096.1792.271.camel@misato.fc.hp.com>
References: <1387439053-8711-1-git-send-email-jlee@suse.com>
	 <3476450.BMEcId2Lgj@vostro.rjw.lan>
	 <20131221122148.GB29501@console-pimps.org>
	 <2530951.HFPX8MI38t@vostro.rjw.lan> <20140112090627.GB3668@pd.tnic>
	 <1389665096.1792.271.camel@misato.fc.hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-13 at 19:04 -0700, Toshi Kani wrote:
> On Sun, 2014-01-12 at 10:06 +0100, Borislav Petkov wrote:
> > On Sun, Jan 12, 2014 at 01:30:23AM +0100, Rafael J. Wysocki wrote:
> > > I don't see any adverse effects of the patch below on a couple of my test
> > > boxes, but (a) they are Intel-based and (b) they are non-EFI, so it would be
> > > good to give it a go on as many machines as reasonably possible.
> > > 
> > > Thanks,
> > > Rafael
> > > 
> > > ---
> > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > Subject: ACPI / init: Run acpi_early_init() before efi_enter_virtual_mode()
> > > 
> > > According to Matt Fleming, if acpi_early_init() was executed befpre
> > > efi_enter_virtual_mode(), the EFI initialization could benefit from
> > > it, so make that happen.
> > > 
> > > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > ---
> > >  init/main.c |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > Index: linux-pm/init/main.c
> > > ===================================================================
> > > --- linux-pm.orig/init/main.c
> > > +++ linux-pm/init/main.c
> > > @@ -615,6 +615,7 @@ asmlinkage void __init start_kernel(void
> > >  	calibrate_delay();
> > >  	pidmap_init();
> > >  	anon_vma_init();
> > > +	acpi_early_init();
> > >  #ifdef CONFIG_X86
> > >  	if (efi_enabled(EFI_RUNTIME_SERVICES))
> > >  		efi_enter_virtual_mode();
> > > @@ -641,7 +642,6 @@ asmlinkage void __init start_kernel(void
> > >  
> > >  	check_bugs();
> > >  
> > > -	acpi_early_init(); /* before LAPIC and SMP init */
> > >  	sfi_init_late();
> > >  
> > >  	if (efi_enabled(EFI_RUNTIME_SERVICES)) {
> > >
> > 
> > Looks good both on kvm+OVMF and on my Dell EFI box.
> > 
> > Tested-by: Borislav Petkov <bp@suse.de>
> > 
> > Toshi has a big EFI box though - if he could run it too, that would be
> > great :-)
> 
> Yes, I will test the change.

Tested-by: Toshi Kani <toshi.kani@hp.com>

Thanks,
-Toshi

