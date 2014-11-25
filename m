Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbaKYL0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:26:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58624 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbaKYKmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:42:02 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 125/254] [media] siano: add support for PCTV 77e
Date: Tue, 25 Nov 2014 10:37:55 +0000
Message-Id: <1416912004-5928-126-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

commit 29bbb7bd0a65e01a0423e1df764676119b71ecb3 upstream.

Add support for PCTV microStick (77e) device that uses a sms1140
chipset.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/common/siano/sms-cards.c | 6 ++++++
 drivers/media/common/siano/sms-cards.h | 1 +
 drivers/media/usb/siano/smsusb.c       | 2 ++
 3 files changed, 9 insertions(+)

diff --git a/drivers/media/common/siano/sms-cards.c b/drivers/media/common/siano/sms-cards.c
index 82769993eeb7..82c7a1289f05 100644
--- a/drivers/media/common/siano/sms-cards.c
+++ b/drivers/media/common/siano/sms-cards.c
@@ -157,6 +157,12 @@ static struct sms_board sms_boards[] = {
 		.type = SMS_DENVER_2160,
 		.default_mode = DEVICE_MODE_DAB_TDMB,
 	},
+	[SMS1XXX_BOARD_PCTV_77E] = {
+		.name	= "Hauppauge microStick 77e",
+		.type	= SMS_NOVA_B0,
+		.fw[DEVICE_MODE_DVBT_BDA] = SMS_FW_DVB_NOVA_12MHZ_B0,
+		.default_mode = DEVICE_MODE_DVBT_BDA,
+	},
 };
 
 struct sms_board *sms_get_board(unsigned id)
diff --git a/drivers/media/common/siano/sms-cards.h b/drivers/media/common/siano/sms-cards.h
index c63b544c49c5..4c4caddf9869 100644
--- a/drivers/media/common/siano/sms-cards.h
+++ b/drivers/media/common/siano/sms-cards.h
@@ -45,6 +45,7 @@
 #define SMS1XXX_BOARD_SIANO_RIO		18
 #define SMS1XXX_BOARD_SIANO_DENVER_1530	19
 #define SMS1XXX_BOARD_SIANO_DENVER_2160 20
+#define SMS1XXX_BOARD_PCTV_77E		21
 
 struct sms_board_gpio_cfg {
 	int lna_vhf_exist;
diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index 1836a416d806..89c86ee2b225 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -655,6 +655,8 @@ static const struct usb_device_id smsusb_id_table[] = {
 		.driver_info = SMS1XXX_BOARD_ONDA_MDTV_DATA_CARD },
 	{ USB_DEVICE(0x3275, 0x0080),
 		.driver_info = SMS1XXX_BOARD_SIANO_RIO },
+	{ USB_DEVICE(0x2013, 0x0257),
+		.driver_info = SMS1XXX_BOARD_PCTV_77E },
 	{ } /* Terminating entry */
 	};
 
-- 
2.1.0

