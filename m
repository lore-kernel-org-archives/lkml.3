Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285AbaGGSx2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 14:53:28 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:14493 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751216AbaGGSx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 14:53:27 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmANAOTrulNXQCU9/2dsb2JhbABZgw6segUBAQEBAQEFAW4BmW2BGxd1hGAjgRo3iEYByV6FcIkyHYQtBYRpA5YKlAyDRTs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Subject: [RFC 1/1] em28xx: fix configuration warning
Date: Mon,  7 Jul 2014 20:51:55 +0200
Message-Id: <1404759115-11029-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch tries to solve a problem detected with random configuration.
warning: (VIDEO_EM28XX_V4L2) selects VIDEO_MT9V011 which has unmet direct dependencies (MEDIA_SUPPORT && I2C && VIDEO_V4L2 && MEDIA_CAMERA_SUPPORT)

Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/media/usb/em28xx/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/em28xx/Kconfig b/drivers/media/usb/em28xx/Kconfig
index f5d7198..d42e1de 100644
--- a/drivers/media/usb/em28xx/Kconfig
+++ b/drivers/media/usb/em28xx/Kconfig
@@ -7,6 +7,7 @@ config VIDEO_EM28XX
 config VIDEO_EM28XX_V4L2
 	tristate "Empia EM28xx analog TV, video capture and/or webcam support"
 	depends on VIDEO_EM28XX
+	depends on MEDIA_CAMERA_SUPPORT
 	select VIDEOBUF2_VMALLOC
 	select VIDEO_SAA711X if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEO_TVP5150 if MEDIA_SUBDRV_AUTOSELECT
-- 
1.8.4.5

