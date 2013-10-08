Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934Ab3JHUiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 16:38:20 -0400
Received: from sauhun.de ([89.238.76.85]:52207 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756716Ab3JHUfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 16:35:54 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Marek Vasut <marex@denx.de>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/9] i2c: i2c-mxs: replace platform_driver_probe to support deferred probing
Date: Tue,  8 Oct 2013 22:35:35 +0200
Message-Id: <1381264542-29396-4-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381264542-29396-1-git-send-email-wsa@the-dreams.de>
References: <1381264542-29396-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subsystems like pinctrl and gpio rightfully make use of deferred probing at
core level. Now, deferred drivers won't be retried if they don't have a .probe
function specified in the driver struct. Fix this driver to have that, so the
devices it supports won't get lost in a deferred probe.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Cc: Marek Vasut <marex@denx.de>
---
 drivers/i2c/busses/i2c-mxs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-mxs.c b/drivers/i2c/busses/i2c-mxs.c
index f4a0167..b7c8577 100644
--- a/drivers/i2c/busses/i2c-mxs.c
+++ b/drivers/i2c/busses/i2c-mxs.c
@@ -780,12 +780,13 @@ static struct platform_driver mxs_i2c_driver = {
 		   .owner = THIS_MODULE,
 		   .of_match_table = mxs_i2c_dt_ids,
 		   },
+	.probe = mxs_i2c_probe,
 	.remove = mxs_i2c_remove,
 };
 
 static int __init mxs_i2c_init(void)
 {
-	return platform_driver_probe(&mxs_i2c_driver, mxs_i2c_probe);
+	return platform_driver_register(&mxs_i2c_driver);
 }
 subsys_initcall(mxs_i2c_init);
 
-- 
1.8.4.rc3

