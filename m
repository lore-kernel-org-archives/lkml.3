Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab3FGNQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 09:16:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177Ab3FGNQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 09:16:46 -0400
Message-ID: <51B1DD18.3080104@redhat.com>
Date: Fri, 07 Jun 2013 14:16:08 +0100
From: "Bryn M. Reeves" <bmr@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: mike.miller@hp.com, scameron@beardog.cce.hp.com, thenzl@redhat.com,
        axboe@kernel.dk
Subject: [PATCH][RESEND] Silence noisy per-device cciss messages
Content-Type: multipart/mixed;
 boundary="------------010309000803070204020305"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010309000803070204020305
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Currently cciss logs a message each time cciss_read_capacity_16 is called:

kernel: cciss 0000:03:00.0:       blocks= 5274326576 block_size= 512

This generates considerable log noise. An identical message was deleted 
from cciss_read_capacity in 2009.

This patch mirrors the change made to cciss_read_capacity in commit
983333c. Emitting device and block size information at KERN_INFO on
each read_capacity() leads to a lot of log noise.

Signed-off-by: Bryn M. Reeves <bmr@redhat.com>

--------------010309000803070204020305
Content-Type: text/x-patch;
 name="0001-Silence-noisy-per-device-cciss-messages.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-Silence-noisy-per-device-cciss-messages.patch"

>From da8267e5452e03158da8dd27026fb7188342d653 Mon Sep 17 00:00:00 2001
From: "Bryn M. Reeves" <bmr@redhat.com>
Date: Fri, 7 Jun 2013 13:45:10 +0100
Subject: [PATCH] Silence noisy per-device cciss messages

This patch mirrors the change made to cciss_read_capacity in commit
983333c. Emitting device and block size information at KERN_INFO on
each read_capacity() leads to a lot of log noise.

Signed-off-by: Bryn M. Reeves <bmr@redhat.com>
---
 drivers/block/cciss.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 6374dc1..b128016 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -2937,8 +2937,6 @@ static void cciss_read_capacity_16(ctlr_info_t *h, int logvol,
 		*total_size = 0;
 		*block_size = BLOCK_SIZE;
 	}
-	dev_info(&h->pdev->dev, "      blocks= %llu block_size= %d\n",
-	       (unsigned long long)*total_size+1, *block_size);
 	kfree(buf);
 }
 
-- 
1.7.11.7


--------------010309000803070204020305--
