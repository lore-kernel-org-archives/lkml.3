Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055Ab3AXDaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:30:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44298 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015Ab3AXDaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:30:05 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Axel Lin <axel.lin@ingics.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 39/74] regulator: max8998: Ensure enough delay time for max8998_set_voltage_buck_time_sel
Date: Thu, 24 Jan 2013 01:26:51 -0200
Message-Id: <1358998046-613-40-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit 81d0a6ae7befb24c06f4aa4856af7f8d1f612171 upstream.

Use DIV_ROUND_UP to prevent truncation by integer division issue.
This ensures we return enough delay time.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/regulator/max8998.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index 5e56df0..b3b2984 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -447,7 +447,7 @@ static int max8998_set_voltage_buck_time_sel(struct regulator_dev *rdev,
 
 	difference = (new_selector - old_selector) * desc->step / 1000;
 	if (difference > 0)
-		return difference / ((val & 0x0f) + 1);
+		return DIV_ROUND_UP(difference, (val & 0x0f) + 1);
 
 	return 0;
 }
-- 
1.7.9.5

