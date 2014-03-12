Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560AbaCLKhz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 06:37:55 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:40006 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbaCLKhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 06:37:54 -0400
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org, jkc@redhat.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: unisys: use kzalloc instead of kmalloc/memset 0
Date: Wed, 12 Mar 2014 19:37:50 +0900
Message-ID: <4376102.svyTz8ADVT@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/unisys/uislib/uislib.c   |    5 +----
 drivers/staging/unisys/uislib/uisutils.c |    2 +-
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/unisys/uislib/uislib.c b/drivers/staging/unisys/uislib/uislib.c
index d77df9a..9748fcb 100644
--- a/drivers/staging/unisys/uislib/uislib.c
+++ b/drivers/staging/unisys/uislib/uislib.c
@@ -339,8 +339,6 @@ create_bus(CONTROLVM_MESSAGE *msg, char *buf)
 		return CONTROLVM_RESP_ERROR_KMALLOC_FAILED;
 	}
 
-	memset(bus, 0, size);
-
 	/* Currently by default, the bus Number is the GuestHandle.
 	 * Configure Bus message can override this.
 	 */
@@ -530,7 +528,6 @@ create_device(CONTROLVM_MESSAGE *msg, char *buf)
 		return CONTROLVM_RESP_ERROR_KMALLOC_FAILED;
 	}
 
-	memset(dev, 0, sizeof(struct device_info));
 	dev->channelTypeGuid = msg->cmd.createDevice.dataTypeGuid;
 	dev->intr = msg->cmd.createDevice.intr;
 	dev->channelAddr = msg->cmd.createDevice.channelAddr;
@@ -1437,7 +1434,7 @@ uislib_malloc(size_t siz, gfp_t gfp, U8 contiguous, char *fn, int ln)
 		* get memory for you (like, invoke oom killer), which
 		* will probably cripple the system.
 		*/
-		p = kmalloc(siz, gfp | __GFP_NORETRY);
+		p = kzalloc(siz, gfp | __GFP_NORETRY);
 	}
 	if (p == NULL) {
 		LOGERR("uislib_malloc failed to alloc %d bytes @%s:%d",
diff --git a/drivers/staging/unisys/uislib/uisutils.c b/drivers/staging/unisys/uislib/uisutils.c
index 208b7ea..2f05be1 100644
--- a/drivers/staging/unisys/uislib/uisutils.c
+++ b/drivers/staging/unisys/uislib/uisutils.c
@@ -294,7 +294,7 @@ ReqHandlerAdd(GUID switchTypeGuid,
 	rc = UISMALLOC(sizeof(*rc), GFP_ATOMIC);
 	if (!rc)
 		return NULL;
-	memset(rc, 0, sizeof(*rc));
+
 	rc->switchTypeGuid = switchTypeGuid;
 	rc->controlfunc = controlfunc;
 	rc->min_channel_bytes = min_channel_bytes;
-- 
1.7.4.4


