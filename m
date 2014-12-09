Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016AbaLINNF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 08:13:05 -0500
Received: from atl4mhob13.myregisteredsite.com ([209.17.115.51]:57245 "EHLO
	atl4mhob13.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755234AbaLINNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 08:13:04 -0500
X-TCPREMOTEIP: 88.159.208.100
X-Authenticated-UID: mike@milosoftware.com
From: Mike Looijmans <mike.looijmans@topic.nl>
To: broonie@kernel.org, lgirdwood@gmail.com
Cc: linux-kernel@vger.kernel.org, Mike Looijmans <mike.looijmans@topic.nl>
Subject: [PATCH 1/2] drivers/regulator/core.c: Don't print error on EPROBE_DEFER
Date: Tue,  9 Dec 2014 14:12:43 +0100
Message-Id: <1418130764-22440-1-git-send-email-mike.looijmans@topic.nl>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a regulator depends on another regulator that happens to be called
later, the kernel always prints a message like this:
  reg-fixed-voltage regulator_sd1: Failed to find supply vin
Since the deferral is not something fatal, nor even something the user
may need to be aware about, reduce the message to debug level.

This fixes a storm of error messages at boot when a board has a power
regulator on an I2C bus which powers GPIO controlled regulators for
example.

Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>
---
 drivers/regulator/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index e225711..9fb66cd 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3715,7 +3715,7 @@ regulator_register(const struct regulator_desc *regulator_desc,
 			ret = 0;
 			goto add_dev;
 		} else if (!r) {
-			dev_err(dev, "Failed to find supply %s\n", supply);
+			dev_dbg(dev, "Failed to find supply %s\n", supply);
 			ret = -EPROBE_DEFER;
 			goto scrub;
 		}
-- 
1.7.9.5

