Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab3FRIpK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:45:10 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43395 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951Ab3FRIpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:45:05 -0400
MIME-Version: 1.0
In-Reply-To: <20130617130230.GX4107@intel.com>
References: <1369742713-13528-1-git-send-email-wangxfdu@gmail.com>
	<20130617130230.GX4107@intel.com>
Date: Tue, 18 Jun 2013 16:45:05 +0800
Message-ID: <CACDNBm3oqOv1=ebYC8pa_Oq2Q9bA3FOtCYe4L4rf2oj=Nk9-mA@mail.gmail.com>
Subject: Re: [PATCH] dma: mmp_pdma: fix a memory alloc error
From: Xiang Wang <wangxfdu@gmail.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cxie4@marvell.com, Xiang Wang <wangx@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/17 Vinod Koul <vinod.koul@intel.com>:
> On Tue, May 28, 2013 at 08:05:13PM +0800, Xiang Wang wrote:
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
>> index c26699f..76a8dcf 100644
>> --- a/drivers/dma/mmp_pdma.c
>> +++ b/drivers/dma/mmp_pdma.c
>> @@ -801,7 +801,7 @@ static int mmp_pdma_probe(struct platform_device *op)
>>       }
>>
>>       pdev->phy = devm_kzalloc(pdev->dev,
>> -             dma_channels * sizeof(struct mmp_pdma_chan), GFP_KERNEL);
>> +             dma_channels * sizeof(struct mmp_pdma_phy), GFP_KERNEL);
> why not sizeof(*pdev-phy), that way you dont make above error
>
> --
> ~Vinod
Hi,
Updated patch V2 to use sizeof(*pdev->phy). Thanks!

--
Regards,
Xiang
