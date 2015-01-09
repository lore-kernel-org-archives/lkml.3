Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468AbbAIRY0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 12:24:26 -0500
Received: from sauhun.de ([89.238.76.85]:49571 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757927AbbAIRWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 12:22:24 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linux-mips@linux-mips.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Wolfram Sang <wsa@the-dreams.de>, linux-kernel@vger.kernel.org
Subject: [RFC 07/11] i2c: axxia: make use of the new infrastructure for quirks
Date: Fri,  9 Jan 2015 18:21:37 +0100
Message-Id: <1420824103-24169-8-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1420824103-24169-1-git-send-email-wsa@the-dreams.de>
References: <1420824103-24169-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/i2c/busses/i2c-axxia.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/i2c/busses/i2c-axxia.c b/drivers/i2c/busses/i2c-axxia.c
index 768a598d8d03..488c5d3bf9db 100644
--- a/drivers/i2c/busses/i2c-axxia.c
+++ b/drivers/i2c/busses/i2c-axxia.c
@@ -336,11 +336,6 @@ static int axxia_i2c_xfer_msg(struct axxia_i2c_dev *idev, struct i2c_msg *msg)
 	u32 addr_1, addr_2;
 	int ret;
 
-	if (msg->len > 255) {
-		dev_warn(idev->dev, "unsupported length %u\n", msg->len);
-		return -EINVAL;
-	}
-
 	idev->msg = msg;
 	idev->msg_xfrd = 0;
 	idev->msg_err = 0;
@@ -454,6 +449,11 @@ static const struct i2c_algorithm axxia_i2c_algo = {
 	.functionality = axxia_i2c_func,
 };
 
+static struct i2c_adapter_quirks axxia_i2c_quirks = {
+	.max_read_len = 255,
+	.max_write_len = 255,
+};
+
 static int axxia_i2c_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
@@ -511,6 +511,7 @@ static int axxia_i2c_probe(struct platform_device *pdev)
 	strlcpy(idev->adapter.name, pdev->name, sizeof(idev->adapter.name));
 	idev->adapter.owner = THIS_MODULE;
 	idev->adapter.algo = &axxia_i2c_algo;
+	idev->adapter.quirks = &axxia_i2c_quirks;
 	idev->adapter.dev.parent = &pdev->dev;
 	idev->adapter.dev.of_node = pdev->dev.of_node;
 
-- 
2.1.3

