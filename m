Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbaDKGy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 02:54:57 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:51073 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbaDKGys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 02:54:48 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s3B6s4Ru016311, This message is accepted by code: ctloc85258
From: <rogerable@realtek.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Chris Ball <chris@printf.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oliver Neukum <oneukum@suse.de>
CC: <rogerable@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <driverdev-devel@linuxdriverproject.org>,
        <wei_wang@realsil.com.cn>, <micky_ching@realsil.com.cn>
Subject: [PATCH v7 2/4] [v6 fix] mfd/rtsx_usb: add comment in rtsx_usb_suspend
Date: Fri, 11 Apr 2014 14:53:21 +0800
Message-ID: <1397199203-2235-3-git-send-email-rogerable@realtek.com>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1397199203-2235-1-git-send-email-rogerable@realtek.com>
References: <1397199203-2235-1-git-send-email-rogerable@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.81.189]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roger Tseng <rogerable@realtek.com>

Explain why there is no need to have a symmetric LED turn-on in resume handler
while calling rtsx_usb_turn_off_led() in suspend handler.

Signed-off-by: Roger Tseng <rogerable@realtek.com>
---
 drivers/mfd/rtsx_usb.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/mfd/rtsx_usb.c b/drivers/mfd/rtsx_usb.c
index 0ca7973..141ea52 100644
--- a/drivers/mfd/rtsx_usb.c
+++ b/drivers/mfd/rtsx_usb.c
@@ -687,9 +687,15 @@ static int rtsx_usb_suspend(struct usb_interface *intf, pm_message_t message)
 	dev_dbg(&intf->dev, "%s called with pm message 0x%04u\n",
 			__func__, message.event);
 
+	/*
+	 * Call to make sure LED is off during suspend to save more power.
+	 * It is NOT a permanent state and could be turned on anytime later.
+	 * Thus no need to call turn_on when resunming.
+	 */
 	mutex_lock(&ucr->dev_mutex);
 	rtsx_usb_turn_off_led(ucr);
 	mutex_unlock(&ucr->dev_mutex);
+
 	return 0;
 }
 
-- 
1.8.2

