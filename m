Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbaKLBZQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:25:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58813 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbaKLBZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:25:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.17 115/319] media: siano: add support for PCTV 77e
Date: Wed, 12 Nov 2014 10:14:13 +0900
Message-Id: <20141112011011.623538179@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

commit 29bbb7bd0a65e01a0423e1df764676119b71ecb3 upstream.

Add support for PCTV microStick (77e) device that uses a sms1140
chipset.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/common/siano/sms-cards.c |    6 ++++++
 drivers/media/common/siano/sms-cards.h |    1 +
 drivers/media/usb/siano/smsusb.c       |    2 ++
 3 files changed, 9 insertions(+)

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
--- a/drivers/media/common/siano/sms-cards.h
+++ b/drivers/media/common/siano/sms-cards.h
@@ -45,6 +45,7 @@
 #define SMS1XXX_BOARD_SIANO_RIO		18
 #define SMS1XXX_BOARD_SIANO_DENVER_1530	19
 #define SMS1XXX_BOARD_SIANO_DENVER_2160 20
+#define SMS1XXX_BOARD_PCTV_77E		21
 
 struct sms_board_gpio_cfg {
 	int lna_vhf_exist;
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -655,6 +655,8 @@ static const struct usb_device_id smsusb
 		.driver_info = SMS1XXX_BOARD_ONDA_MDTV_DATA_CARD },
 	{ USB_DEVICE(0x3275, 0x0080),
 		.driver_info = SMS1XXX_BOARD_SIANO_RIO },
+	{ USB_DEVICE(0x2013, 0x0257),
+		.driver_info = SMS1XXX_BOARD_PCTV_77E },
 	{ } /* Terminating entry */
 	};
 


