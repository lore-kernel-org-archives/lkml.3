Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab3GCMM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 08:12:58 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:57279 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778Ab3GCMM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 08:12:57 -0400
MIME-Version: 1.0
In-Reply-To: <1371536519-7837-1-git-send-email-wangxfdu@gmail.com>
References: <1371536519-7837-1-git-send-email-wangxfdu@gmail.com>
Date: Wed, 3 Jul 2013 20:12:56 +0800
Message-ID: <CACDNBm18qQSPpZJ-XX6ufLvURV3A+2TJu-sXBP8RoarZ4MkmEg@mail.gmail.com>
Subject: Re: [PATCH v2] dma: mmp_pdma: fix a memory alloc error
From: Xiang Wang <wangxfdu@gmail.com>
To: Dan Williams <djbw@fb.com>, Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Xiang Wang <wangxfdu@gmail.com>, cxie4@marvell.com,
        Xiang Wang <wangx@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Do you have any comments about this patch? Have modified according to
Vinod's advice. Thanks!

2013/6/18 Xiang Wang <wangxfdu@gmail.com>:
> From: Xiang Wang <wangx@marvell.com>
>
> pdev->phy is of type "struct mmp_pdma_phy *". But when
> allocating memory for it, "struct mmp_pdma_chan" is used
> by mistake.
>
> Signed-off-by: Xiang Wang <wangx@marvell.com>
> ---
>  drivers/dma/mmp_pdma.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/dma/mmp_pdma.c b/drivers/dma/mmp_pdma.c
> index c26699f..18ac57f 100644
> --- a/drivers/dma/mmp_pdma.c
> +++ b/drivers/dma/mmp_pdma.c
> @@ -801,7 +801,7 @@ static int mmp_pdma_probe(struct platform_device *op)
>         }
>
>         pdev->phy = devm_kzalloc(pdev->dev,
> -               dma_channels * sizeof(struct mmp_pdma_chan), GFP_KERNEL);
> +               dma_channels * sizeof(*pdev->phy), GFP_KERNEL);
>         if (pdev->phy == NULL)
>                 return -ENOMEM;
>
> --
> 1.7.5.4
>



-- 
Regards,
Xiang
