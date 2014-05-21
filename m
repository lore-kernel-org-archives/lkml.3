Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaEUHPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 03:15:33 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:43830
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750972AbaEUHPb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 03:15:31 -0400
From: Varun Sethi <Varun.Sethi@freescale.com>
To: "Bharat.Bhushan@freescale.com" <Bharat.Bhushan@freescale.com>,
        "Rickard Strandqvist" <rickard_strandqvist@spectrumdigital.se>,
        Joerg Roedel <joro@8bytes.org>, Grant Likely <grant.likely@linaro.org>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "Rob Herring" <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] iommu: fsl_pamu.c: Fix for possible null pointer
	dereference
Thread-Topic: [PATCH] iommu: fsl_pamu.c: Fix for possible null pointer
	dereference
Thread-Index: AQHPdKjpYr6pXPlsTkyFEE04O0cV/JtKjDEg
Date: Wed, 21 May 2014 07:15:28 +0000
Message-ID: <687709ad1a974bf5a2508b2e78b316d3@BL2PR03MB468.namprd03.prod.outlook.com>
References: <1400347004-25368-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <28189d9037d244729e10f7b1a22005c5@BLUPR03MB566.namprd03.prod.outlook.com>
In-Reply-To: <28189d9037d244729e10f7b1a22005c5@BLUPR03MB566.namprd03.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.169.1]
x-forefront-prvs: 0218A015FA
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(13464003)(52604005)(51704005)(189002)(199002)(377454003)(101416001)(31966008)(54356999)(77096999)(224303002)(74502001)(87936001)(4396001)(77982001)(76576001)(21056001)(86362001)(50986999)(81542001)(33646001)(64706001)(46102001)(224313003)(80022001)(99286001)(76176999)(83322001)(85852003)(66066001)(2656002)(74662001)(81342001)(15975445006)(99396002)(74316001)(19580405001)(83072002)(76482001)(92566001)(20776003)(19580395003)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB561;H:BL2PR03MB468.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Varun.Sethi@freescale.com; 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: iommu-bounces@lists.linux-foundation.org [mailto:iommu-
> bounces@lists.linux-foundation.org] On Behalf Of
> Bharat.Bhushan@freescale.com
> Sent: Wednesday, May 21, 2014 9:28 AM
> To: Rickard Strandqvist; Joerg Roedel; Grant Likely
> Cc: devicetree@vger.kernel.org; iommu@lists.linux-foundation.org; Rob
> Herring; linux-kernel@vger.kernel.org
> Subject: RE: [PATCH] iommu: fsl_pamu.c: Fix for possible null pointer
> dereference
> 
> 
> 
> > -----Original Message-----
> > From: iommu-bounces@lists.linux-foundation.org [mailto:iommu-
> > bounces@lists.linux-foundation.org] On Behalf Of Rickard Strandqvist
> > Sent: Saturday, May 17, 2014 10:47 PM
> > To: Joerg Roedel; Grant Likely
> > Cc: devicetree@vger.kernel.org; iommu@lists.linux-foundation.org; Rob
> > Herring; linux-kernel@vger.kernel.org; Rickard Strandqvist
> > Subject: [PATCH] iommu: fsl_pamu.c: Fix for possible null pointer
> > dereference
> >
> > There is otherwise a risk of a possible null pointer dereference.
> 
> You are right.
[Sethi Varun-B16395] Thanks for pointing out the issue.
> 
> >
> > Was largely found by using a static code analysis program called
> cppcheck.
> >
> > Signed-off-by: Rickard Strandqvist
> > <rickard_strandqvist@spectrumdigital.se>
> 
> Reviewed-by: Bharat Bhushan <bharat.bhushan@freescale.com>
Acknowledged-by: Varun Sethi <Varun.Sethi@freescale.com>

> > ---
> >  drivers/iommu/fsl_pamu.c |    3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/drivers/iommu/fsl_pamu.c b/drivers/iommu/fsl_pamu.c index
> > cba0498..b99dd88 100644
> > --- a/drivers/iommu/fsl_pamu.c
> > +++ b/drivers/iommu/fsl_pamu.c
> > @@ -592,8 +592,7 @@ found_cpu_node:
> >  		/* advance to next node in cache hierarchy */
> >  		node = of_find_node_by_phandle(*prop);
> >  		if (!node) {
> > -			pr_debug("Invalid node for cache hierarchy %s\n",
> > -				node->full_name);
> > +			pr_debug("Invalid node for cache hierarchy\n");
> >  			return ~(u32)0;
> >  		}
> >  	}
> > --
> > 1.7.10.4
> >
> > _______________________________________________
> > iommu mailing list
> > iommu@lists.linux-foundation.org
> > https://lists.linuxfoundation.org/mailman/listinfo/iommu
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu
