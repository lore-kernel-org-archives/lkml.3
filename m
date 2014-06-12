Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbaFLRr0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 13:47:26 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:48821 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaFLRrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 13:47:24 -0400
Message-ID: <5399E7AD.8030901@cogentembedded.com>
Date: Thu, 12 Jun 2014 21:47:25 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: suravee.suthikulpanit@amd.com, tj@kernel.org, b.zolnierkie@samsung.com
CC: hdegoede@redhat.com, lho@apm.com, tphan@apm.com, stripathi@apm.com,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ahci: Check and set 64-bit DMA mask for platform
 AHCI driver
References: <1402594824-4151-1-git-send-email-suravee.suthikulpanit@amd.com> <1402594824-4151-2-git-send-email-suravee.suthikulpanit@amd.com>
In-Reply-To: <1402594824-4151-2-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 06/12/2014 09:40 PM, suravee.suthikulpanit@amd.com wrote:

> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

> The current platform AHCI driver does not set the dma_mask correctly
> for 64-bit DMA capable AHCI controller. This patch checks the AHCI
> capability bit and set the dma_mask and coherent_dma_mask accordingly.

> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Reviewed-by: Hans de Goede <hdegoede@redhat.com>
> ---
>   drivers/ata/libahci_platform.c | 13 +++++++++++++
>   1 file changed, 13 insertions(+)

> diff --git a/drivers/ata/libahci_platform.c b/drivers/ata/libahci_platform.c
> index 3a5b4ed..a958a2b 100644
> --- a/drivers/ata/libahci_platform.c
> +++ b/drivers/ata/libahci_platform.c
> @@ -364,6 +364,19 @@ int ahci_platform_init_host(struct platform_device *pdev,
>   			ap->ops = &ata_dummy_port_ops;
>   	}
>
> +	if (hpriv->cap & HOST_CAP_64) {
> +		rc = dma_coerce_mask_and_coherent(dev, DMA_BIT_MASK(64));
> +		if (rc) {
> +			rc = dma_coerce_mask_and_coherent(dev,
> +							  DMA_BIT_MASK(32));
> +			if (rc) {
> +				dev_err(dev, "Failed to enable 64-bit DMA.\n");

    Not 32-bit?

> +				return rc;
> +			}
> +			dev_warn(dev, "Enable 32-bit DMA instead of 64-bit.\n");
> +		}
> +	}
> +

WBR, Sergei

