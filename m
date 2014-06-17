Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514AbaFQLLw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 07:11:52 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:40306 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbaFQLLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 07:11:51 -0400
From: Tushar Behera <tushar.b@samsung.com>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Cc: gregkh@linuxfoundation.org, m.szyprowski@samsung.com, trblinux@gmail.com
Subject: [PATCH] usb: misc: usb3503: Update error code in print message
Date: Tue, 17 Jun 2014 16:38:50 +0530
Message-Id: <1403003330-17553-1-git-send-email-tushar.b@samsung.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'err' is uninitialized, rather print the error code directly.

This also fixes following warning.
drivers/usb/misc/usb3503.c: In function ‘usb3503_probe’:
drivers/usb/misc/usb3503.c:195:11: warning: ‘err’ may be used uninitialized
in this function [-Wmaybe-uninitialized]
    dev_err(dev, "unable to request refclk (%d)\n", err);

Signed-off-by: Tushar Behera <tushar.b@samsung.com>
---

Based on next-20140616.

 drivers/usb/misc/usb3503.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/misc/usb3503.c b/drivers/usb/misc/usb3503.c
index f43c619..652855b 100644
--- a/drivers/usb/misc/usb3503.c
+++ b/drivers/usb/misc/usb3503.c
@@ -192,7 +192,8 @@ static int usb3503_probe(struct usb3503 *hub)
 
 		clk = devm_clk_get(dev, "refclk");
 		if (IS_ERR(clk) && PTR_ERR(clk) != -ENOENT) {
-			dev_err(dev, "unable to request refclk (%d)\n", err);
+			dev_err(dev, "unable to request refclk (%ld)\n",
+					PTR_ERR(clk));
 			return PTR_ERR(clk);
 		}
 
-- 
1.7.9.5

