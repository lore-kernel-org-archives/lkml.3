Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab3IVLWA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 07:22:00 -0400
Received: from smtp-out-086.synserver.de ([212.40.185.86]:1040 "EHLO
	smtp-out-084.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752349Ab3IVLV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 07:21:59 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 27075
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] regulator: of_get_regulation_constraints: Use node name as fallback
Date: Sun, 22 Sep 2013 12:47:34 +0200
Message-Id: <1379846854-11746-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the "regulator-name" property is not present use the name of the devicetree
node as a fallback.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/regulator/of_regulator.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index 7827384..53a83e8 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -25,6 +25,8 @@ static void of_get_regulation_constraints(struct device_node *np,
 	struct regulation_constraints *constraints = &(*init_data)->constraints;
 
 	constraints->name = of_get_property(np, "regulator-name", NULL);
+	if (!constraints->name)
+		constraints->name = np->name;
 
 	min_uV = of_get_property(np, "regulator-min-microvolt", NULL);
 	if (min_uV)
-- 
1.7.10.4

