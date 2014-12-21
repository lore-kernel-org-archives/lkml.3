Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbaLUVWI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 16:22:08 -0500
Received: from sauhun.de ([89.238.76.85]:52905 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432AbaLUVPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 16:15:33 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH 12/28] of: drop owner assignment from platform_drivers
Date: Sun, 21 Dec 2014 22:14:33 +0100
Message-Id: <1419196495-9626-13-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419196495-9626-1-git-send-email-wsa@the-dreams.de>
References: <1419196495-9626-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This platform_driver does not need to set an owner, it will be populated by the
driver core.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
Generated with coccinelle. SmPL file is in the introductory msg. The big
cleanup was pulled in this merge window. This series catches the bits fallen
through. The patches shall go in via the subsystem trees.

 drivers/of/unittest.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index 844838e11ef1..c5fb657eb8cc 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -1000,7 +1000,6 @@ static struct platform_driver selftest_driver = {
 	.remove			= selftest_remove,
 	.driver = {
 		.name		= "selftest",
-		.owner		= THIS_MODULE,
 		.of_match_table	= of_match_ptr(selftest_match),
 	},
 };
-- 
2.1.3

