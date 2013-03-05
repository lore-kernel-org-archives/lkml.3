Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab3CEWnB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 17:43:01 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35713 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755681Ab3CEWnA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 17:43:00 -0500
X-Greylist: delayed 1355 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Mar 2013 17:43:00 EST
From: Dan Williams <djbw@fb.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ioatdma: make debug output more readable
Thread-Topic: [PATCH] ioatdma: make debug output more readable
Thread-Index: AQHOGQIVut0Uu77qxky52il5B3063ZiXrSkA
Date: Tue, 5 Mar 2013 22:20:07 +0000
Message-ID: <84A937D219C2B44EB8EA44831ACA1E49171E5145@PRN-MBX02-3.TheFacebook.com>
In-Reply-To: <20130304175954.9792.19327.stgit@djiang5-linux2.ch.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.16.4]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <05C070ED4763694DA3172DEE6CA29ACA@fb.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Reason: safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2013-03-05_08:2013-03-05,2013-03-05,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 3/4/13 9:59 AM, "Dave Jiang" <dave.jiang@intel.com> wrote:

>Making OP field a hex instead of integer to make it more readable. Also
>add
>the dump out of the NEXT field.
>
>Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>---
> drivers/dma/ioat/dma.h    |    2 +-
> drivers/dma/ioat/dma_v3.c |    3 ++-
> 2 files changed, 3 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/dma/ioat/dma.h b/drivers/dma/ioat/dma.h
>index 53a4cbb..95ae7b3 100644
>--- a/drivers/dma/ioat/dma.h
>+++ b/drivers/dma/ioat/dma.h
>@@ -179,7 +179,7 @@ __dump_desc_dbg(struct ioat_chan_common *chan, struct
>ioat_dma_descriptor *hw,
> 	struct device *dev = to_dev(chan);
> 
> 	dev_dbg(dev, "desc[%d]: (%#llx->%#llx) cookie: %d flags: %#x"
>-		" ctl: %#x (op: %d int_en: %d compl: %d)\n", id,
>+		" ctl: %#10.8x (op: %#x int_en: %d compl: %d)\n", id,
> 		(unsigned long long) tx->phys,
> 		(unsigned long long) hw->next, tx->cookie, tx->flags,
> 		hw->ctl, hw->ctl_f.op, hw->ctl_f.int_en, hw->ctl_f.compl_write);
>diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
>index 53ea4bd..ce6fcee 100644
>--- a/drivers/dma/ioat/dma_v3.c
>+++ b/drivers/dma/ioat/dma_v3.c
>@@ -605,7 +605,7 @@ dump_pq_desc_dbg(struct ioat2_dma_chan *ioat, struct
>ioat_ring_ent *desc, struct
> 	int i;
> 
> 	dev_dbg(dev, "desc[%d]: (%#llx->%#llx) flags: %#x"
>-		" sz: %#x ctl: %#x (op: %d int: %d compl: %d pq: '%s%s' src_cnt:
>%d)\n",
>+		" sz: %#10.8x ctl: %#x (op: %#x int: %d compl: %d pq: '%s%s' src_cnt:
>%d)\n",
> 		desc_id(desc), (unsigned long long) desc->txd.phys,
> 		(unsigned long long) (pq_ex ? pq_ex->next : pq->next),
> 		desc->txd.flags, pq->size, pq->ctl, pq->ctl_f.op, pq->ctl_f.int_en,
>@@ -617,6 +617,7 @@ dump_pq_desc_dbg(struct ioat2_dma_chan *ioat, struct
>ioat_ring_ent *desc, struct
> 			(unsigned long long) pq_get_src(descs, i), pq->coef[i]);
> 	dev_dbg(dev, "\tP: %#llx\n", pq->p_addr);
> 	dev_dbg(dev, "\tQ: %#llx\n", pq->q_addr);
>+	dev_dbg(dev, "\tNEXT: %#llx\n", pq->next);

Looks ok, did you want to distinguish when ->next is pointing to an
extended descriptor?

