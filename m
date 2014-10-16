Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbaJPQt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 12:49:58 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:34976 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbaJPQtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 12:49:55 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Doug Anderson <dianders@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v2 3/7] regulator: max77802: Don't treat OFF as an operating mode
Date: Thu, 16 Oct 2014 18:48:49 +0200
Message-Id: <1413478133-2577-4-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1413478133-2577-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1413478133-2577-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only operating modes that are supported by the regulators in the
max77802 PMIC are Output ON (normal) and Output On in Low Power Mode.
OFF was wrongly counted as an operating mode while is only a regulator
status. Make clear in the code that OFF is not an operating mode.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---

Changes since v1: None

 drivers/regulator/max77802.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/max77802.c b/drivers/regulator/max77802.c
index dae2c1a..3abf99d 100644
--- a/drivers/regulator/max77802.c
+++ b/drivers/regulator/max77802.c
@@ -49,6 +49,7 @@
 #define MAX77802_RAMP_RATE_MASK_4BIT	0xF0
 #define MAX77802_RAMP_RATE_SHIFT_4BIT	4
 
+#define MAX77802_STATUS_OFF		0x0
 #define MAX77802_OFF_PWRREQ		0x1
 #define MAX77802_LP_PWRREQ		0x2
 
@@ -615,7 +616,7 @@ static int max77802_pmic_probe(struct platform_device *pdev)
 		 * the hardware reports OFF as the regulator operating mode.
 		 * Default to operating mode NORMAL in that case.
 		 */
-		if (val == MAX77802_OPMODE_OFF)
+		if (val == MAX77802_STATUS_OFF)
 			max77802->opmode[id] = MAX77802_OPMODE_NORMAL;
 		else
 			max77802->opmode[id] = val;
-- 
2.1.0

