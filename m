Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655AbaEZI1Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 04:27:25 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:37972 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbaEZI1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 04:27:24 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-d5-5382fadffe1e
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sachin Kamat <sachin.kamat@linaro.org>, linux-kernel@vger.kernel.org
Cc: Axel Lin <axel.lin@ingics.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>, stable@vger.kernel.org
Subject: [PATCH v2] regulator: s2mpa01: Use correct register for buck1 ramp
 delay
Date: Mon, 26 May 2014 10:26:46 +0200
Message-id: <1401092806-25664-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOJMWRmVeSWpSXmKPExsVy+t/xa7r3fzUFG3RMNLM4Mucrs8XUh0/Y
	LF6/MLT4dqWDyeLyrjlsFif/9DJaXFzxhcliwcZHjA4cHjtn3WX3aPtZ5rFpVSebx51re9g8
	+rasYvT4vEkugC2KyyYlNSezLLVI3y6BK2Pmkj8sBU2cFcd3LmRrYDzI3sXIySEhYCLRd3Yn
	G4QtJnHh3nogm4tDSGApo8TKAwtYIJw+Jon/39YwglSxCRhLbF6+BKxKRGAbo8S7T1fBEswC
	2RLLL04Es4UFgiVeLZ4HtoJFQFVi17cuMJtXwF3ixodlUKvlJE4em8w6gZF7ASPDKkbR1NLk
	guKk9FxDveLE3OLSvHS95PzcTYyQwPmyg3HxMatDjAIcjEo8vCeCmoKFWBPLiitzDzFKcDAr
	ifA2fwAK8aYkVlalFuXHF5XmpBYfYmTi4JRqYLRlP75M6fuEsF+MO/uefrsxcVPa8uIAi9Xs
	k7hdXzvZ+x5q/jGhs2qj5tUTng6Xeth5BIP3BDkwRk5e37b2x/Ipk7gCcor1Cy9KNy5l2zvT
	2XaTgIYU07XgmtMdJu+DS6d1Fy9Tl5V49lb3rb3DzB26qpMuf8p0TtzFPN9x3vWSi4FT9jlx
	iymxFGckGmoxFxUnAgAYm7X7+gEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the register for ramp delay of buck1 regulator. Buck1 and buck6
share the field (offset 4) in ramp delay register S2MPA01_REG_RAMP2.

The driver used the same register and field for ramp delay of buck3 and
buck1. This lead to updating of ramp delay of buck3 when setting buck1
and actually the ramp delay of buck1 was never set.

Cc: <stable@vger.kernel.org>
Fixes: f18792714608 ("regulator: Add support for S2MPA01 regulator")
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
Changes since v1:
1. Adjust the patch to match datasheet of S2MPA01.
---
 drivers/regulator/s2mpa01.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/regulator/s2mpa01.c b/drivers/regulator/s2mpa01.c
index f19a30f0fb42..a52cb1cec576 100644
--- a/drivers/regulator/s2mpa01.c
+++ b/drivers/regulator/s2mpa01.c
@@ -116,7 +116,6 @@ static int s2mpa01_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
 			ramp_delay = s2mpa01->ramp_delay16;
 
 		ramp_shift = S2MPA01_BUCK16_RAMP_SHIFT;
-		ramp_reg = S2MPA01_REG_RAMP1;
 		break;
 	case S2MPA01_BUCK2:
 		enable_shift = S2MPA01_BUCK2_RAMP_EN_SHIFT;
-- 
1.9.1

