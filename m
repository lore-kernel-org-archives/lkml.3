Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbaIDK6F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 06:58:05 -0400
Received: from mail-bn1lp0141.outbound.protection.outlook.com ([207.46.163.141]:23394
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750994AbaIDK6D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 06:58:03 -0400
From: Varun Sethi <Varun.Sethi@freescale.com>
To: Joerg Roedel <joro@8bytes.org>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Emilian Medve <Emilian.Medve@freescale.com>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] iommu/fsl: Fix warning resulting from adding PCI device
 twice
Thread-Topic: [PATCH] iommu/fsl: Fix warning resulting from adding PCI device
 twice
Thread-Index: AQHPyAjmU+xzGF6kc0+PtU1tC9Y2lJvwwdQAgAALYdA=
Date: Thu, 4 Sep 2014 10:57:59 +0000
Message-ID: <332f3406b1974ff38aef45cc4f55373a@BL2PR03MB468.namprd03.prod.outlook.com>
References: <1409810622-742-1-git-send-email-Varun.Sethi@freescale.com>
 <20140904101402.GM28786@8bytes.org>
In-Reply-To: <20140904101402.GM28786@8bytes.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [192.88.169.1]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0324C2C0E2
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(189002)(51704005)(24454002)(377454003)(199003)(164054003)(13464003)(81542001)(85306004)(74316001)(79102001)(2656002)(21056001)(81342001)(19580395003)(33646002)(4396001)(83322001)(19580405001)(108616004)(86362001)(31966008)(76576001)(74502001)(87936001)(66066001)(106116001)(107046002)(77982001)(106356001)(105586002)(90102001)(80022001)(20776003)(99396002)(64706001)(54356999)(85852003)(74662001)(83072002)(92566001)(46102001)(50986999)(99286002)(76482001)(76176999)(110136001)(95666004)(101416001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR0301MB0737;H:BL2PR03MB468.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Joerg Roedel [mailto:joro@8bytes.org]
> Sent: Thursday, September 04, 2014 3:44 PM
> To: Sethi Varun-B16395
> Cc: iommu@lists.linux-foundation.org; alex.williamson@redhat.com; Medve
> Emilian-EMMEDVE1; linuxppc-dev@ozlabs.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] iommu/fsl: Fix warning resulting from adding PCI device
> twice
> 
> On Thu, Sep 04, 2014 at 11:33:42AM +0530, Varun Sethi wrote:
> > +	if (!iommu_group_get(dev))
> > +		ret = iommu_group_add_device(group, dev);
> >
> >  	iommu_group_put(group);
> >  	return ret;
> 
> Doesn't this additional call to iommu_group_get take a reference to the
> iommu_group that needs to be released?
Yes, you are right this would take a reference to the group that should be released. I need to add iommu_group_put for decrementing the reference count. Will post a new patch.

Thanks,
Varun


