Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657AbaE1RL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 13:11:29 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46278 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751753AbaE1RL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 13:11:27 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: carlo@caione.org, Boris Brezillon <boris@free-electrons.com>,
        Mark Brown <broonie@kernel.org>, lgirdwood@gmail.com,
        lee.jones@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 2/5] regulator: Pass the config device node to regulator_dev_lookup
Date: Wed, 28 May 2014 19:11:06 +0200
Message-Id: <1401297069-7423-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401297069-7423-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1401297069-7423-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For now, regulator registers only looks for parent supplies in the struct
device of_node.

That means that single devices that expose several regulators in the DT have to
tie the parent supplies to the parent device, instead of the regulator itself
like described in the regulator bindings.

The regulator device node is already present in the regulator_config structure
that is passed to regulator_register. Use it to first match in the regulator
node, and then to the device node itself.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/regulator/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 3e3954252a23..c8e26be5ea01 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3503,7 +3503,7 @@ regulator_register(const struct regulator_desc *regulator_desc,
 	if (supply) {
 		struct regulator_dev *r;
 
-		r = regulator_dev_lookup(dev, NULL, supply, &ret);
+		r = regulator_dev_lookup(dev, config->of_node, supply, &ret);
 
 		if (ret == -ENODEV) {
 			/*
-- 
1.9.3

