Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbaIITL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 15:11:57 -0400
Received: from mail-by2on0109.outbound.protection.outlook.com ([207.46.100.109]:38816
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751285AbaIITLz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 15:11:55 -0400
X-Greylist: delayed 1102 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Sep 2014 15:11:55 EDT
From: Varun Sethi <Varun.Sethi@freescale.com>
To: Joerg Roedel <joro@8bytes.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Joerg Roedel" <jroedel@suse.de>
Subject: RE: [PATCH 05/12] iommu/fsl: Convert to iommu_capable() API function
Thread-Topic: [PATCH 05/12] iommu/fsl: Convert to iommu_capable() API function
Thread-Index: AQHPyPeXadFLQZWCz0qs3N5S2212M5v5KEaw
Date: Tue, 9 Sep 2014 18:38:37 +0000
Message-ID: <d7e88d93cf5546a18b0f6c8ef199c577@BL2PR03MB468.namprd03.prod.outlook.com>
References: <1409914384-21191-1-git-send-email-joro@8bytes.org>
 <1409914384-21191-6-git-send-email-joro@8bytes.org>
In-Reply-To: <1409914384-21191-6-git-send-email-joro@8bytes.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [182.69.93.41]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0329B15C8A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019018)(6009001)(377454003)(189002)(51704005)(199003)(13464003)(54356999)(81542001)(20776003)(85306004)(90102001)(105586002)(76576001)(77982001)(108616004)(19580395003)(106116001)(21056001)(66066001)(64706001)(80022001)(107046002)(79102001)(19580405001)(106356001)(74502001)(92566001)(83072002)(33646002)(99396002)(86362001)(101416001)(74662001)(99286002)(2656002)(85852003)(46102001)(4396001)(83322001)(31966008)(87936001)(95666004)(81342001)(50986999)(76482001)(74316001)(76176999)(97736003)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB466;H:BL2PR03MB468.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Joerg Roedel [mailto:joro@8bytes.org]
> Sent: Friday, September 05, 2014 4:23 PM
> To: iommu@lists.linux-foundation.org
> Cc: linux-kernel@vger.kernel.org; Joerg Roedel; Sethi Varun-B16395
> Subject: [PATCH 05/12] iommu/fsl: Convert to iommu_capable() API function
> 
> From: Joerg Roedel <jroedel@suse.de>
> 
> Cc: Varun Sethi <Varun.Sethi@freescale.com>
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  drivers/iommu/fsl_pamu_domain.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/iommu/fsl_pamu_domain.c
> b/drivers/iommu/fsl_pamu_domain.c index 61d1daf..f43a80d 100644
> --- a/drivers/iommu/fsl_pamu_domain.c
> +++ b/drivers/iommu/fsl_pamu_domain.c
> @@ -411,8 +411,7 @@ static phys_addr_t fsl_pamu_iova_to_phys(struct
> iommu_domain *domain,
>  	return get_phys_addr(dma_domain, iova);  }
> 
> -static int fsl_pamu_domain_has_cap(struct iommu_domain *domain,
> -				      unsigned long cap)
> +static bool fsl_pamu_capable(enum iommu_cap cap)
>  {
>  	return cap == IOMMU_CAP_CACHE_COHERENCY;  } @@ -1074,6
> +1073,7 @@ static u32 fsl_pamu_get_windows(struct iommu_domain
> *domain)  }
> 
>  static const struct iommu_ops fsl_pamu_ops = {
> +	.capable	= fsl_pamu_capable,
>  	.domain_init	= fsl_pamu_domain_init,
>  	.domain_destroy = fsl_pamu_domain_destroy,
>  	.attach_dev	= fsl_pamu_attach_device,
> @@ -1083,7 +1083,6 @@ static const struct iommu_ops fsl_pamu_ops = {
>  	.domain_get_windows = fsl_pamu_get_windows,
>  	.domain_set_windows = fsl_pamu_set_windows,
>  	.iova_to_phys	= fsl_pamu_iova_to_phys,
> -	.domain_has_cap = fsl_pamu_domain_has_cap,
>  	.domain_set_attr = fsl_pamu_set_domain_attr,
>  	.domain_get_attr = fsl_pamu_get_domain_attr,
>  	.add_device	= fsl_pamu_add_device,
Acked-by: Varun Sethi <varun.sethi@freescale.com>
