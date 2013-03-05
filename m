Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820Ab3CEW0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 17:26:44 -0500
Received: from mga14.intel.com ([143.182.124.37]:53977 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755589Ab3CEW0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 17:26:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,791,1355126400"; 
   d="scan'208";a="264869827"
Message-ID: <51367122.3000909@intel.com>
Date: Tue, 05 Mar 2013 15:26:42 -0700
From: Dave Jiang <dave.jiang@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Dan Williams <djbw@fb.com>
CC: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ioatdma: make debug output more readable
References: <84A937D219C2B44EB8EA44831ACA1E49171E5145@PRN-MBX02-3.TheFacebook.com>
In-Reply-To: <84A937D219C2B44EB8EA44831ACA1E49171E5145@PRN-MBX02-3.TheFacebook.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2013 03:20 PM, Dan Williams wrote:
>
> On 3/4/13 9:59 AM, "Dave Jiang" <dave.jiang@intel.com> wrote:
>
>> Making OP field a hex instead of integer to make it more readable. Also
>> add
>> the dump out of the NEXT field.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>> drivers/dma/ioat/dma.h    |    2 +-
>> drivers/dma/ioat/dma_v3.c |    3 ++-
>> 2 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/dma/ioat/dma.h b/drivers/dma/ioat/dma.h
>> index 53a4cbb..95ae7b3 100644
>> --- a/drivers/dma/ioat/dma.h
>> +++ b/drivers/dma/ioat/dma.h
>> @@ -179,7 +179,7 @@ __dump_desc_dbg(struct ioat_chan_common *chan, struct
>> ioat_dma_descriptor *hw,
>> 	struct device *dev = to_dev(chan);
>>
>> 	dev_dbg(dev, "desc[%d]: (%#llx->%#llx) cookie: %d flags: %#x"
>> -		" ctl: %#x (op: %d int_en: %d compl: %d)\n", id,
>> +		" ctl: %#10.8x (op: %#x int_en: %d compl: %d)\n", id,
>> 		(unsigned long long) tx->phys,
>> 		(unsigned long long) hw->next, tx->cookie, tx->flags,
>> 		hw->ctl, hw->ctl_f.op, hw->ctl_f.int_en, hw->ctl_f.compl_write);
>> diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
>> index 53ea4bd..ce6fcee 100644
>> --- a/drivers/dma/ioat/dma_v3.c
>> +++ b/drivers/dma/ioat/dma_v3.c
>> @@ -605,7 +605,7 @@ dump_pq_desc_dbg(struct ioat2_dma_chan *ioat, struct
>> ioat_ring_ent *desc, struct
>> 	int i;
>>
>> 	dev_dbg(dev, "desc[%d]: (%#llx->%#llx) flags: %#x"
>> -		" sz: %#x ctl: %#x (op: %d int: %d compl: %d pq: '%s%s' src_cnt:
>> %d)\n",
>> +		" sz: %#10.8x ctl: %#x (op: %#x int: %d compl: %d pq: '%s%s' src_cnt:
>> %d)\n",
>> 		desc_id(desc), (unsigned long long) desc->txd.phys,
>> 		(unsigned long long) (pq_ex ? pq_ex->next : pq->next),
>> 		desc->txd.flags, pq->size, pq->ctl, pq->ctl_f.op, pq->ctl_f.int_en,
>> @@ -617,6 +617,7 @@ dump_pq_desc_dbg(struct ioat2_dma_chan *ioat, struct
>> ioat_ring_ent *desc, struct
>> 			(unsigned long long) pq_get_src(descs, i), pq->coef[i]);
>> 	dev_dbg(dev, "\tP: %#llx\n", pq->p_addr);
>> 	dev_dbg(dev, "\tQ: %#llx\n", pq->q_addr);
>> +	dev_dbg(dev, "\tNEXT: %#llx\n", pq->next);
> Looks ok, did you want to distinguish when ->next is pointing to an
> extended descriptor?

Probably a good idea. Let me add that
