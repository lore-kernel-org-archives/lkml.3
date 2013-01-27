Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817Ab3A0EI0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 23:08:26 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47848 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755575Ab3A0EII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 23:08:08 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 01/10] mfd: wm5102: Mark DSP memory regions as volatile and readable
Date: Sun, 27 Jan 2013 12:07:23 +0800
Message-Id: <1359259652-8565-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can cache some of them but this is simpler for now.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5102-tables.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
index 088872a..4a01192 100644
--- a/drivers/mfd/wm5102-tables.c
+++ b/drivers/mfd/wm5102-tables.c
@@ -1825,7 +1825,13 @@ static bool wm5102_readable_register(struct device *dev, unsigned int reg)
 	case ARIZONA_DSP1_STATUS_3:
 		return true;
 	default:
-		return false;
+		if ((reg >= 0x100000 && reg < 0x106000) ||
+		    (reg >= 0x180000 && reg < 0x180800) ||
+		    (reg >= 0x190000 && reg < 0x194800) ||
+		    (reg >= 0x1a8000 && reg < 0x1a9800))
+			return true;
+		else
+			return false;
 	}
 }
 
-- 
1.7.10.4

