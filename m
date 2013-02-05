Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336Ab3BEWJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:09:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47940 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296Ab3BEWJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:09:16 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 26/93] i2c: mxs: Fix type of error code
Date: Tue,  5 Feb 2013 20:06:15 -0200
Message-Id: <1360102042-10732-27-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

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
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/i2c/busses/i2c-mxs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-mxs.c b/drivers/i2c/busses/i2c-mxs.c
index 04eb441..a505bce 100644
--- a/drivers/i2c/busses/i2c-mxs.c
+++ b/drivers/i2c/busses/i2c-mxs.c
@@ -110,7 +110,7 @@ struct mxs_i2c_dev {
 	struct device *dev;
 	void __iomem *regs;
 	struct completion cmd_complete;
-	u32 cmd_err;
+	int cmd_err;
 	struct i2c_adapter adapter;
 };
 
-- 
1.7.9.5

