Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab3LJHTW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 02:19:22 -0500
Received: from mail-by2lp0241.outbound.protection.outlook.com ([207.46.163.241]:3816
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750994Ab3LJHTT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 02:19:19 -0500
X-Greylist: delayed 930 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Dec 2013 02:19:18 EST
From: "Varun.Sethi@freescale.com" <Varun.Sethi@freescale.com>
To: Yijing Wang <wangyijing@huawei.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: RE: [PATCH 2/3] iommu/fsl_pamu: Use dev_is_pci() to check whether
 it is	pci device
Thread-Topic: [PATCH 2/3] iommu/fsl_pamu: Use dev_is_pci() to check whether
 it is	pci device
Thread-Index: AQHO8a8xYksiAVAgEEK9yt3P71UYvJpNByOw
Date: Tue, 10 Dec 2013 07:03:43 +0000
Message-ID: <e6c109cb73384650b07de2361c08f9ba@BL2PR03MB468.namprd03.prod.outlook.com>
References: <1386243769-22672-1-git-send-email-wangyijing@huawei.com>
In-Reply-To: <1386243769-22672-1-git-send-email-wangyijing@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.169.1]
x-forefront-prvs: 005671E15D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(199002)(189002)(13464003)(51704005)(377454003)(81686001)(2656002)(87936001)(56816005)(90146001)(80976001)(74316001)(85306002)(224313003)(74366001)(87266001)(74662001)(81342001)(74876001)(49866001)(19580405001)(83322001)(19580395003)(224303002)(81816001)(54356001)(4396001)(81542001)(66066001)(59766001)(77982001)(51856001)(80022001)(76482001)(46102001)(76576001)(79102001)(65816001)(47446002)(54316002)(47976001)(47736001)(50986001)(74706001)(63696002)(74502001)(53806001)(76796001)(56776001)(83072002)(76786001)(69226001)(33646001)(85852003)(31966008)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB468;H:BL2PR03MB468.namprd03.prod.outlook.com;CLIP:192.88.169.1;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: iommu-bounces@lists.linux-foundation.org [mailto:iommu-
> bounces@lists.linux-foundation.org] On Behalf Of Yijing Wang
> Sent: Thursday, December 05, 2013 5:13 PM
> To: Alex Williamson; Joerg Roedel
> Cc: iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org;
> Hanjun Guo
> Subject: [PATCH 2/3] iommu/fsl_pamu: Use dev_is_pci() to check whether it
> is pci device
> 
> Use PCI standard marco dev_is_pci() instead of directly compare
> pci_bus_type to check whether it is pci device.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> ---
>  drivers/iommu/fsl_pamu_domain.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/iommu/fsl_pamu_domain.c
> b/drivers/iommu/fsl_pamu_domain.c index c857c30..93072ba 100644
> --- a/drivers/iommu/fsl_pamu_domain.c
> +++ b/drivers/iommu/fsl_pamu_domain.c
> @@ -691,7 +691,7 @@ static int fsl_pamu_attach_device(struct iommu_domain
> *domain,
>  	 * Use LIODN of the PCI controller while attaching a
>  	 * PCI device.
>  	 */
> -	if (dev->bus == &pci_bus_type) {
> +	if (dev_is_pci(dev)) {
>  		pdev = to_pci_dev(dev);
>  		pci_ctl = pci_bus_to_host(pdev->bus);
>  		/*
> @@ -729,7 +729,7 @@ static void fsl_pamu_detach_device(struct
> iommu_domain *domain,
>  	 * Use LIODN of the PCI controller while detaching a
>  	 * PCI device.
>  	 */
> -	if (dev->bus == &pci_bus_type) {
> +	if (dev_is_pci(dev)) {
>  		pdev = to_pci_dev(dev);
>  		pci_ctl = pci_bus_to_host(pdev->bus);
>  		/*
> @@ -1056,7 +1056,7 @@ static int fsl_pamu_add_device(struct device *dev)
>  	 * For platform devices we allocate a separate group for
>  	 * each of the devices.
>  	 */
> -	if (dev->bus == &pci_bus_type) {
> +	if (dev_is_pci(dev)) {
>  		pdev = to_pci_dev(dev);
>  		/* Don't create device groups for virtual PCI bridges */
>  		if (pdev->subordinate)
> --
> 1.7.1
Acked-by: Varun Sethi <varun.sethi@freescale.com>
