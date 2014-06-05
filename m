Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373AbaFESqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 14:46:22 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:53539
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751418AbaFESqU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 14:46:20 -0400
From: Varun Sethi <Varun.Sethi@freescale.com>
To: Antonios Motakis <a.motakis@virtualopensystems.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "eric.auger@linaro.org" <eric.auger@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "a.rigo@virtualopensystems.com" <a.rigo@virtualopensystems.com>,
        Stuart Yoder <stuart.yoder@freescale.com>,
        "moderated list:ARM SMMU DRIVER" 
	<linux-arm-kernel@lists.infradead.org>,
        "tech@virtualopensystems.com" <tech@virtualopensystems.com>,
        "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>
Subject: RE: [RFC PATCH v6 04/20] iommu/arm-smmu: add capability
	IOMMU_CAP_INTR_REMAP
Thread-Topic: [RFC PATCH v6 04/20] iommu/arm-smmu: add capability
	IOMMU_CAP_INTR_REMAP
Thread-Index: AQHPgOA2ZTxVs2xl6U+rpueFyk204Jti1oQw
Date: Thu, 5 Jun 2014 18:31:35 +0000
Message-ID: <87aae116ba7a473b85a5a176f300551c@DM2PR03MB479.namprd03.prod.outlook.com>
References: <1401987808-23596-1-git-send-email-a.motakis@virtualopensystems.com>
 <1401987808-23596-5-git-send-email-a.motakis@virtualopensystems.com>
In-Reply-To: <1401987808-23596-5-git-send-email-a.motakis@virtualopensystems.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.169.1]
x-microsoft-antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
x-forefront-prvs: 0233768B38
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(13464003)(377454003)(51704005)(199002)(189002)(2656002)(83322001)(19580405001)(81542001)(77982001)(224303002)(54356999)(99286001)(2171001)(86362001)(85852003)(99396002)(33646001)(81342001)(101416001)(64706001)(74502001)(76576001)(66066001)(224313003)(79102001)(21056001)(76482001)(46102001)(50986999)(80022001)(83072002)(92566001)(77096999)(87936001)(2201001)(20776003)(31966008)(74662001)(76176999)(4396001)(19580395003)(74316001)(24736002)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB350;H:DM2PR03MB479.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
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
> bounces@lists.linux-foundation.org] On Behalf Of Antonios Motakis
> Sent: Thursday, June 05, 2014 10:33 PM
> To: alex.williamson@redhat.com; kvmarm@lists.cs.columbia.edu;
> iommu@lists.linux-foundation.org
> Cc: kvm@vger.kernel.org; eric.auger@linaro.org; open list;
> will.deacon@arm.com; a.rigo@virtualopensystems.com; Yoder Stuart-B08248;
> moderated list:ARM SMMU DRIVER; Antonios Motakis;
> tech@virtualopensystems.com; christoffer.dall@linaro.org
> Subject: [RFC PATCH v6 04/20] iommu/arm-smmu: add capability
> IOMMU_CAP_INTR_REMAP
> 
> With an ARM SMMU, interrupt remapping should always be safe from the
> SMMU's point of view, as it is properly handled by the GIC.
> 
> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> ---
>  drivers/iommu/arm-smmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c index
> 15ab2af..ff29402 100644
> --- a/drivers/iommu/arm-smmu.c
> +++ b/drivers/iommu/arm-smmu.c
> @@ -1544,7 +1544,7 @@ static int arm_smmu_domain_has_cap(struct
> iommu_domain *domain,
>  	if (smmu_domain->root_cfg.smmu->features &
> ARM_SMMU_FEAT_COHERENT_WALK)
>  		caps |= IOMMU_CAP_CACHE_COHERENCY;
> 
> -	caps |= IOMMU_CAP_NOEXEC;
> +	caps |= IOMMU_CAP_NOEXEC | IOMMU_CAP_INTR_REMAP;
> 
>  	return !!(cap & caps);
>  }
Why mention this as an IOMMU capability when IOMMU doesn't support it? Also, wouldn't this depend on the GIC IP version? What are we gaining by adding this IOMMU capability list?

-Varun
