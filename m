Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762098Ab3JPSpv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:45:51 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:54494 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761339Ab3JPSpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 14:45:49 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1310162028340.22648@axis700.grange>
References: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
	<1381940926-25564-2-git-send-email-vinod.koul@intel.com>
	<Pine.LNX.4.64.1310162028340.22648@axis700.grange>
Date: Wed, 16 Oct 2013 11:45:48 -0700
Message-ID: <CAPcyv4hOZHmegDiPYmeVWzOUCasQaixzCzpLHs37i7RZznhGsA@mail.gmail.com>
Subject: Re: [PATCH 01/28] dmaengine: use DMA_COMPLETE for dma completion status
From: Dan Williams <dan.j.williams@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 11:29 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Hi Vinod,
>
> On Wed, 16 Oct 2013, Vinod Koul wrote:
>
>> the DMA_SUCCESS is a misnomer as dmaengine indicates the transfer is complete and
>> gives no guarantee of the transfer success. Hence we should use DMA_COMPLTE
>> instead of DMA_SUCCESS
>>
>> Signed-off-by: Vinod Koul <vinod.koul@intel.com>
>> ---
>>  drivers/dma/dmaengine.c   |    2 +-
>>  include/linux/dmaengine.h |   12 ++++++------
>>  2 files changed, 7 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
>> index 9162ac8..81d8765 100644
>> --- a/drivers/dma/dmaengine.c
>> +++ b/drivers/dma/dmaengine.c
>> @@ -1062,7 +1062,7 @@ dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx)
>>       unsigned long dma_sync_wait_timeout = jiffies + msecs_to_jiffies(5000);
>>
>>       if (!tx)
>> -             return DMA_SUCCESS;
>> +             return DMA_COMPLETE;
>>
>>       while (tx->cookie == -EBUSY) {
>>               if (time_after_eq(jiffies, dma_sync_wait_timeout)) {
>> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
>> index 0bc7275..4b460a6 100644
>> --- a/include/linux/dmaengine.h
>> +++ b/include/linux/dmaengine.h
>> @@ -45,13 +45,13 @@ static inline int dma_submit_error(dma_cookie_t cookie)
>>
>>  /**
>>   * enum dma_status - DMA transaction status
>> - * @DMA_SUCCESS: transaction completed successfully
>> + * @DMA_COMPLETE: transaction completed
>>   * @DMA_IN_PROGRESS: transaction not yet processed
>>   * @DMA_PAUSED: transaction is paused
>>   * @DMA_ERROR: transaction failed
>>   */
>>  enum dma_status {
>> -     DMA_SUCCESS,
>> +     DMA_COMPLETE,
>>       DMA_IN_PROGRESS,
>>       DMA_PAUSED,
>>       DMA_ERROR,
>
> Doesn't this break kernel compilation for a total of 27 commits? Or am I
> missing anything?

Yes, I think at the start DMA_COMPLETE should just be a alias for
DMA_SUCCESS, then after all the driver renames are in delete
DMA_SUCCESS.
