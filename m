Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288Ab3FABgR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 21:36:17 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:33277 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756714Ab3FABfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 21:35:54 -0400
From: Julius Werner <jwerner@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dongjin Kim <tobetter@gmail.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Simon Glass <sjg@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olofj@chromium.org>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Julius Werner <jwerner@chromium.org>
Subject: [PATCH 2/3] usb: misc: usb3503: Remove hardcoded disabling of ports 2 and 3
Date: Fri, 31 May 2013 18:34:51 -0700
Message-Id: <1370050492-6046-3-git-send-email-jwerner@chromium.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1370050492-6046-1-git-send-email-jwerner@chromium.org>
References: <1370050492-6046-1-git-send-email-jwerner@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usb3503 driver currently disables port 2 and 3 without explaination.
It doesn't make sense to do this in a mainline Linux driver that should
support all platforms which use this chip. If specific use cases really
require ports to be disabled, this should either be done through local
patches or a configurable mechanism (such as a device tree property).
Until then, let's keep all ports enabled.

Signed-off-by: Julius Werner <jwerner@chromium.org>
---
 drivers/usb/misc/usb3503.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/usb/misc/usb3503.c b/drivers/usb/misc/usb3503.c
index 73aeb87..a647a2e 100644
--- a/drivers/usb/misc/usb3503.c
+++ b/drivers/usb/misc/usb3503.c
@@ -134,14 +134,6 @@ static int usb3503_switch_mode(struct usb3503 *hub, enum usb3503_mode mode)
 			goto err_hubmode;
 		}
 
-		/* PDS : Port2,3 Disable For Self Powered Operation */
-		err = usb3503_set_bits(i2c, USB3503_PDS,
-				(USB3503_PORT2 | USB3503_PORT3));
-		if (err < 0) {
-			dev_err(&i2c->dev, "PDS failed (%d)\n", err);
-			goto err_hubmode;
-		}
-
 		/* CFG1 : SELF_BUS_PWR -> Self-Powerd operation */
 		err = usb3503_set_bits(i2c, USB3503_CFG1, USB3503_SELF_BUS_PWR);
 		if (err < 0) {
-- 
1.7.12.4

