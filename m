Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176Ab3BVT76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 14:59:58 -0500
Received: from mail.ispras.ru ([83.149.199.45]:59858 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756101Ab3BVT75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 14:59:57 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] [SCSI] scsi_dh_hp_sw: return -ENOMEM if kzalloc() failed
Date: Fri, 22 Feb 2013 23:59:44 +0400
Message-Id: <1361563184-7705-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If kzalloc() failed, hp_sw_bus_attach() breaks off initialization, but returns zero.
The patch adds -ENOMEM as return value in this case.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 084062b..4619473 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -364,7 +364,7 @@ static int hp_sw_bus_attach(struct scsi_device *sdev)
 	if (!scsi_dh_data) {
 		sdev_printk(KERN_ERR, sdev, "%s: Attach Failed\n",
 			    HP_SW_NAME);
-		return 0;
+		return -ENOMEM;
 	}
 
 	scsi_dh_data->scsi_dh = &hp_sw_dh;
-- 
1.7.9.5

