Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbaF0V5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 17:57:37 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:37284
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752799AbaF0V5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 17:57:36 -0400
From: "Chalamarla, Tirumalesh" <Tirumalesh.Chalamarla@caviumnetworks.com>
To: Will Deacon <will.deacon@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC: Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "stuart.yoder@freescale.com" <stuart.yoder@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "tech@virtualopensystems.com" <tech@virtualopensystems.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "moderated list:ARM SMMU DRIVER" 
	<linux-arm-kernel@lists.infradead.org>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>
Subject: RE: [RFC PATCH v6 04/20] iommu/arm-smmu: add capability
 IOMMU_CAP_INTR_REMAP
Thread-Topic: [RFC PATCH v6 04/20] iommu/arm-smmu: add capability
 IOMMU_CAP_INTR_REMAP
Thread-Index: AQHPgOBbNdL1uGTtt0GgwoLMBshUy5tnB9yAgAzb7QCAAAWEgIAAAl8AgAAA+ACAAAOpAIAP3+jggAAC4JCAAAc+EIAABbCAgAAA8PCAAAkgAIAA3P4AgADcBgA=
Date: Fri, 27 Jun 2014 21:57:28 +0000
Message-ID: <2645e3a22f5e4ae9994c0ee8fa327cb4@BY2PR07MB203.namprd07.prod.outlook.com>
References: <20140616151329.GQ16758@arm.com>
 <20140616152157.GB31771@8bytes.org> <20140616152526.GR16758@arm.com>
 <20140616153832.GC31771@8bytes.org>
 <9353770066894e85809e1e443b71d1cd@BY2PR07MB203.namprd07.prod.outlook.com>
 <748dccbbd3284521af4659ccbbb11453@BY2PR07MB203.namprd07.prod.outlook.com>
 <b085e02e72dc424d9624c3e810951087@BY2PR07MB203.namprd07.prod.outlook.com>
 <1403809223.31091.137.camel@ul30vt.home>
 <ec8dbbcb991e4d73b73f4b4f98342445@BY2PR07MB203.namprd07.prod.outlook.com>
 <1403811384.31091.151.camel@ul30vt.home> <20140627084722.GB26276@arm.com>
In-Reply-To: <20140627084722.GB26276@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [64.2.3.195]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(377424004)(51704005)(377454003)(13464003)(189002)(199002)(164054003)(51914003)(107046002)(50986999)(74316001)(64706001)(76176999)(80022001)(99396002)(77096002)(105586002)(54356999)(101416001)(46102001)(20776003)(99286002)(95666004)(106356001)(85306003)(79102001)(74502001)(31966008)(74662001)(93886003)(4396001)(76482001)(77982001)(87936001)(106116001)(66066001)(81342001)(33646001)(2656002)(19580405001)(76576001)(86362001)(19580395003)(83072002)(83322001)(85852003)(21056001)(92566001)(81542001)(24736002)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR07MB202;H:BY2PR07MB203.namprd07.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5RLvoXb028916

Marc,

         What is your opinion on ITS emulation . is it should be part of KVM or VFIO.
        Also this code needs to depend on ITS host driver a lot, Host ITS driver needs to have an interface for this code to use.

Thanks,
 Tirumalesh
     
-----Original Message-----
From: Will Deacon [mailto:will.deacon@arm.com] 
Sent: Friday, June 27, 2014 1:47 AM
To: Alex Williamson
Cc: Chalamarla, Tirumalesh; Joerg Roedel; kvm@vger.kernel.org; open list; stuart.yoder@freescale.com; iommu@lists.linux-foundation.org; tech@virtualopensystems.com; kvmarm@lists.cs.columbia.edu; moderated list:ARM SMMU DRIVER; marc.zyngier@arm.com
Subject: Re: [RFC PATCH v6 04/20] iommu/arm-smmu: add capability IOMMU_CAP_INTR_REMAP

On Thu, Jun 26, 2014 at 08:36:24PM +0100, Alex Williamson wrote:
> On Thu, 2014-06-26 at 19:10 +0000, Chalamarla, Tirumalesh wrote:
> > Thanks for the clarification Alex, Thatâ€™s exactly my point, why are 
> > we relying on  QEMU or something else to emulate the MSI space when 
> > we can directly give access to devices using ITS (of course with a 
> > small emulation code).  This way we are also benefited from all ITS 
> > services like VCPU migration etc.
> 
> I have no idea what ITS is.

ITS is the MSI doorbell for GICv3 (ARM's latest interrupt controller).

I agree that we will need an ITS emulation if we want to use MSIs in the guest, and I believe that Marc (CC'd) had already started thinking about that.


> > What about non QEMU VFIO users, for example, if I wanted to use VFIO to
> > assign a device to a user process I don't need to depend on QEMU.   I
> > thought this is one of the main goals of vfio to make it independent of
> > hypervisors.     
> 
> Where did QEMU become a requirement?  Maybe I'm missing something in 
> the ARM part of the conversation that got chopped off, but this is 
> exactly why we have the VFIO/QEMU split that we do.  VFIO provides 
> basic virtualization for config space and restricts access to other 
> areas that users shouldn't be allowed to change.  QEMU is just one 
> example of a userspace VFIO driver.  QEMU takes the decomposed device 
> exposed through the VFIO ABI and re-creates a PCI device out of it.  
> VFIO itself has no dependency on QEMU.  Thanks,

I also don't understand the QEMU part here. The MSI emulation would be in the kernel, just like the GICv2 emulation that we already have. For userspace drivers, wouldn't you just use eventfd rather than bother with emulating MSIs?

Finally, the interrupt remapping part is about the SMMU preventing MSI writes to arbitrary portions of the host address space. The ITS is about routing interrupts to CPUs.

Will
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
