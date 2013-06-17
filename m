Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932776Ab3FQLi7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 07:38:59 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:32953 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932706Ab3FQLi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 07:38:58 -0400
MIME-Version: 1.0
In-Reply-To: <CACDNBm0iOP=T3tqYpSR87j8Ac91w0Epw9_nNhy_w3nr9661sdQ@mail.gmail.com>
References: <1369742713-13528-1-git-send-email-wangxfdu@gmail.com>
	<CAHp75VfdJ3RhXc0PJNvBwcxzoGh5MYHcPSmiX_-wR778L4XtSA@mail.gmail.com>
	<CACDNBm0iOP=T3tqYpSR87j8Ac91w0Epw9_nNhy_w3nr9661sdQ@mail.gmail.com>
Date: Mon, 17 Jun 2013 19:31:06 +0800
Message-ID: <CACDNBm2N55JZoKmxmYxzbvx=pySrWG7Rhkbfc_qcFZt5EsgkBg@mail.gmail.com>
Subject: Re: [PATCH] dma: mmp_pdma: fix a memory alloc error
From: Xiang Wang <wangxfdu@gmail.com>
Cc: Dan Williams <djbw@fb.com>, Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cxie4@marvell.com, Xiang Wang <wangx@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/5/31 Xiang Wang <wangxfdu@gmail.com>:
> 2013/5/28 Andy Shevchenko <andy.shevchenko@gmail.com>:
>> On Tue, May 28, 2013 at 3:05 PM, Xiang Wang <wangxfdu@gmail.com> wrote:
>>> From: Xiang Wang <wangx@marvell.com>
>>>
>>> pdev->phy is of type "struct mmp_pdma_phy *". But when
>>> allocating memory for it, "struct mmp_pdma_chan" is used
>>> by mistake.
>>
>> Have you tested it?
>>
>>> Signed-off-by: Xiang Wang <wangx@marvell.com>
>>> ---
>>>  drivers/dma/mmp_pdma.c |    2 +-
>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/dma/mmp_pdma.c b/drivers/dma/mmp_pdma.c
>>> index c26699f..76a8dcf 100644
>>> --- a/drivers/dma/mmp_pdma.c
>>> +++ b/drivers/dma/mmp_pdma.c
>>> @@ -801,7 +801,7 @@ static int mmp_pdma_probe(struct platform_device *op)
>>>         }
>>>
>>>         pdev->phy = devm_kzalloc(pdev->dev,
>>> -               dma_channels * sizeof(struct mmp_pdma_chan), GFP_KERNEL);
>>> +               dma_channels * sizeof(struct mmp_pdma_phy), GFP_KERNEL);
>>
>> For me it seems you did get how it works.
>>
>> --
>> With Best Regards,
>> Andy Shevchenko
>
> Hi, Andy
> Yes. I've tested on marvell pxa988 platform using dmatest.ko.

Hi, All
Do you have any comments about this patch? Thanks!

--
Regards,
Xiang
