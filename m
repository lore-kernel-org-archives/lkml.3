Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933201Ab3CHKW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 05:22:27 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:50716 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab3CHKWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 05:22:25 -0500
From: Prabhakar lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Sekhar Nori <nsekhar@ti.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] davinci: vpbe: fix module build
Date: Fri,  8 Mar 2013 15:52:10 +0530
Message-Id: <1362738130-24543-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

add a null entry in platform_device_id {}.

This patch fixes following error:
drivers/media/platform/davinci/vpbe_venc: struct platform_device_id is 24 bytes.  The last of 3 is:
0x64 0x6d 0x33 0x35 0x35 0x2c 0x76 0x70 0x62 0x65 0x2d 0x76 0x65 0x6e 0x63 0x00 0x00 0x00 0x00 0x00 0x03 0x00 0x00 0x00
FATAL: drivers/media/platform/davinci/vpbe_venc: struct platform_device_id is not terminated with a NULL entry!
make[1]: *** [__modpost] Error 1

Reported-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpbe_osd.c  |    3 +++
 drivers/media/platform/davinci/vpbe_venc.c |    3 +++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe_osd.c b/drivers/media/platform/davinci/vpbe_osd.c
index 12ad17c..396a51c 100644
--- a/drivers/media/platform/davinci/vpbe_osd.c
+++ b/drivers/media/platform/davinci/vpbe_osd.c
@@ -52,6 +52,9 @@ static struct platform_device_id vpbe_osd_devtype[] = {
 		.name = DM355_VPBE_OSD_SUBDEV_NAME,
 		.driver_data = VPBE_VERSION_3,
 	},
+	{
+		/* sentinel */
+	}
 };
 
 MODULE_DEVICE_TABLE(platform, vpbe_osd_devtype);
diff --git a/drivers/media/platform/davinci/vpbe_venc.c b/drivers/media/platform/davinci/vpbe_venc.c
index bdbebd5..34c704b 100644
--- a/drivers/media/platform/davinci/vpbe_venc.c
+++ b/drivers/media/platform/davinci/vpbe_venc.c
@@ -51,6 +51,9 @@ static struct platform_device_id vpbe_venc_devtype[] = {
 		.name = DM355_VPBE_VENC_SUBDEV_NAME,
 		.driver_data = VPBE_VERSION_3,
 	},
+	{
+		/* sentinel */
+	}
 };
 
 MODULE_DEVICE_TABLE(platform, vpbe_venc_devtype);
-- 
1.7.4.1

