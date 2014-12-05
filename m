Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704AbaLEGyu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 01:54:50 -0500
Received: from mail-by2on0102.outbound.protection.outlook.com ([207.46.100.102]:63488
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751394AbaLEGys convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 01:54:48 -0500
X-Greylist: delayed 151816 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Dec 2014 01:54:48 EST
X-WSS-ID: 0NG3KJ3-08-209-02
X-M-MSG: 
Message-ID: <1417761854.29484.25.camel@kxue-X58A-UD3R>
Subject: Re: [PATCH 2/2] acpi:apd:add AMD ACPI2Platform device support
From: Ken Xue <Ken.Xue@amd.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: <rjw@rjwysocki.net>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date: Fri, 5 Dec 2014 14:44:14 +0800
In-Reply-To: <20141204115848.GL28857@lahna.fi.intel.com>
References: <1417610072-2217-1-git-send-email-Ken.Xue@amd.com>
	 <20141204115848.GL28857@lahna.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(377424004)(51704005)(24454002)(19580395003)(101416001)(31966008)(19580405001)(103116003)(33646002)(23676002)(84676001)(68736005)(77096005)(87936001)(50986999)(76176999)(86362001)(575784001)(89996001)(92566001)(20776003)(120916001)(99396003)(64706001)(62966003)(77156002)(110136001)(105586002)(107046002)(106466001)(97736003)(50466002)(4396001)(21056001)(46102003)(50226001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB198;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB198;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601002);SRVR:BN1PR02MB198;
X-Forefront-PRVS: 04163EF38A
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Ken.Xue@amd.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB198;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-12-04 at 13:58 +0200, Mika Westerberg wrote:
> On Wed, Dec 03, 2014 at 08:34:32PM +0800, Ken Xue wrote:
> > This is a new feature to interpret AMD specific ACPI device to
> > platform device such as I2C, UART found on AMD CZ and later
> > chipsets. It based on INTEL LPSS and acpi soc.
> > 
> > Signed-off-by: Ken Xue <Ken.Xue@amd.com>
> > ---
> >  arch/x86/Kconfig        | 11 +++++++
> >  drivers/acpi/Makefile   |  2 +-
> >  drivers/acpi/acpi_apd.c | 82 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  drivers/acpi/internal.h |  6 ++++
> >  drivers/acpi/scan.c     |  1 +
> >  5 files changed, 101 insertions(+), 1 deletion(-)
> >  create mode 100644 drivers/acpi/acpi_apd.c
> 
> Trying to compile this with !X86_AMD_PLATFORM_DEVICE gives me
> 
> drivers/acpi/acpi_apd.c:74:13: error: redefinition of ‘acpi_apd_init’
>  void __init acpi_apd_init(void)
>              ^
> In file included from drivers/acpi/acpi_apd.c:22:0:
> drivers/acpi/internal.h:74:20: note: previous definition of ‘acpi_apd_init’ was here
>  static inline void acpi_apd_init(void) {}
>                     ^
> scripts/Makefile.build:257: recipe for target 'drivers/acpi/acpi_apd.o' failed
> make[2]: *** [drivers/acpi/acpi_apd.o] Error 1
> make[2]: *** Waiting for unfinished jobs....
> 
> 
[Ken] sorry for it. it is my mistake.

> > 
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index ded8a67..6402c79f 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -495,6 +495,17 @@ config X86_INTEL_LPSS
> >  	  things like clock tree (common clock framework) and pincontrol
> >  	  which are needed by the LPSS peripheral drivers.
> >  
> > +config X86_AMD_PLATFORM_DEVICE
> > +	bool "AMD ACPI2Platform devices support"
> > +	depends on ACPI
> > +	select COMMON_CLK
> > +	select PINCTRL
> > +	---help---
> > +	  Select to interpret AMD specific ACPI device to platform device
> > +	  such as I2C, UART found on AMD CARRIZO and later chipset. Selecting
> > +	  this option enables things like clock tree (common clock framework)
> > +	  and pinctrl.
> > +
> >  config IOSF_MBI
> >  	tristate "Intel SoC IOSF Sideband support for SoC platforms"
> >  	depends on PCI
> > diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
> > index ae3397d..b07003a 100644
> > --- a/drivers/acpi/Makefile
> > +++ b/drivers/acpi/Makefile
> > @@ -40,7 +40,7 @@ acpi-$(CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC) += processor_pdc.o
> >  acpi-y				+= ec.o
> >  acpi-$(CONFIG_ACPI_DOCK)	+= dock.o
> >  acpi-y				+= pci_root.o pci_link.o pci_irq.o
> > -acpi-y				+= acpi_soc.o acpi_lpss.o
> > +acpi-y				+= acpi_soc.o acpi_lpss.o acpi_apd.o
> >  acpi-y				+= acpi_platform.o
> >  acpi-y				+= acpi_pnp.o
> >  acpi-y				+= int340x_thermal.o
> > diff --git a/drivers/acpi/acpi_apd.c b/drivers/acpi/acpi_apd.c
> > new file mode 100644
> > index 0000000..9afc144
> > --- /dev/null
> > +++ b/drivers/acpi/acpi_apd.c
> > @@ -0,0 +1,82 @@
> > +/*
> > + * AMD ACPI support for  ACPI2platform device.
> > + *
> > + * Copyright (c) 2014, AMD Corporation.
> > + * Authors: Ken Xue <Ken.Xue@amd.com>
> > + *	Wu, Jeff <Jeff.Wu@amd.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +
> > +#include <linux/acpi.h>
> > +#include <linux/clk.h>
> > +#include <linux/clkdev.h>
> > +#include <linux/clk-provider.h>
> > +#include <linux/err.h>
> > +#include <linux/io.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/pm_runtime.h>
> 
> Are you sure you need all those headers?
> 
[ken] refine it with next release.

> > +#include "internal.h"
> > +#include "acpi_soc.h"
> > +
> > +struct acpi_soc asoc;
> > +
> > +#ifdef CONFIG_X86_AMD_PLATFORM_DEVICE
> > +#define APD_ADDR(desc)	((unsigned long)&desc)
> > +
> > +static int acpi_apd_setup(struct acpi_soc_dev_private_data *pdata)
> > +{
> > +	struct acpi_soc_dev_desc *dev_desc = pdata->dev_desc;
> > +	struct clk *clk = ERR_PTR(-ENODEV);
> > +
> > +	if (dev_desc->clk)
> > +		return 0;
> > +
> > +	if (dev_desc->fixed_clk_rate) {
> > +		clk = clk_register_fixed_rate(&pdata->adev->dev,
> > +					dev_name(&pdata->adev->dev),
> > +					NULL, CLK_IS_ROOT,
> > +					dev_desc->fixed_clk_rate);
> > +		dev_desc->clk = clk;
> > +		clk_register_clkdev(clk, NULL, dev_name(&pdata->adev->dev));
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static struct acpi_soc_dev_desc cz_i2c_desc = {
> > +	.setup = acpi_apd_setup,
> > +	.fixed_clk_rate = 133000000,
> > +};
> > +
> > +static struct acpi_soc_dev_desc cz_uart_desc = {
> > +	.setup = acpi_apd_setup,
> > +	.fixed_clk_rate = 48000000,
> > +};
> > +
> > +#else
> > +
> > +#define APD_ADDR(desc) (0UL)
> > +
> > +#endif /* CONFIG_X86_AMD_PLATFORM_DEVICE */
> > +
> > +static struct acpi_device_id acpi_apd_device_ids[] = {
> > +	/* Generic apd devices */
> > +	{ "AMD0010", APD_ADDR(cz_i2c_desc) },
> > +	{ "AMD0020", APD_ADDR(cz_uart_desc) },
> > +	{ }
> > +};
> > +
> > +
> 
> Double blank line.
> 
[Ken] got it. thanks.

> > +void __init acpi_apd_init(void)
> > +{
> > +	asoc.ids = acpi_apd_device_ids;
> > +#ifdef CONFIG_X86_AMD_PLATFORM_DEVICE
> > +	register_acpi_soc(&asoc, false);
> > +#else
> > +	register_acpi_soc(&asoc, true);
> > +#endif /*CONFIG_X86_AMD_PLATFORM_DEVICE*/
> > +}
> > diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
> > index 447f6d6..c8a0e8e 100644
> > --- a/drivers/acpi/internal.h
> > +++ b/drivers/acpi/internal.h
> > @@ -68,6 +68,12 @@ static inline void acpi_debugfs_init(void) { return; }
> >  #endif
> >  void acpi_lpss_init(void);
> >  
> > +#ifdef CONFIG_X86_AMD_PLATFORM_DEVICE
> > +void acpi_apd_init(void);
> > +#else
> > +static inline void acpi_apd_init(void) {}
> > +#endif
> > +
> >  acpi_status acpi_hotplug_schedule(struct acpi_device *adev, u32 src);
> >  bool acpi_queue_hotplug_work(struct work_struct *work);
> >  void acpi_device_hotplug(struct acpi_device *adev, u32 src);
> > diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> > index 0476e90..24fef2b 100644
> > --- a/drivers/acpi/scan.c
> > +++ b/drivers/acpi/scan.c
> > @@ -2349,6 +2349,7 @@ int __init acpi_scan_init(void)
> >  	acpi_pci_link_init();
> >  	acpi_processor_init();
> >  	acpi_lpss_init();
> > +	acpi_apd_init();
> >  	acpi_cmos_rtc_init();
> >  	acpi_container_init();
> >  	acpi_memory_hotplug_init();
> > -- 
> > 1.9.1


