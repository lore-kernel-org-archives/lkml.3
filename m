Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816AbaJQJoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 05:44:18 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54783 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbaJQJoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 05:44:16 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-55-5440e4ed3031
Message-id: <5440E4EB.1000300@samsung.com>
Date: Fri, 17 Oct 2014 11:44:11 +0200
From: =?UTF-8?B?S3J6eXN6dG9mIEtvesWCb3dza2k=?= <k.kozlowski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Ray Jui <rjui@broadcom.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Cc: Scott Branden <sbranden@broadcom.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: pl330: use subsys_initcall
References: <"Ray Jui <rjui"@broadcom.com>
 <1413506896-4536-1-git-send-email-rjui@broadcom.com>
In-reply-to: <1413506896-4536-1-git-send-email-rjui@broadcom.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t/xa7pvnziEGPyfxW0xfeoFRovVU/+y
	Wrx+YWhxedccNounMzezWbxb/YTR4mXffhYHdo9Z98+yeSze85LJo2/LKkaPz5vkAliiuGxS
	UnMyy1KL9O0SuDJmXt/AXPCCs2LiyhlMDYwdHF2MHBwSAiYSy9YKdTFyApliEhfurWfrYuTi
	EBJYyiixd+1TJgjnM6PE/cbVLCBVvAJaEgtmHGIFsVkEVCUmH74GZrMJeEhM+97DDGKLCkRI
	XFkzhxGiXlDix+R7YL0iArkS83Y+AqthFkiRONjUAdYrLGAl8en/HbB6IYFEia7r98FsTgFH
	iT9TNjCCHMosoC4xZUouRKu8xOY1b5knMArMQrJhFkLVLCRVCxiZVzGKppYmFxQnpeca6RUn
	5haX5qXrJefnbmKEBPXXHYxLj1kdYhTgYFTi4WWIcQgRYk0sK67MPcQowcGsJMLbfwsoxJuS
	WFmVWpQfX1Sak1p8iJGJg1OqgfGOzbQuGf8sC9cLJ+VSBBXE7uQ9WTWhfrtY2cWp7opfIy3e
	sbcuvixy6HST+rZbVmzZkxe9Xf+x66dlVoDHrlK//5qbbyTcneZ5LfJxiW9k95uiA+7Xrwfl
	xan4O3t4d1z64rGZee3xOY/FikMFwg2XBh9yKDgr9e/dKsULGh8bPP5feffqhb0SS3FGoqEW
	c1FxIgCI9Q+7SAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.10.2014 02:48, Ray Jui wrote:
> As part of subsystem that many slave drivers depend on, it's more
> appropriate for the pl330 DMA driver to be initialized at
> subsys_initcall than device_initcall
> 
> Signed-off-by: Ray Jui <rjui@broadcom.com>
> ---
>  drivers/dma/pl330.c |   12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)

For our setup this was not needed but anyway works fine.
Tested on Trats2 (Exynos4412) and Gear2 (Exynos3250).

Tested-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof

> 
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index d5149aa..abb4cae 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -2811,7 +2811,17 @@ static struct amba_driver pl330_driver = {
>  	.remove = pl330_remove,
>  };
>  
> -module_amba_driver(pl330_driver);
> +static int __init pl330_init(void)
> +{
> +	return amba_driver_register(&pl330_driver);
> +}
> +subsys_initcall(pl330_init);
> +
> +static void __exit pl330_exit(void)
> +{
> +	amba_driver_unregister(&pl330_driver);
> +}
> +module_exit(pl330_exit);
>  
>  MODULE_AUTHOR("Jaswinder Singh <jassi.brar@samsung.com>");
>  MODULE_DESCRIPTION("API Driver for PL330 DMAC");
> 

