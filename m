Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617AbaF2VnB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 17:43:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54279 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbaF2VnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 17:43:00 -0400
From: Colin King <colin.king@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@linaro.org>, Jingoo Han <jg1.han@samsung.com>,
        linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] usb: usb3503: return correct error return on failure
Date: Sun, 29 Jun 2014 22:42:53 +0100
Message-Id: <1404078173-11921-1-git-send-email-colin.king@canonical.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Fix warning: drivers/usb/misc/usb3503.c:195:11: warning: 'err'
  may be used uninitialized in this function [-Wmaybe-uninitialized]

err is not initialized, the error return should be PTR_ERR(clk)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/usb/misc/usb3503.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/misc/usb3503.c b/drivers/usb/misc/usb3503.c
index f43c619..c0c898d 100644
--- a/drivers/usb/misc/usb3503.c
+++ b/drivers/usb/misc/usb3503.c
@@ -192,7 +192,8 @@ static int usb3503_probe(struct usb3503 *hub)
 
 		clk = devm_clk_get(dev, "refclk");
 		if (IS_ERR(clk) && PTR_ERR(clk) != -ENOENT) {
-			dev_err(dev, "unable to request refclk (%d)\n", err);
+			dev_err(dev, "unable to request refclk (%ld)\n",
+				PTR_ERR(clk));
 			return PTR_ERR(clk);
 		}
 
-- 
2.0.0

