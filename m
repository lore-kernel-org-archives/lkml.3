Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758943Ab3DYTP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 15:15:28 -0400
Received: from cm-84.215.157.11.getinternet.no ([84.215.157.11]:48457 "EHLO
	server.arpanet.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751872Ab3DYTP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 15:15:26 -0400
X-Greylist: delayed 492 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Apr 2013 15:15:25 EDT
From: =?UTF-8?q?Jon=20Arne=20J=C3=B8rgensen?= <jonarne@jonarne.no>
To: linux-media@vger.kernel.org
Cc: jonjon.arnearne@gmail.com, linux-kernel@vger.kernel.org,
        hverkuil@xs4all.nl, elezegarcia@gmail.com, mkrufky@linuxtv.org,
        mchehab@redhat.com, bjorn@mork.no
Subject: [RFC V2 3/3] [smi2021] Add smi2021 driver to buildsystem
Date: Thu, 25 Apr 2013 21:10:20 +0200
Message-Id: <1366917020-18217-4-git-send-email-jonarne@jonarne.no>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1366917020-18217-1-git-send-email-jonarne@jonarne.no>
References: <1366917020-18217-1-git-send-email-jonarne@jonarne.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jon Arne Jørgensen <jonarne@jonarne.no>
---
 drivers/media/usb/Kconfig          |  1 +
 drivers/media/usb/Makefile         |  1 +
 drivers/media/usb/smi2021/Kconfig  | 11 +++++++++++
 drivers/media/usb/smi2021/Makefile | 10 ++++++++++
 4 files changed, 23 insertions(+)
 create mode 100644 drivers/media/usb/smi2021/Kconfig
 create mode 100644 drivers/media/usb/smi2021/Makefile

diff --git a/drivers/media/usb/Kconfig b/drivers/media/usb/Kconfig
index 0a7d520..dec0383 100644
--- a/drivers/media/usb/Kconfig
+++ b/drivers/media/usb/Kconfig
@@ -26,6 +26,7 @@ source "drivers/media/usb/hdpvr/Kconfig"
 source "drivers/media/usb/tlg2300/Kconfig"
 source "drivers/media/usb/usbvision/Kconfig"
 source "drivers/media/usb/stk1160/Kconfig"
+source "drivers/media/usb/smi2021/Kconfig"
 endif
 
 if (MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT)
diff --git a/drivers/media/usb/Makefile b/drivers/media/usb/Makefile
index 7f51d7e..932a6ba 100644
--- a/drivers/media/usb/Makefile
+++ b/drivers/media/usb/Makefile
@@ -20,3 +20,4 @@ obj-$(CONFIG_VIDEO_STK1160) += stk1160/
 obj-$(CONFIG_VIDEO_CX231XX) += cx231xx/
 obj-$(CONFIG_VIDEO_TM6000) += tm6000/
 obj-$(CONFIG_VIDEO_EM28XX) += em28xx/
+obj-$(CONFIG_VIDEO_SMI2021) += smi2021/
diff --git a/drivers/media/usb/smi2021/Kconfig b/drivers/media/usb/smi2021/Kconfig
new file mode 100644
index 0000000..6a6fb8a
--- /dev/null
+++ b/drivers/media/usb/smi2021/Kconfig
@@ -0,0 +1,11 @@
+config VIDEO_SMI2021
+	tristate "Somagic SMI2021 USB video/audio capture support"
+	depends on VIDEO_DEV && I2C && SND && USB
+	select VIDEOBUF2_VMALLOC
+	select VIDEO_SAA711X
+	select SND_PCM
+	help
+	  This is a video4linux driver for SMI2021 based video capture devices.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called smi2021
diff --git a/drivers/media/usb/smi2021/Makefile b/drivers/media/usb/smi2021/Makefile
new file mode 100644
index 0000000..8a62f02
--- /dev/null
+++ b/drivers/media/usb/smi2021/Makefile
@@ -0,0 +1,10 @@
+smi2021-y := smi2021_main.o		\
+	     smi2021_bootloader.o	\
+	     smi2021_v4l2.o		\
+	     smi2021_video.o		\
+	     smi2021_i2c.o		\
+	     smi2021_audio.o		\
+
+obj-$(CONFIG_VIDEO_SMI2021) += smi2021.o
+
+ccflags-y += -Idrivers/media/i2c
-- 
1.8.2.1

