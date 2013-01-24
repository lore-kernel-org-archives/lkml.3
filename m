Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab3AXBQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 20:16:27 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:41110
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744Ab3AXBQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 20:16:00 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, davem@davemloft.net, jkosina@suse.cz,
        James.Bottomley@HansenPartnership.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 4/6] Drivers: scsi: storvsc: Use the consolidated GUID definition
Date: Wed, 23 Jan 2013 17:42:43 -0800
Message-Id: <1358991765-22715-4-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1358991765-22715-1-git-send-email-kys@microsoft.com>
References: <1358991737-22675-1-git-send-email-kys@microsoft.com>
 <1358991765-22715-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the consolidated GUID definitions in the Hyper-V storage driver.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 0144078..270b3cf 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1410,13 +1410,13 @@ enum {
 
 static const struct hv_vmbus_device_id id_table[] = {
 	/* SCSI guid */
-	{ VMBUS_DEVICE(0xd9, 0x63, 0x61, 0xba, 0xa1, 0x04, 0x29, 0x4d,
-		       0xb6, 0x05, 0x72, 0xe2, 0xff, 0xb1, 0xdc, 0x7f)
-	  .driver_data = SCSI_GUID },
+	{ HV_SCSI_GUID,
+	  .driver_data = SCSI_GUID
+	},
 	/* IDE guid */
-	{ VMBUS_DEVICE(0x32, 0x26, 0x41, 0x32, 0xcb, 0x86, 0xa2, 0x44,
-		       0x9b, 0x5c, 0x50, 0xd1, 0x41, 0x73, 0x54, 0xf5)
-	  .driver_data = IDE_GUID },
+	{ HV_IDE_GUID,
+	  .driver_data = IDE_GUID
+	},
 	{ },
 };
 
-- 
1.7.4.1

