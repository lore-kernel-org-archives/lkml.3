Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009AbaDALTC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:19:02 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42750 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990AbaDALS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:18:59 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stephen Warren <swarren@nvidia.com>, Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 131/144] ASoC: max98090: make REVISION_ID readable
Date: Tue,  1 Apr 2014 12:15:35 +0100
Message-Id: <1396350948-29910-132-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Warren <swarren@nvidia.com>

commit e126a646f77fdd66978785cb0a3a5e46b07aee2e upstream.

The REVISION_ID register is not currently marked readable. snd_soc_read()
refuses to read the register, and hence probe() fails.

Fixes: d4807ad2c4c0 ("regmap: Check readable regs in _regmap_read")
[exposed the bug, by checking for readability]
Fixes: 685e42154dcf ("ASoC: Replace max98090 Device Driver")
[left out this register from the readable list]
Signed-off-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/codecs/max98090.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
index b8f9fc5..29c3689 100644
--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -336,6 +336,7 @@ static bool max98090_readable_register(struct device *dev, unsigned int reg)
 	case M98090_REG_RECORD_TDM_SLOT:
 	case M98090_REG_SAMPLE_RATE:
 	case M98090_REG_DMIC34_BIQUAD_BASE ... M98090_REG_DMIC34_BIQUAD_BASE + 0x0E:
+	case M98090_REG_REVISION_ID:
 		return true;
 	default:
 		return false;
-- 
1.9.1

