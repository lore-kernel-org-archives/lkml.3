Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628AbaEUD6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 23:58:21 -0400
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:39632
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751322AbaEUD6T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 23:58:19 -0400
From: "Bharat.Bhushan@freescale.com" <Bharat.Bhushan@freescale.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Joerg Roedel <joro@8bytes.org>, Grant Likely <grant.likely@linaro.org>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "Rob Herring" <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] iommu: fsl_pamu.c: Fix for possible null pointer
 dereference
Thread-Topic: [PATCH] iommu: fsl_pamu.c: Fix for possible null pointer
 dereference
Thread-Index: AQHPdItTuP5Dqz0NcE2Tsh9PkDTo5JtKaEOA
Date: Wed, 21 May 2014 03:58:15 +0000
Message-ID: <28189d9037d244729e10f7b1a22005c5@BLUPR03MB566.namprd03.prod.outlook.com>
References: <1400347004-25368-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1400347004-25368-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.169.1]
x-forefront-prvs: 0218A015FA
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(199002)(189002)(377454003)(51704005)(13464003)(81342001)(76176999)(101416001)(86362001)(54356999)(76576001)(33646001)(50986999)(15975445006)(74316001)(81542001)(92566001)(99396002)(77096999)(83072002)(4396001)(31966008)(19580395003)(77982001)(99286001)(76482001)(83322001)(74502001)(87936001)(64706001)(66066001)(20776003)(21056001)(74662001)(79102001)(85852003)(46102001)(2656002)(80022001)(19580405001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB568;H:BLUPR03MB566.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Bharat.Bhushan@freescale.com; 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: iommu-bounces@lists.linux-foundation.org [mailto:iommu-
> bounces@lists.linux-foundation.org] On Behalf Of Rickard Strandqvist
> Sent: Saturday, May 17, 2014 10:47 PM
> To: Joerg Roedel; Grant Likely
> Cc: devicetree@vger.kernel.org; iommu@lists.linux-foundation.org; Rob Herring;
> linux-kernel@vger.kernel.org; Rickard Strandqvist
> Subject: [PATCH] iommu: fsl_pamu.c: Fix for possible null pointer dereference
> 
> There is otherwise a risk of a possible null pointer dereference.

You are right. 

> 
> Was largely found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Reviewed-by: Bharat Bhushan <bharat.bhushan@freescale.com>


Thanks
-Bharat

> ---
>  drivers/iommu/fsl_pamu.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/iommu/fsl_pamu.c b/drivers/iommu/fsl_pamu.c index
> cba0498..b99dd88 100644
> --- a/drivers/iommu/fsl_pamu.c
> +++ b/drivers/iommu/fsl_pamu.c
> @@ -592,8 +592,7 @@ found_cpu_node:
>  		/* advance to next node in cache hierarchy */
>  		node = of_find_node_by_phandle(*prop);
>  		if (!node) {
> -			pr_debug("Invalid node for cache hierarchy %s\n",
> -				node->full_name);
> +			pr_debug("Invalid node for cache hierarchy\n");
>  			return ~(u32)0;
>  		}
>  	}
> --
> 1.7.10.4
> 
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu
