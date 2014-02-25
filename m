Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbaBYIsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 03:48:30 -0500
Received: from smtp4.epfl.ch ([128.178.224.219]:36164 "EHLO smtp4.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbaBYIs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 03:48:29 -0500
From: =?UTF-8?q?Philippe=20R=C3=A9tornaz?= <philippe.retornaz@epfl.ch>
To: sachin.kamat@linaro.org, broonie@kernel.org
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com,
        =?UTF-8?q?Philippe=20R=C3=A9tornaz?= <philippe.retornaz@epfl.ch>
Subject: [PATCH 1/1] regulator: mc13xxx: check if DT is enabled
Date: Tue, 25 Feb 2014 09:47:51 +0100
Message-Id: <1393318071-13524-1-git-send-email-philippe.retornaz@epfl.ch>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <CAK9yfHyAK+LtQLr_b-OLHa63dSNT5KN7MBHxqVoTbiHVb4-7DA@mail.gmail.com>
References: <CAK9yfHyAK+LtQLr_b-OLHa63dSNT5KN7MBHxqVoTbiHVb4-7DA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fix a regression on non-DT board booted with a DT enabled kernel

Signed-off-by: Philippe Rétornaz <philippe.retornaz@epfl.ch>
---
 drivers/regulator/mc13xxx-regulator-core.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/regulator/mc13xxx-regulator-core.c b/drivers/regulator/mc13xxx-regulator-core.c
index 4498a3f..a10c999 100644
--- a/drivers/regulator/mc13xxx-regulator-core.c
+++ b/drivers/regulator/mc13xxx-regulator-core.c
@@ -167,6 +167,9 @@ int mc13xxx_get_num_regulators_dt(struct platform_device *pdev)
 	struct device_node *parent;
 	int num;
 
+	if(!pdev->dev.parent->of_node)
+		return -ENODEV;
+
 	of_node_get(pdev->dev.parent->of_node);
 	parent = of_get_child_by_name(pdev->dev.parent->of_node, "regulators");
 	if (!parent)
@@ -187,6 +190,9 @@ struct mc13xxx_regulator_init_data *mc13xxx_parse_regulators_dt(
 	struct device_node *parent, *child;
 	int i, parsed = 0;
 
+	if(!pdev->dev.parent->of_node)
+		return NULL;
+
 	of_node_get(pdev->dev.parent->of_node);
 	parent = of_get_child_by_name(pdev->dev.parent->of_node, "regulators");
 	if (!parent)
-- 
1.7.9.5

