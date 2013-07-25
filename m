Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab3GYCWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 22:22:54 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:46355 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab3GYCWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 22:22:51 -0400
MIME-Version: 1.0
In-Reply-To: <20130705064549.GD10947@intel.com>
References: <1371536519-7837-1-git-send-email-wangxfdu@gmail.com>
	<20130705064549.GD10947@intel.com>
Date: Thu, 25 Jul 2013 10:22:50 +0800
Message-ID: <CACDNBm1jTTWLi3Prk+s_fk_BxNdzra4fG690sSMrKvwWXVW5oQ@mail.gmail.com>
Subject: Re: [PATCH v2] dma: mmp_pdma: fix a memory alloc error
From: Xiang Wang <wangxfdu@gmail.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cxie4@marvell.com, Xiang Wang <wangx@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/7/5 Vinod Koul <vinod.koul@intel.com>:
> On Tue, Jun 18, 2013 at 02:21:58PM +0800, Xiang Wang wrote:
>> From: Xiang Wang <wangx@marvell.com>
>>
>> pdev->phy is of type "struct mmp_pdma_phy *". But when
>> allocating memory for it, "struct mmp_pdma_chan" is used
>> by mistake.
>>
>> Signed-off-by: Xiang Wang <wangx@marvell.com>
>> ---
>>  drivers/dma/mmp_pdma.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/dma/mmp_pdma.c b/drivers/dma/mmp_pdma.c
>> index c26699f..18ac57f 100644
>> --- a/drivers/dma/mmp_pdma.c
>> +++ b/drivers/dma/mmp_pdma.c
>> @@ -801,7 +801,7 @@ static int mmp_pdma_probe(struct platform_device *op)
>>       }
>>
>>       pdev->phy = devm_kzalloc(pdev->dev,
>> -             dma_channels * sizeof(struct mmp_pdma_chan), GFP_KERNEL);
>> +             dma_channels * sizeof(*pdev->phy), GFP_KERNEL);
> While at it, can you make the flag GFP_NOWAIT. that is the recommendation for
> dmac drivers
>
> --
> ~Vinod

Hi, Vinod
Would you please explain a little more about why we should use
GFP_NOWAIT here? This memory is not dedicated for DMA controller. Do
we have special reasons to use GFP_NOWAIT? Thanks!

-- 
Regards,
Xiang
