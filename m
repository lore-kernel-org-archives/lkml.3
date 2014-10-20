Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbaJTOsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 10:48:45 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:39899 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbaJTOsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 10:48:37 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v3 1/5] regulator: of: Decrement refcount for suspend state nodes
Date: Mon, 20 Oct 2014 16:47:48 +0200
Message-Id: <1413816472-1895-2-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1413816472-1895-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1413816472-1895-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_get_regulation_constraints() calls of_get_child_by_name() to find the
regulator-state-{mem,disk} child nodes for each regulator. This function
increments the device node reference counter but this is not decremented
once the function is done using the node.

Fix that by calling of_node_put() after finishing using the device node.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/regulator/of_regulator.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index b375ffe..f0d19fc 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -107,6 +107,7 @@ static void of_get_regulation_constraints(struct device_node *np,
 					"regulator-off-in-suspend"))
 			suspend_state->disabled = true;
 
+		of_node_put(suspend_np);
 		suspend_state = NULL;
 		suspend_np = NULL;
 	}
-- 
2.1.0

