Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbaIXNrd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:47:33 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50982 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465AbaIXNrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:47:31 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/22] phy: phy-ti-pipe3: Remove unncessary site specific OOM messages
Date: Wed, 24 Sep 2014 19:17:03 +0530
Message-ID: <1411566440-19169-6-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411566440-19169-1-git-send-email-kishon@ti.com>
References: <1411566440-19169-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Griffin <peter.griffin@linaro.org>

The site specific OOM messages are unncessary, because they duplicate
messages from the memory subsystem which include dump_stack().

Removing these superflous messages makes the kernel smaller. A discussion
here http://patchwork.ozlabs.org/patch/324158/ found that all error paths
from kzalloc will print a error message, and that any error path which maybe
found which doesn't would be considered a bug in kzalloc.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-ti-pipe3.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/phy/phy-ti-pipe3.c b/drivers/phy/phy-ti-pipe3.c
index b964aa9..9280ef8 100644
--- a/drivers/phy/phy-ti-pipe3.c
+++ b/drivers/phy/phy-ti-pipe3.c
@@ -299,10 +299,9 @@ static int ti_pipe3_probe(struct platform_device *pdev)
 	struct clk *clk;
 
 	phy = devm_kzalloc(&pdev->dev, sizeof(*phy), GFP_KERNEL);
-	if (!phy) {
-		dev_err(&pdev->dev, "unable to alloc mem for TI PIPE3 PHY\n");
+	if (!phy)
 		return -ENOMEM;
-	}
+
 	phy->dev		= &pdev->dev;
 
 	if (!of_device_is_compatible(node, "ti,phy-pipe3-pcie")) {
-- 
1.7.9.5

