Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552AbaHTHmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 03:42:00 -0400
Received: from mail-bn1lp0141.outbound.protection.outlook.com ([207.46.163.141]:11701
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750745AbaHTHl7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 03:41:59 -0400
From: "Bharat.Bhushan@freescale.com" <Bharat.Bhushan@freescale.com>
To: Yijing Wang <wangyijing@huawei.com>,
        "arnab.basu@freescale.com" <arnab.basu@freescale.com>
CC: Xinwei Hu <huxinwei@huawei.com>, Wuyun <wuyun.wu@huawei.com>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Paul.Mundt@huawei.com" <Paul.Mundt@huawei.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        Hanjun Guo <guohanjun@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH 00/11] Refactor MSI to support Non-PCI device
Thread-Topic: [RFC PATCH 00/11] Refactor MSI to support Non-PCI device
Thread-Index: AQHPqHv7jv5fHomORk6cPW1m/YxYGZvZEMCQgAAeSgCAAA5eIA==
Date: Wed, 20 Aug 2014 07:41:55 +0000
Message-ID: <c3b2bd89ef3d462cb302f6ede56a0d44@BLUPR03MB566.namprd03.prod.outlook.com>
References: <1406344128-27055-1-git-send-email-wangyijing@huawei.com>
 <c6d34fe1bbe9457ea8cff7dcd97902b8@DM2PR03MB317.namprd03.prod.outlook.com>
 <53DEF80C.1010608@huawei.com>
 <8a2b4e237f2d4c7e95ef72867658b53a@BLUPR03MB566.namprd03.prod.outlook.com>
 <53F44022.6030706@huawei.com>
In-Reply-To: <53F44022.6030706@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.169.1]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 03094A4065
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(189002)(51704005)(41574002)(377454003)(13464003)(199003)(85852003)(76176999)(2656002)(80022001)(66066001)(54356999)(21056001)(20776003)(50986999)(64706001)(105586002)(74502001)(99286002)(77982001)(93886004)(46102001)(31966008)(87936001)(86362001)(92566001)(15202345003)(81342001)(76576001)(108616004)(83072002)(99396002)(106116001)(76482001)(33646002)(106356001)(4396001)(74662001)(83322001)(101416001)(107046002)(95666004)(19580405001)(74316001)(15975445006)(79102001)(81542001)(85306004)(19580395003)(24736002)(217873001)(422495003);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB309;H:BLUPR03MB566.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-pci-owner@vger.kernel.org [mailto:linux-pci-owner@vger.kernel.org]
> On Behalf Of Yijing Wang
> Sent: Wednesday, August 20, 2014 11:59 AM
> To: Bhushan Bharat-R65777; Basu Arnab-B45036
> Cc: Xinwei Hu; Wuyun; Bjorn Helgaas; linux-pci@vger.kernel.org;
> Paul.Mundt@huawei.com; James E.J. Bottomley; Marc Zyngier; linux-arm-
> kernel@lists.infradead.org; Russell King; linux-arch@vger.kernel.org;
> virtualization@lists.linux-foundation.org; Hanjun Guo; linux-
> kernel@vger.kernel.org
> Subject: Re: [RFC PATCH 00/11] Refactor MSI to support Non-PCI device
> 
> >> The key difference between PCI device and Non-PCI MSI is the
> >> interfaces to access hardware MSI registers.
> >> for instance, currently, msi_chip->setup_irq() to setup MSI irq and
> >> configure the MSI address/data registers, so we need to provide
> >> device specific
> >> write_msi_msg() interface, then when we call msi_chip->setup_irq(),
> >> the device MSI registers can be configured appropriately.
> >
> > What if we can register/override the setup_irq() from bus-driver (not sure,
> but may be device-driver itself). Example PCI bus-driver will provide
> setup_irq() (or the part of setup_irq which set address and data in h/w) by PCI
> bus, which configure address/data in h/w as per PCI standard.
> >
> > We in Freescale will be using MSI for the devices behind a new-bus (which is
> not PCI based), We have a separate bus driver for same. And this new bus driver
> register/provide its own address/data write function which is based on that
> specific bus protocol.
> 
> Hi Bharat, I'm glad to know your MSI device working mode.
> Provide the private MSI setup functions in bus-driver layer can't apply to all
> Non-PCI MSI devices, because we can not guarantee Non-PCI MSI devices are always
> on a bus. The existing HPET, DMAR device both have no bus bind.

Yes, that's why I was not sure of bus-driver or device-driver model.

> I'm working on a
> new MSI setup framework, as you mentioned before, in device-driver model.
> 
> I abstracted a new virtual device (called struct msi_dev), this msi_dev will
> manage all MSI info,

Will this "struct msi_dev" will be part of "struct device"?

> and a new bus named msi_bus, also introduced a new driver
> msi_driver, msi_bus is responsible for binding msi_dev and msi_driver.
> All MSI devices will be classified into different MSI device types, like
> MSI_TYPE_PCI, MSI_TYPE_HPET, MSI_TYPE_DMAR, etc..
> 
> Each MSI type device should provide a private struct msi_driver. msi_driver
> should contain the type specific MSI ops functions to help setup and enable MSI
> device, request MSI irq.
> 
> I almost finish the first draft, and will post out next week in plan :)

Will be looking forward to next version.

Thanks
-Bharat

> 
> 
> Thanks!
> Yijing.
> 
> >
> > Thanks
> > -Bharat
> >
> >>
> >> My patchset is just a RFC draft, I will update it later, all we want
> >> to do is make kernel support Non-PCI MSI devices.
> >>
> >> Thanks!
> >> Yijing.
> >>
> >>
> >>>
> >>> Thanks
> >>> Arnab
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe
> >>> linux-kernel" in the body of a message to majordomo@vger.kernel.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>> Please read the FAQ at  http://www.tux.org/lkml/
> >>>
> >>> .
> >>>
> >>
> >>
> >> --
> >> Thanks!
> >> Yijing
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-pci"
> >> in the body of a message to majordomo@vger.kernel.org More majordomo
> >> info at http://vger.kernel.org/majordomo-info.html
> >
> > .
> >
> 
> 
> --
> Thanks!
> Yijing
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in the body
> of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
