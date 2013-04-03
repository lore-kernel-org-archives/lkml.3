Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760704Ab3DCL6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 07:58:44 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52573 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757945Ab3DCL6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 07:58:43 -0400
Message-ID: <515C19CD.306@ti.com>
Date: Wed, 3 Apr 2013 17:30:13 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Tony Lindgren <tony@atomide.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, Felipe Balbi <balbi@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Peter Meerwald <pmeerw@pmeerw.net>
Subject: Re: [RFC v2] dmaengine: omap-dma: Start DMA without delay for cyclic
 channels
References: <1364987862-14597-1-git-send-email-peter.ujfalusi@ti.com> <515C117A.6060700@ti.com> <515C17F9.4040300@ti.com>
In-Reply-To: <515C17F9.4040300@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 April 2013 05:22 PM, Peter Ujfalusi wrote:
> On 04/03/2013 01:24 PM, Santosh Shilimkar wrote:
>> On Wednesday 03 April 2013 04:47 PM, Peter Ujfalusi wrote:
>>> cyclic DMA is only used by audio which needs DMA to be started without a
>>> delay.
>>> If the DMA for audio is started using the tasklet we experience random
>>> channel switch (to be more precise: channel shift).
>>>
>>> Reported-by: Peter Meerwald <pmeerw@pmeerw.net>
>>> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
>>> ---
>>> Hi Russell,
>>>
>>> Instead of removing the tasklet we can identify the DMA channel used by audio
>>> based on the cyclic flag of the channel.
>>> I think this can be used as a short term solution to fix the audio channel shift
>>> issue and later when we have the dynamic DMA channel allocation we can adjust
>>> the code.
>>>
>>> Regards,
>>> Peter
>>>
>>>  drivers/dma/omap-dma.c | 20 ++++++++++++++------
>>>  1 file changed, 14 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/dma/omap-dma.c b/drivers/dma/omap-dma.c
>>> index 2ea3d7e..ec3fc4f 100644
>>> --- a/drivers/dma/omap-dma.c
>>> +++ b/drivers/dma/omap-dma.c
>>> @@ -282,12 +282,20 @@ static void omap_dma_issue_pending(struct dma_chan *chan)
>>>  
>>>  	spin_lock_irqsave(&c->vc.lock, flags);
>>>  	if (vchan_issue_pending(&c->vc) && !c->desc) {
>> If you add "!c->cyclic" in above if then you can avoid
>> indentation change and just have else for cyclic case.
> 
> It can not be embedded there because of the existing tests. How would we
> handle the case when c->desc is _not_ NULL and c->cyclic is false? We would
> need to test again in else, but we can not do this for the
> vchan_issue_pending(&c->vc).
> 
right. Thanks for clarifying it.

Regards,
Santosh

