Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab3AXBQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 20:16:38 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:60957
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766Ab3AXBQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 20:16:00 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, davem@davemloft.net, jkosina@suse.cz,
        James.Bottomley@HansenPartnership.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 2/6] Drivers: hv: Use consolidated GUID definitions
Date: Wed, 23 Jan 2013 17:42:41 -0800
Message-Id: <1358991765-22715-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1358991765-22715-1-git-send-email-kys@microsoft.com>
References: <1358991737-22675-1-git-send-email-kys@microsoft.com>
 <1358991765-22715-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the consolidated GUID definitions in the util and balloon drivers.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/hv_balloon.c |    4 +---
 drivers/hv/hv_util.c    |   24 ++++++++++++------------
 2 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index c02a33e..ce6f984 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -1012,9 +1012,7 @@ static int balloon_remove(struct hv_device *dev)
 static const struct hv_vmbus_device_id id_table[] = {
 	/* Dynamic Memory Class ID */
 	/* 525074DC-8985-46e2-8057-A307DC18A502 */
-	{ VMBUS_DEVICE(0xdc, 0x74, 0x50, 0X52, 0x85, 0x89, 0xe2, 0x46,
-		       0x80, 0x57, 0xa3, 0x07, 0xdc, 0x18, 0xa5, 0x02)
-	},
+	{ HV_DM_GUID, },
 	{ },
 };
 
diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
index a62a760..8b7868a 100644
--- a/drivers/hv/hv_util.c
+++ b/drivers/hv/hv_util.c
@@ -314,21 +314,21 @@ static int util_remove(struct hv_device *dev)
 
 static const struct hv_vmbus_device_id id_table[] = {
 	/* Shutdown guid */
-	{ VMBUS_DEVICE(0x31, 0x60, 0x0B, 0X0E, 0x13, 0x52, 0x34, 0x49,
-		       0x81, 0x8B, 0x38, 0XD9, 0x0C, 0xED, 0x39, 0xDB)
-	  .driver_data = (unsigned long)&util_shutdown },
+	{ HV_SHUTDOWN_GUID,
+	  .driver_data = (unsigned long)&util_shutdown
+	},
 	/* Time synch guid */
-	{ VMBUS_DEVICE(0x30, 0xe6, 0x27, 0x95, 0xae, 0xd0, 0x7b, 0x49,
-		       0xad, 0xce, 0xe8, 0x0a, 0xb0, 0x17, 0x5c, 0xaf)
-	  .driver_data = (unsigned long)&util_timesynch },
+	{ HV_TS_GUID,
+	  .driver_data = (unsigned long)&util_timesynch
+	},
 	/* Heartbeat guid */
-	{ VMBUS_DEVICE(0x39, 0x4f, 0x16, 0x57, 0x15, 0x91, 0x78, 0x4e,
-		       0xab, 0x55, 0x38, 0x2f, 0x3b, 0xd5, 0x42, 0x2d)
-	  .driver_data = (unsigned long)&util_heartbeat },
+	{ HV_HEART_BEAT_GUID,
+	  .driver_data = (unsigned long)&util_heartbeat
+	},
 	/* KVP guid */
-	{ VMBUS_DEVICE(0xe7, 0xf4, 0xa0, 0xa9, 0x45, 0x5a, 0x96, 0x4d,
-		       0xb8, 0x27, 0x8a, 0x84, 0x1e, 0x8c, 0x3,  0xe6)
-	  .driver_data = (unsigned long)&util_kvp },
+	{ HV_KVP_GUID,
+	  .driver_data = (unsigned long)&util_kvp
+	},
 	{ },
 };
 
-- 
1.7.4.1

