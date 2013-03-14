Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910Ab3CNKhF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:37:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51742 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756692Ab3CNKg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:36:58 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 11/88] dc395x: uninitialized variable in device_alloc()
Date: Thu, 14 Mar 2013 10:35:04 +0000
Message-Id: <1363257381-15900-12-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 208afec4f3be8c51ad6eebe6611dd6d2ad2fa298 upstream.

This bug was introduced back in bitkeeper days in 2003.  We use
"dcb->dev_mode" before it has been initialized.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Oliver Neukum <oliver@neukum.org>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/scsi/dc395x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 13aeca3..48105fc 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -3747,13 +3747,13 @@ static struct DeviceCtlBlk *device_alloc(struct AdapterCtlBlk *acb,
 	dcb->max_command = 1;
 	dcb->target_id = target;
 	dcb->target_lun = lun;
+	dcb->dev_mode = eeprom->target[target].cfg0;
 #ifndef DC395x_NO_DISCONNECT
 	dcb->identify_msg =
 	    IDENTIFY(dcb->dev_mode & NTC_DO_DISCONNECT, lun);
 #else
 	dcb->identify_msg = IDENTIFY(0, lun);
 #endif
-	dcb->dev_mode = eeprom->target[target].cfg0;
 	dcb->inquiry7 = 0;
 	dcb->sync_mode = 0;
 	dcb->min_nego_period = clock_period[period_index];
-- 
1.8.1.2

