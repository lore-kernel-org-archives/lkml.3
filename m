Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbaIKI6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:58:32 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:44144 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbaIKI60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:58:26 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v3 02/17] ARM64 / ACPI: Get RSDP and ACPI boot-time
 tables
To: Catalin Marinas <catalin.marinas@arm.com>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Al Stone <al.stone@linaro.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
In-Reply-To: <20140909162648.GE2910@arm.com>
References: <1409583475-6978-1-git-send-email-hanjun.guo@linaro.org>
	<1409583475-6978-3-git-send-email-hanjun.guo@linaro.org>
	<20140909162648.GE2910@arm.com>
Date: Wed, 10 Sep 2014 22:37:57 +0100
Message-Id: <20140910213757.C7B8CC40E5E@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Sep 2014 17:26:49 +0100, Catalin Marinas <catalin.marinas@arm.com> wrote:
> On Mon, Sep 01, 2014 at 03:57:40PM +0100, Hanjun Guo wrote:
> > diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
> > index c96172a..fb7cc0e 100644
> > --- a/arch/arm64/kernel/setup.c
> > +++ b/arch/arm64/kernel/setup.c
> > @@ -43,6 +43,7 @@
> >  #include <linux/of_fdt.h>
> >  #include <linux/of_platform.h>
> >  #include <linux/efi.h>
> > +#include <linux/acpi.h>
> >  
> >  #include <asm/fixmap.h>
> >  #include <asm/cpu.h>
> > @@ -385,6 +386,9 @@ void __init setup_arch(char **cmdline_p)
> >  	efi_init();
> >  	arm64_memblock_init();
> >  
> > +	/* Parse the ACPI tables for possible boot-time configuration */
> > +	acpi_boot_table_init();
> 
> Is there any dummy acpi_boot_table_init() when !CONFIG_ACPI? I couldn't
> see one in this patch, so I don't see how this would compile when ACPI
> is disabled.

It's in include/linux/acpi.h in the !CONFIG_ACPI section.

g.

