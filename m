Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265Ab3AYQxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 11:53:22 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:58165 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101Ab3AYQxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 11:53:20 -0500
From: Dongjin Kim <tobetter@gmail.com>
Cc: Dongjin Kim <tobetter@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] USB: misc: usb3503: Fix compiler warning
Date: Sat, 26 Jan 2013 01:53:03 +0900
Message-Id: <1359132788-21652-1-git-send-email-tobetter@gmail.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the compiler warning of uninitialized variable.

drivers/usb/misc/usb3503.c: In function ‘usb3503_probe’:
drivers/usb/misc/usb3503.c:215:13: warning: ‘mode’ may be used uninitialized
in this function [-Wuninitialized]

Signed-off-by: Dongjin Kim <tobetter@gmail.com>
---
 drivers/usb/misc/usb3503.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/misc/usb3503.c b/drivers/usb/misc/usb3503.c
index 471218a..f713f6a 100644
--- a/drivers/usb/misc/usb3503.c
+++ b/drivers/usb/misc/usb3503.c
@@ -185,7 +185,7 @@ static int usb3503_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
 	struct device_node *np = i2c->dev.of_node;
 	struct usb3503 *hub;
 	int err = -ENOMEM;
-	u32 mode;
+	u32 mode = USB3503_MODE_UNKNOWN;
 
 	hub = kzalloc(sizeof(struct usb3503), GFP_KERNEL);
 	if (!hub) {
-- 
1.7.10.4

