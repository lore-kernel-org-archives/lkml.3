Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab3EUSNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 14:13:38 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46874 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab3EUSNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 14:13:36 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 21 May 2013 13:13:16 -0500
Message-Id: <1369160001-4019-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369160001-4019-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130521181230.GF1627@sirena.org.uk>
 <1369160001-4019-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-SA-Exim-Connect-IP: 144.188.69.1
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 2/7] mfd: wm5102: Manually apply register patch
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

Future updates will require us to manually apply the register patch for
wm5102.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 81907f9..25bfd1e 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -368,6 +368,18 @@ static int arizona_runtime_resume(struct device *dev)
 		break;
 	}
 
+	switch (arizona->type) {
+	case WM5102:
+		ret = wm5102_patch(arizona);
+		if (ret != 0) {
+			dev_err(arizona->dev, "Failed to apply patch: %d\n",
+				ret);
+			goto err;
+		}
+	default:
+		break;
+	}
+
 	ret = regcache_sync(arizona->regmap);
 	if (ret != 0) {
 		dev_err(arizona->dev, "Failed to restore register cache\n");
-- 
1.7.10.4

