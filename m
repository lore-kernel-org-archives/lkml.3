Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934478AbaFTJRj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 05:17:39 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:39522 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933271AbaFTJRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 05:17:37 -0400
From: Evgeny Budilovsky <budevg@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Cameron <jic23@kernel.org>, Joe Perches <joe@perches.com>,
        driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging/cptm1217: fix checkpatch warnings about else clause
Date: Fri, 20 Jun 2014 11:22:14 +0300
Message-ID: <87zjh86iug.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Evgeny Budilovsky <budevg@gmail.com>
---
 drivers/staging/cptm1217/clearpad_tm1217.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/cptm1217/clearpad_tm1217.c b/drivers/staging/cptm1217/clearpad_tm1217.c
index ca4c2c6..edf9ff2 100644
--- a/drivers/staging/cptm1217/clearpad_tm1217.c
+++ b/drivers/staging/cptm1217/clearpad_tm1217.c
@@ -147,12 +147,11 @@ static int cp_tm1217_read(struct cp_tm1217_device *ts,
 	msleep(WAIT_FOR_RESPONSE);
 	for (i = 0; i < MAX_RETRIES; i++) {
 		retval = i2c_master_recv(ts->client, &req[1], size);
-		if (retval == size) {
+		if (retval == size)
 			break;
-		} else {
-			msleep(INCREMENTAL_DELAY);
-			dev_dbg(ts->dev, "cp_tm1217: Retry count is %d\n", i);
-		}
+
+		msleep(INCREMENTAL_DELAY);
+		dev_dbg(ts->dev, "cp_tm1217: Retry count is %d\n", i);
 	}
 	if (retval != size)
 		dev_err(ts->dev, "cp_tm1217: Read from device failed\n");
@@ -288,11 +287,11 @@ static irqreturn_t cp_tm1217_sample_thread(int irq, void *handle)
 	if (ts->thread_running == 1) {
 		mutex_unlock(&ts->thread_mutex);
 		return IRQ_HANDLED;
-	} else {
-		ts->thread_running = 1;
-		mutex_unlock(&ts->thread_mutex);
 	}
 
+	ts->thread_running = 1;
+	mutex_unlock(&ts->thread_mutex);
+
 	/* Mask the interrupts */
 	retval = cp_tm1217_mask_interrupt(ts);
 
-- 
1.8.1.2

