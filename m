Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab3CEXFD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 18:05:03 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45931 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751746Ab3CEXFA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 18:05:00 -0500
X-Greylist: delayed 2095 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Mar 2013 18:05:00 EST
From: Dan Williams <djbw@fb.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ioatdma: allow all channels to have irq coalescing
 support
Thread-Topic: [PATCH] ioatdma: allow all channels to have irq coalescing
 support
Thread-Index: AQHOFD03K0VlW9DjjEuhymemoCavZpiXuXiA
Date: Tue, 5 Mar 2013 22:30:01 +0000
Message-ID: <84A937D219C2B44EB8EA44831ACA1E49171E519C@PRN-MBX02-3.TheFacebook.com>
In-Reply-To: <20130226162036.4996.78263.stgit@djiang5-linux2.ch.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.16.4]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <978F2E8FAAA1E5428610FB76CF52EA56@fb.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Reason: safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2013-03-05_08:2013-03-05,2013-03-05,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2/26/13 8:20 AM, "Dave Jiang" <dave.jiang@intel.com> wrote:

>Looks like only the RAID channels are allowed to have irq coalescing
>support
>in the existing code. Fixing that. The ioat3 cleanup code can handle
>memcpy
>ops anyways
>
>Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>---
> drivers/dma/ioat/dma_v3.c |   12 +++---------
> 1 file changed, 3 insertions(+), 9 deletions(-)
>
>diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
>index 47588dc..368a184 100644
>--- a/drivers/dma/ioat/dma_v3.c
>+++ b/drivers/dma/ioat/dma_v3.c
>@@ -1268,15 +1268,9 @@ int __devinit ioat3_dma_probe(struct
>ioatdma_device *device, int dca)
> 	}
> 
> 
>-	if (is_raid_device) {
>-		dma->device_tx_status = ioat3_tx_status;
>-		device->cleanup_fn = ioat3_cleanup_event;
>-		device->timer_fn = ioat3_timer_event;
>-	} else {
>-		dma->device_tx_status = ioat_dma_tx_status;
>-		device->cleanup_fn = ioat2_cleanup_event;
>-		device->timer_fn = ioat2_timer_event;
>-	}
>+	dma->device_tx_status = ioat3_tx_status;
>+	device->cleanup_fn = ioat3_cleanup_event;
>+	device->timer_fn = ioat3_timer_event;
> 
> 	#ifdef CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA
> 	dma_cap_clear(DMA_PQ_VAL, dma->cap_mask);

Acked-by: Dan Williams <djbw@fb.com>

