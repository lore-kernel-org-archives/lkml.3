Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201Ab3KFKRD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 05:17:03 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:51861 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137Ab3KFKRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 05:17:00 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>,
        alsa-devel@alsa-project.org, Mark Brown <broonie@kernel.org>
Subject: [PATCH 07/13] ASoC: ux500_pcm: Extract MSP IDs from Device Tree
Date: Wed,  6 Nov 2013 10:16:19 +0000
Message-Id: <1383732985-18928-8-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383732985-18928-1-git-send-email-lee.jones@linaro.org>
References: <1383732985-18928-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required for indexing pre-defined channel configuration structures.

Cc: alsa-devel@alsa-project.org
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 sound/soc/ux500/ux500_msp_i2s.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/ux500/ux500_msp_i2s.c b/sound/soc/ux500/ux500_msp_i2s.c
index 1ca8b08..0a99372 100644
--- a/sound/soc/ux500/ux500_msp_i2s.c
+++ b/sound/soc/ux500/ux500_msp_i2s.c
@@ -665,6 +665,13 @@ int ux500_msp_i2s_init_msp(struct platform_device *pdev,
 				sizeof(struct msp_i2s_platform_data), GFP_KERNEL);
 			if (!platform_data)
 				return -ENOMEM;
+
+			if (!of_property_read_u32(np, "id",
+						  &platform_data->id)) {
+				dev_err(&pdev->dev,
+					"No 'id' property found in DT\n");
+				return -EINVAL;
+			}
 		}
 	} else
 		if (!platform_data)
-- 
1.8.1.2

