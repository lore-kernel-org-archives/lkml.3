Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162632AbaDCIKK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 04:10:10 -0400
Received: from tx2ehsobe007.messaging.microsoft.com ([65.55.88.31]:42407 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1162462AbaDCIJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 04:09:46 -0400
X-Greylist: delayed 4164 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Apr 2014 04:09:46 EDT
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 11
X-BigFish: VS11(z579ehzbb2dI98dI9371I1432Izz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz1de098h8275bh8275dh1de097h186068hz2dh2a8h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh22d0h2336h2438h2461h2487h24ach24d7h2516h2545h255eh25cch25f6h2605h268bh26d3h133w1155h)
Message-ID: <533D173C.9050204@freescale.com>
Date: Thu, 3 Apr 2014 16:09:32 +0800
From: Hongbo Zhang <hongbo.zhang@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: <linux-kernel@vger.kernel.org>, <scottwood@freescale.com>,
        <dmaengine@vger.kernel.org>, <dan.j.williams@intel.com>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH 3/7] DMA: Freescale: add fsl_dma_free_descriptor() to
 reduce code duplication
References: <1389851246-8564-1-git-send-email-hongbo.zhang@freescale.com> <1389851246-8564-4-git-send-email-hongbo.zhang@freescale.com> <20140311110616.GV1976@intel.com> <5334F022.3050402@freescale.com>
In-Reply-To: <5334F022.3050402@freescale.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 03/28/2014 11:44 AM, Hongbo Zhang wrote:
>
> On 03/11/2014 07:06 PM, Vinod Koul wrote:
>> On Thu, Jan 16, 2014 at 01:47:22PM +0800, hongbo.zhang@freescale.com 
>> wrote:
>>> From: Hongbo Zhang <hongbo.zhang@freescale.com>
>>>
>>> There are several places where descriptors are freed using identical 
>>> code.
>>> This patch puts this code into a function to reduce code duplication.
>>>
>>> Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
>>> Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
>>> ---
>>>   drivers/dma/fsldma.c |   38 ++++++++++++++++++++------------------
>>>   1 file changed, 20 insertions(+), 18 deletions(-)
>>>
>>> diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
>>> index 95236e6..ad73538 100644
>>> --- a/drivers/dma/fsldma.c
>>> +++ b/drivers/dma/fsldma.c
>>> @@ -418,6 +418,21 @@ static dma_cookie_t fsl_dma_tx_submit(struct 
>>> dma_async_tx_descriptor *tx)
>>>   }
>>>     /**
>>> + * fsl_dma_free_descriptor - Free descriptor from channel's DMA pool.
>>> + * @chan : Freescale DMA channel
>>> + * @desc: descriptor to be freed
>>> + */
>>> +static void fsl_dma_free_descriptor(struct fsldma_chan *chan,
>>> +        struct fsl_desc_sw *desc)
>>> +{
>>> +    list_del(&desc->node);
>>> +#ifdef FSL_DMA_LD_DEBUG
>>> +    chan_dbg(chan, "LD %p free\n", desc);
>>> +#endif
>> why not wrap the define stuff in the defination of chan_dbg rather 
>> than its
>> usage :(
>>
>
> OK, I will fix it by another separate patch.
> Thanks.
>

Think it again, I'd like to remove the FSL_DMA_LD_DEBUG usage, because 
the chan_dbg is a wrapper of dev_dbg, we do have macro to switch on/off 
dev_dbg, and most of other codes are calling chan_dbg directly without 
FSL_DMA_LD_DEBUG, the FSL_DMA_LD_DEBUG only shows up 3 times unnecessarily.
>
>
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev



