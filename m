Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151Ab3K0QYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 11:24:25 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36461 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359Ab3K0QYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 11:24:24 -0500
From: Mark Brown <broonie@kernel.org>
To: Fabio Estevam <festevam@gmail.com>, Liam Girdwood <lgirdwood@gmail.com>
Cc: thierry.reding@gmail.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Date: Wed, 27 Nov 2013 16:24:17 +0000
Message-Id: <1385569457-8650-2-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1385569457-8650-1-git-send-email-broonie@kernel.org>
References: <1385569457-8650-1-git-send-email-broonie@kernel.org>
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 2/2] regulator: core: Check for DT every time we check full constraints
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Eliminate the gap between DT becoming available and this being used to say
we have full constraints by checking directly for DT every time we check
for full constraints. This improves interoperaton with optional regulator
support.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 02fdf925bb56..d85f31385b24 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -121,7 +121,7 @@ static const char *rdev_get_name(struct regulator_dev *rdev)
 
 static bool have_full_constraints(void)
 {
-	return has_full_constraints;
+	return has_full_constraints || of_have_populated_dt();
 }
 
 /**
-- 
1.8.4.4

