Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725AbaF1SSj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:18:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54135 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222AbaF1Rvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:51:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.15 040/139] regulator: s2mpa01: Use correct register for buck1 ramp delay
Date: Sat, 28 Jun 2014 10:46:41 -0700
Message-Id: <20140628174607.261046966@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <k.kozlowski@samsung.com>

commit 112da5cb43427b843e49b8710f53ecdbb3471d9f upstream.

Fix the register for ramp delay of buck1 regulator. Buck1 and buck6
share the field (offset 4) in ramp delay register S2MPA01_REG_RAMP2.

The driver used the same register and field for ramp delay of buck3 and
buck1. This lead to updating of ramp delay of buck3 when setting buck1
and actually the ramp delay of buck1 was never set.

Fixes: f18792714608 ("regulator: Add support for S2MPA01 regulator")
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Reviewed-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/s2mpa01.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/regulator/s2mpa01.c
+++ b/drivers/regulator/s2mpa01.c
@@ -116,7 +116,6 @@ static int s2mpa01_set_ramp_delay(struct
 			ramp_delay = s2mpa01->ramp_delay16;
 
 		ramp_shift = S2MPA01_BUCK16_RAMP_SHIFT;
-		ramp_reg = S2MPA01_REG_RAMP1;
 		break;
 	case S2MPA01_BUCK2:
 		enable_shift = S2MPA01_BUCK2_RAMP_EN_SHIFT;


