Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993AbaF2LRX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 07:17:23 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:59355
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752600AbaF2LRW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 07:17:22 -0400
From: Varun Sethi <Varun.Sethi@freescale.com>
To: Fabian Frederick <fabf@skynet.be>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Grant Likely <grant.likely@linaro.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH 1/1] iommu/fsl_pamu: Remove unnecessary null test before
 kfree
Thread-Topic: [PATCH 1/1] iommu/fsl_pamu: Remove unnecessary null test before
 kfree
Thread-Index: AQHPk3CXIo3RIcTaikyf52TOCEiCnpuH8Cfw
Date: Sun, 29 Jun 2014 11:17:19 +0000
Message-ID: <751871ee83714b789251885d787ae09f@BL2PR03MB468.namprd03.prod.outlook.com>
References: <1404028886-5060-1-git-send-email-fabf@skynet.be>
In-Reply-To: <1404028886-5060-1-git-send-email-fabf@skynet.be>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.169.1]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 025796F161
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(13464003)(199002)(189002)(51704005)(377454003)(95666004)(80022001)(66066001)(74662001)(81542001)(74502001)(85306003)(79102001)(77982001)(46102001)(76482001)(4396001)(76576001)(76176999)(54356999)(83322001)(19580405001)(19580395003)(64706001)(74316001)(106356001)(105586002)(107046002)(50986999)(99396002)(20776003)(106116001)(33646001)(86362001)(101416001)(81342001)(83072002)(85852003)(87936001)(2656002)(21056001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB468;H:BL2PR03MB468.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: iommu-bounces@lists.linux-foundation.org [mailto:iommu-
> bounces@lists.linux-foundation.org] On Behalf Of Fabian Frederick
> Sent: Sunday, June 29, 2014 1:31 PM
> To: linux-kernel@vger.kernel.org
> Cc: Fabian Frederick; Grant Likely; iommu@lists.linux-foundation.org;
> devicetree@vger.kernel.org
> Subject: [PATCH 1/1] iommu/fsl_pamu: Remove unnecessary null test before
> kfree
> 
> Fix checkpatch warning:
> WARNING: kfree(NULL) is safe this check is probably not required
> 
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: iommu@lists.linux-foundation.org
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  drivers/iommu/fsl_pamu_domain.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/iommu/fsl_pamu_domain.c
> b/drivers/iommu/fsl_pamu_domain.c index 93072ba..0009dff 100644
> --- a/drivers/iommu/fsl_pamu_domain.c
> +++ b/drivers/iommu/fsl_pamu_domain.c
> @@ -1118,8 +1118,7 @@ static int fsl_pamu_set_windows(struct iommu_domain
> *domain, u32 w_count)
>  	ret = pamu_set_domain_geometry(dma_domain, &domain->geometry,
>  				((w_count > 1) ? w_count : 0));
>  	if (!ret) {
> -		if (dma_domain->win_arr)
> -			kfree(dma_domain->win_arr);
> +		kfree(dma_domain->win_arr);
>  		dma_domain->win_arr = kzalloc(sizeof(struct dma_window) *
>  							  w_count, GFP_ATOMIC);
>  		if (!dma_domain->win_arr) {

Acked-by: Varun Sethi <varun.sethi@freescale.com>
