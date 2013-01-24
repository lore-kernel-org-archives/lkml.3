Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199Ab3AXV3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:29:42 -0500
Received: from mail.kernel.org ([198.145.19.201]:40436 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757007Ab3AXVOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:14:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Marek Vasut <marex@denx.de>, Wolfram Sang <w.sang@pengutronix.de>
Subject: [ 43/46] i2c: mxs: Fix type of error code
Date: Thu, 24 Jan 2013 13:13:21 -0800
Message-Id: <20130124211151.038844255@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130124211135.862755794@linuxfoundation.org>
References: <20130124211135.862755794@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <fabio.estevam@freescale.com>

commit 0f40cbc4f85e13b1a42ae2f41231645a14965872 upstream.

cmd_err is used to handle error code, so it should not be unsigned.

This fixes the following warning when building with W=1 option:

drivers/i2c/busses/i2c-mxs.c: In function 'mxs_i2c_xfer_msg':
drivers/i2c/busses/i2c-mxs.c:331:19: warning: comparison between signed and unsigned integer expressions [-Wsign-compare]

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Acked-by: Marek Vasut <marex@denx.de>
Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-mxs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-mxs.c
+++ b/drivers/i2c/busses/i2c-mxs.c
@@ -127,7 +127,7 @@ struct mxs_i2c_dev {
 	struct device *dev;
 	void __iomem *regs;
 	struct completion cmd_complete;
-	u32 cmd_err;
+	int cmd_err;
 	struct i2c_adapter adapter;
 	const struct mxs_i2c_speed_config *speed;
 


