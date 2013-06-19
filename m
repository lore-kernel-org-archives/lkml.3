Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252Ab3FSRgF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 13:36:05 -0400
Received: from mga14.intel.com ([143.182.124.37]:12978 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756708Ab3FSRgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 13:36:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,898,1363158000"; 
   d="scan'208";a="257324465"
Message-ID: <51C1EC32.6020204@intel.com>
Date: Wed, 19 Jun 2013 10:36:50 -0700
From: Dave Jiang <dave.jiang@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Dan Williams <djbw@fb.com>
CC: Jon Mason <jon.mason@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ioatdma: add DMA_PRIVATE capabilities flag
References: <1371602813-19828-1-git-send-email-jon.mason@intel.com> <1371602813-19828-3-git-send-email-jon.mason@intel.com> <CAA9_cmeie_V0PauHBadVsg22OQmFrC_Oeg1o1FwdzQ+mVU9gTA@mail.gmail.com>
In-Reply-To: <CAA9_cmeie_V0PauHBadVsg22OQmFrC_Oeg1o1FwdzQ+mVU9gTA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2013 05:59 PM, Dan Williams wrote:
> On Tue, Jun 18, 2013 at 5:46 PM, Jon Mason <jon.mason@intel.com> wrote:
>> Set the DMA_PRIVATE dma_transaction_type in the capability mask.  This
>> enables the ability to get an exclusive ioatdma DMA channel for any
>> devices that requests one via the dma_request_channel function call.
>>
>> Signed-off-by: Jon Mason <jon.mason@intel.com>
>> Acked-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>>   drivers/dma/ioat/dma_v3.c |    1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
>> index ca6ea9b..ac2aeef 100644
>> --- a/drivers/dma/ioat/dma_v3.c
>> +++ b/drivers/dma/ioat/dma_v3.c
>> @@ -1883,6 +1883,7 @@ int ioat3_dma_probe(struct ioatdma_device *device, int dca)
>>                  dma->copy_align = 6;
>>
>>          dma_cap_set(DMA_INTERRUPT, dma->cap_mask);
>> +       dma_cap_set(DMA_PRIVATE, dma->cap_mask);
>>          dma->device_prep_dma_interrupt = ioat3_prep_interrupt_lock;
> DMA_PRIVATE here keeps all channels private, so they couldn't be used
> elsewhere, for example raid offload.  Do you need a private allocation
> or can you get away with a dynamically assigned channel?
So is there no way to reserve a channel as private if no one is using 
it? It seems the current setup is async_tx or nothing.

-- 

Dave Jiang
Application Engineer, Storage Divsion
Intel Corp.
dave.jiang@intel.com

