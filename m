Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863Ab3LWSqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 13:46:19 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:56723 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753774Ab3LWSqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 13:46:16 -0500
Message-ID: <52B884C6.7030600@ti.com>
Date: Mon, 23 Dec 2013 12:45:26 -0600
From: "Anna, Suman" <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Florian Vaussard <florian.vaussard@epfl.ch>,
        Joerg Roedel <joro@8bytes.org>, Tony Lindgren <tony@atomide.com>,
        =?ISO-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/7] iommu/omap: omap_iommu_attach() should return ENODEV,
 not NULL
References: <1387284818-28739-1-git-send-email-florian.vaussard@epfl.ch> <1387284818-28739-3-git-send-email-florian.vaussard@epfl.ch>
In-Reply-To: <1387284818-28739-3-git-send-email-florian.vaussard@epfl.ch>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2013 06:53 AM, Florian Vaussard wrote:
> omap_iommu_attach() returns NULL or ERR_PTR in case of error, but
> omap_iommu_attach_dev() only checks for IS_ERR. Thus a NULL return value (in
> case driver_find_device fails) will cause the kernel to panic when
> omap_iommu_attach_dev() dereferences the pointer.
>
> In such case, omap_iommu_attach() should return ENODEV, not NULL.
>
> Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>

Acked-by: Suman Anna <s-anna@ti.com>

> ---
>   drivers/iommu/omap-iommu.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
> index ee83bcc..385bf5e 100644
> --- a/drivers/iommu/omap-iommu.c
> +++ b/drivers/iommu/omap-iommu.c
> @@ -863,7 +863,7 @@ static int device_match_by_alias(struct device *dev, void *data)
>    **/
>   static struct omap_iommu *omap_iommu_attach(const char *name, u32 *iopgd)
>   {
> -	int err = -ENOMEM;
> +	int err = -ENODEV;
>   	struct device *dev;
>   	struct omap_iommu *obj;
>
> @@ -871,7 +871,7 @@ static struct omap_iommu *omap_iommu_attach(const char *name, u32 *iopgd)
>   				(void *)name,
>   				device_match_by_alias);
>   	if (!dev)
> -		return NULL;
> +		return ERR_PTR(err);
>
>   	obj = to_iommu(dev);
>
>

