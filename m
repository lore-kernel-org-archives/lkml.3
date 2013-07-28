Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab3G1OD4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 10:03:56 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57977 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597Ab3G1ODy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 10:03:54 -0400
From: Mark Brown <broonie@kernel.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Mark Brown <broonie@linaro.org>
Date: Sun, 28 Jul 2013 15:03:48 +0100
Message-Id: <1375020228-25965-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.3.2
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] mfd: stmpe: Staticise stmpe_of_probe()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

It is only called from this file so there is no need for it to be in the
global namespace and cause sparse to warn.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/mfd/stmpe.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index 5d5e6f9..fff63a4 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -1106,7 +1106,8 @@ static int stmpe_devices_init(struct stmpe *stmpe)
 	return ret;
 }
 
-void stmpe_of_probe(struct stmpe_platform_data *pdata, struct device_node *np)
+static void stmpe_of_probe(struct stmpe_platform_data *pdata,
+			   struct device_node *np)
 {
 	struct device_node *child;
 
-- 
1.8.3.2

