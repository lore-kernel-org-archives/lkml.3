Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944AbaHTFoY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 01:44:24 -0400
Received: from mail-by2lp0243.outbound.protection.outlook.com ([207.46.163.243]:27244
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750971AbaHTFoV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 01:44:21 -0400
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
Thread-Index: AQHPqHv7jv5fHomORk6cPW1m/YxYGZvZEMCQ
Date: Wed, 20 Aug 2014 05:44:17 +0000
Message-ID: <8a2b4e237f2d4c7e95ef72867658b53a@BLUPR03MB566.namprd03.prod.outlook.com>
References: <1406344128-27055-1-git-send-email-wangyijing@huawei.com>
 <c6d34fe1bbe9457ea8cff7dcd97902b8@DM2PR03MB317.namprd03.prod.outlook.com>
 <53DEF80C.1010608@huawei.com>
In-Reply-To: <53DEF80C.1010608@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.169.1]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 03094A4065
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(189002)(51704005)(41574002)(377454003)(13464003)(199003)(85852003)(76176999)(2656002)(80022001)(66066001)(79102001)(54356999)(21056001)(20776003)(64706001)(50986999)(105586002)(74502001)(99286002)(77982001)(46102001)(31966008)(86362001)(15202345003)(87936001)(92566001)(81342001)(76576001)(108616004)(83072002)(99396002)(106116001)(76482001)(33646002)(106356001)(4396001)(74662001)(83322001)(101416001)(107046002)(95666004)(19580405001)(74316001)(15975445006)(81542001)(85306004)(19580395003)(24736002)(217873001)(422495003);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB309;H:BLUPR03MB566.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yijing

> -----Original Message-----
> From: linux-pci-owner@vger.kernel.org [mailto:linux-pci-owner@vger.kernel.org]
> On Behalf Of Yijing Wang
> Sent: Monday, August 04, 2014 8:34 AM
> To: Basu Arnab-B45036
> Cc: Xinwei Hu; Wuyun; Bjorn Helgaas; linux-pci@vger.kernel.org;
> Paul.Mundt@huawei.com; James E.J. Bottomley; Marc Zyngier; linux-arm-
> kernel@lists.infradead.org; Russell King; linux-arch@vger.kernel.org;
> virtualization@lists.linux-foundation.org; Hanjun Guo; linux-
> kernel@vger.kernel.org
> Subject: Re: [RFC PATCH 00/11] Refactor MSI to support Non-PCI device
> 
> >> MSI was introduced in PCI Spec 2.2. Currently, kernel MSI driver
> >> codes are bonding with PCI device. Because MSI has a lot advantages in
> design.
> >> More and more non-PCI devices want to use MSI as their default interrupt.
> >> The existing MSI device include HPET. HPET driver provide its own MSI
> >> code to initialize and process MSI interrupts. In the latest GIC v3
> >> spec, legacy device can deliver MSI by the help of a relay device
> >> named consolidator.
> >> Consolidator can translate the legacy interrupts connected to it to
> >> MSI/MSI-X. And new non-PCI device will be designed to support MSI in
> >> future. So make the MSI driver code be generic will help the non-PCI
> >> device use MSI more simply.
> >
> > As per my understanding the GICv3 provides a service that will convert writes
> to a specified address to IRQs delivered to the core and as you mention above
> MSIs are part of the PCI spec. So I can see a strong case for non-PCI devices to
> want MSI like functionality without being fully compliant with the requirements
> of the MSI spec.
> 
> In GICv3, MBI is named for the service, but there is no more detailed
> information about it, only we can know is MBI is analogous to MSI, MBI devices
> must have address/data registers, but other registers like enable/mask/ctrl are
> not mandatory requirement.
> I don't know whether the MBI spec will be release, but anyway I think MSI
> refactoring is make sense, there are some existing Non-PCI MSI device like hpet,
> dmar.
> For simplicity, let name MSI and MBI to MSI temporarily.
> >
> > My question is do we necessarily want to rework so much of the PCI-MSI layer
> to support non PCI devices? Or will it be sufficient to create a framework to
> allow non PCI devices to hook up with a device that can convert their writes to
> an IRQ to the core.
> >
> > As I understand it, the msi_chip is (almost) such a framework. The only
> problem being that it makes some PCI specific assumptions (such as PCI specific
> writes from within msi_chip functions). Won't it be sufficient to make the
> msi_chip framework generic enough to be used by non-PCI devices and let each
> bus/device manage any additional requirements (such as configuration flow, bit
> definitions etc) that it places on message based interrupts?
> 
> msi_chip framework is important to support that, but I think maybe it's not
> enough, msi_chip is only responsible for IRQ allocation, teardown, etc..
> 
> The key difference between PCI device and Non-PCI MSI is the interfaces to
> access hardware MSI registers.
> for instance, currently, msi_chip->setup_irq() to setup MSI irq and configure
> the MSI address/data registers, so we need to provide device specific
> write_msi_msg() interface, then when we call msi_chip->setup_irq(), the device
> MSI registers can be configured appropriately.

What if we can register/override the setup_irq() from bus-driver (not sure, but may be device-driver itself). Example PCI bus-driver will provide setup_irq() (or the part of setup_irq which set address and data in h/w) by PCI bus, which configure address/data in h/w as per PCI standard. 

We in Freescale will be using MSI for the devices behind a new-bus (which is not PCI based), We have a separate bus driver for same. And this new bus driver register/provide its own address/data write function which is based on that specific bus protocol.

Thanks
-Bharat

> 
> My patchset is just a RFC draft, I will update it later, all we want to do is
> make kernel support Non-PCI MSI devices.
> 
> Thanks!
> Yijing.
> 
> 
> >
> > Thanks
> > Arnab
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-kernel" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
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
