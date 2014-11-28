Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351AbaK1B6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 20:58:34 -0500
Received: from mail-bn1bn0106.outbound.protection.outlook.com ([157.56.110.106]:41632
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751209AbaK1B6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 20:58:32 -0500
X-Greylist: delayed 872 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Nov 2014 20:58:32 EST
X-WSS-ID: 0NFQ7H6-07-BOK-02
X-M-MSG: 
Message-ID: <1417138411.2591.14.camel@kxue-X58A-UD3R>
Subject: Re: [PATCH] acpi:apd:add AMD ACPI2Platform device support for x86
 system.
From: Ken Xue <Ken.Xue@amd.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Jeff" <Jeff.Wu@amd.com>,
        Andriy Shevchenko <andriy.shevchenko@intel.com>
Date: Fri, 28 Nov 2014 09:33:31 +0800
In-Reply-To: <20141127114637.GA1304@lahna.fi.intel.com>
References: <1416290291-5802-1-git-send-email-Ken.Xue@amd.com>
	 <20864469.6Ozf1NSibZ@vostro.rjw.lan>
	 <4AC89B18A26BAB43B540DB1C94E2802C05A48D06@scybexdag03.amd.com>
	 <2267517.glgofXUn7B@vostro.rjw.lan>
	 <1416997898.17328.5.camel@kxue-X58A-UD3R>
	 <20141127114637.GA1304@lahna.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(979002)(6009001)(428002)(54534003)(24454002)(377424004)(189002)(199003)(377454003)(51704005)(95666004)(93886004)(20776003)(64706001)(105586002)(50986999)(102836001)(76176999)(104166001)(103116003)(110136001)(33646002)(106466001)(107046002)(47776003)(21056001)(77156002)(62966003)(46102003)(87936001)(101416001)(87286001)(89996001)(88136002)(31966008)(23676002)(50226001)(97736003)(4396001)(44976005)(92726001)(19580395003)(120916001)(86362001)(92566001)(19580405001)(93916002)(68736004)(99396003)(84676001)(33716001)(50466002)(99106002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB199;H:atltwp01.amd.com;FPR:;SPF:None;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB199;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB199;
X-Forefront-PRVS: 04097B7F7F
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Ken.Xue@amd.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB199;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-27 at 13:46 +0200, Mika Westerberg wrote:
> On Wed, Nov 26, 2014 at 06:31:38PM +0800, Ken Xue wrote:
> > On Monday, 2014-11-24 at 02:47 +0100, Rafael J. Wysocki wrote:
> > > On Monday, November 24, 2014 01:02:30 AM Xue, Ken wrote:
> > > > 
> > > > On Tuesday, November 18, 2014 01:58:11 PM Ken Xue wrote:
> > > > > This new feature is to interpret AMD specific ACPI device to platform 
> > > > > device such as I2C, UART found on AMD CZ and later chipsets. It is 
> > > > > based on example INTEL LPSS. Now, it can support AMD I2C & UART.
> > > > > 
> > > > > Signed-off-by: Ken Xue <Ken.Xue@amd.com>
> > > > > Signed-off-by: Jeff Wu <Jeff.Wu@amd.com>
> > > > 
> > > > Generally speaking, this seems to duplicate much code from acpi_lpss which should be re-used instead.  What about moving the code that will be common between acpi_lpss and the new driver into a new file (say acpi_soc.c)?
> > > > 
> > > > Also, you need to avoid automatic creation of platform devices when !X86_AMD_PLATFORM_DEVICE in analogy with what acpi_lpss does, or bad things will happen.
> > > > 
> > > > [ken] sounds fair enough.  Let me take action to merge drivers to acpi_soc.c ? or you have other plan?
> > > 
> > > I'd prefer the common code to reside in one file (or one .c file and one header
> > > file), and the driver-specific code to stay in separate per-driver files.
> > > 
> > [Ken] I wrote a proto type for acpi_soc.c. please help to confirm if it
> > can match your ideal. if yes, i will submit a new patch after do more
> > test and refine codes. I think it will impact lpss driver greatly, even
> > i have taken it into account. below codes is for acpi_soc.c.
> 
> In general looks good. I have few comments though.
[Ken] thanks for your comments.

> > 
> > >From fc323fb7b3b4cbb79bda05ce3b1d6d8dfe5e883b Mon Sep 17 00:00:00 2001
> > From: Ken Xue <Ken.Xue@amd.com>
> > Date: Wed, 26 Nov 2014 17:15:30 +0800
> > Subject: [PATCH] This is proto type for acpi_soc.
> > 
> > Signed-off-by: Ken Xue <Ken.Xue@amd.com>
> > ---
> >  arch/x86/Kconfig        |  11 +++
> >  drivers/acpi/Makefile   |   2 +-
> >  drivers/acpi/acpi_apd.c | 123 ++++++++++++++++++++++++++++
> >  drivers/acpi/acpi_soc.c | 213
> > ++++++++++++++++++++++++++++++++++++++++++++++++
> 
> This is line-wrapped, please make sure when you submit the actual patch
> that it is formatted properly. Also you need proper changelog etc.
[Ken] sure. 

> > +#include "internal.h"
> > +#include "acpi_soc.h"
> > +
> > +struct acpi_soc asoc;
> 
> static?
> 
> Also Is "asoc" good name? That might get confused with Alsa SoC (ASoC).
[Ken] I will use "static", and change name to be a_soc.


> > +
> > +static struct acpi_soc_dev_desc cz_i2c_desc = {
> > +	.setup = acpi_apd_setup;
> > +	.fixed_clk_rate = 133000000,
> 
> Oh, good so now we can get rid the hack we did for
> i2c-designware-platdrv.c with this commit:
> 
> a445900c906092f i2c: designware: Add support for AMD I2C controller
> 
> Since now you have means to pass clock to the driver.
> 
> Are you going to handle that driver as well?
[Ken]sure, thanks. this was one of reasons to create AMD APD.

> > +};
> > +
> > +static struct acpi_soc_dev_desc cz_uart_desc = {
> > +	.setup = acpi_apd_setup;
> > +	.fixed_clk_rate = 48000000,
> > +};
> > +
> > +#else
> > +
> > +#define APD_ADDR(desc) (0UL)
> > +
> > +#endif /* CONFIG_X86_INTEL_LPSS */
> > +
> > +static struct acpi_device_id acpi_apd_device_ids[] = {
> 
> const?
[ken]No. "acpi_soc_dev_desc" may be modified later.

> > +	/* Generic apd devices */
> > +	{ "AMD0010", APD_ADDR(cz_i2c_desc) },
> > +	{ "AMD0020", APD_ADDR(cz_uart_desc) },
> > +	{ }
> > +};
> > +
> > +#ifdef X86_AMD_PLATFORM_DEVICE
> > +
> > +static ssize_t apd_device_desc_show(struct device *dev,
> > +				struct device_attribute *attr, char *buf)
> > +{
> > +	int ret;
> > +	struct acpi_device *adev;
> > +	struct acpi_soc_dev_private_data *pdata;
> > +	struct acpi_soc_dev_desc *dev_desc;
> > +
> > +	ret = acpi_bus_get_device(ACPI_HANDLE(dev), &adev);
> > +	if (WARN_ON(ret))
> > +		return ret;
> > +
> > +	pdata = acpi_driver_data(adev);
> > +	if (WARN_ON(!pdata || !pdata->dev_desc))
> > +		return -ENODEV;
> > +	
> > +	dev_desc = pdata->dev_desc;
> > +	if (dev_desc->fixed_clk_rate)
> > +		return sprintf(buf, "Required fix rate clk %s: %ld\n",
> > +			dev_desc->clk->name,
> > +			dev_desc->fixed_clk_rate);
> > +	else
> > +		return sprintf(buf, "No need clk\n");
> > +}
> > +
> > +static DEVICE_ATTR(device_desc, S_IRUSR, apd_device_desc_show, NULL);
> > +
> > +static struct attribute *apd_attrs[] = {
> > +	&dev_attr_device_desc.attr,
> > +	NULL,
> > +};
> > +
> > +static struct attribute_group apd_attr_group = {
> > +	.attrs = apd_attrs,
> > +	.name = "apd",
> > +};
> 
> This requires updating sysfs ABI but then again, do you really need the
> above? And does it belong to sysfs in the first place?
[Ken] just want to output some debug information with sysfs. I think i
can add sysfs interface after APD has rich features in the future.

> > 
> > +#include "internal.h"
> > +#include "acpi_soc.h"
> > +
> > +
> 
> Delete the extra blank line
[ken] got it.

> >
> > +	pdata->dev_desc = dev_desc;
> > +
> > +	/*setup device by a hook routine*/
> 
> The comment should look like this
> 
> 	/* Setup device by hook routine */
> 
> but I think it does not provide any new information so you can just drop
> it.
[Ken] i will remove it.

> > +
> > +void register_acpi_soc(struct acpi_soc *asoc, bool
> > disable_scan_handler)
> > +{
> > +	struct acpi_scan_handler *acpi_soc_handler;
> > +	
> > +	INIT_LIST_HEAD(&asoc->list);
> > +	list_add(&asoc->list, &asoc_list);
> > +
> > +	acpi_soc_handler = kzalloc(sizeof(struct acpi_scan_handler),
> > GFP_KERNEL);
> > +	acpi_soc_handler->ids = asoc->ids;
> > +	if (!disable_scan_handler) {
> > +		acpi_soc_handler->attach = acpi_soc_create_device;
> > +		acpi_soc_handler->bind = acpi_soc_bind;
> > +		acpi_soc_handler->unbind = acpi_soc_unbind;
> > +	}	
> > +	acpi_scan_add_handler(acpi_soc_handler);
> > +	bus_register_notifier(&platform_bus_type, &acpi_soc_nb);
> > +}
> > +EXPORT_SYMBOL_GPL(register_acpi_soc);
> 
> I don't think we want to export these to modules.
[ken]i will remove it.


> > +
> > +/**
> > + * struct acpi_soc_dev_private_data - acpi device private data
> > + * @mmio_base: virtual memory base addr of the device
> > + * @mmio_size: device memory size
> > + * @dev_desc: device description
> > + * @adev: apci device
> > + *
> 
> Delete the above line.
[Ken]ok.




