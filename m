Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbaK0JEm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 04:04:42 -0500
Received: from mail.kernel.org ([198.145.19.201]:41879 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105AbaK0IsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:48:01 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@linaro.org>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 44/91] ASoC: samsung-i2s: Check secondary DAI exists before referencing
Date: Thu, 27 Nov 2014 16:42:27 +0800
Message-Id: <1417077794-9299-44-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 133c2681c4a0c1b589d138c2fdd0f131bdce20ed upstream.

In a couple of places the driver is missing a check to ensure there is a
secondary DAI before it de-references the pointer to it, causing a null
pointer de-reference. This patch adds a check to avoid this.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
[lizf: Backported to 3.4: drop the changes to i2s_shutdown()]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 sound/soc/samsung/i2s.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/samsung/i2s.c b/sound/soc/samsung/i2s.c
index 6ac7b82..9998719 100644
--- a/sound/soc/samsung/i2s.c
+++ b/sound/soc/samsung/i2s.c
@@ -392,7 +392,7 @@ static int i2s_set_sysclk(struct snd_soc_dai *dai,
 		if (dir == SND_SOC_CLOCK_IN)
 			rfs = 0;
 
-		if ((rfs && other->rfs && (other->rfs != rfs)) ||
+		if ((rfs && other && other->rfs && (other->rfs != rfs)) ||
 				(any_active(i2s) &&
 				(((dir == SND_SOC_CLOCK_IN)
 					&& !(mod & MOD_CDCLKCON)) ||
-- 
1.9.1

