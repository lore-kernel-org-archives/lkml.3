Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453AbaLaQVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 11:21:23 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140]:36061 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750726AbaLaQVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 11:21:21 -0500
From: Andrew Jackson <andrew.jackson@arm.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Lars-Peter Clausen <lars@metafoo.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Andrew Jackson <Andrew.Jackson@arm.com>
Subject: [PATCH] ASoC: adi: Add missing return statement.
Date: Wed, 31 Dec 2014 16:20:37 +0000
Message-Id: <1420042837-3337-1-git-send-email-andrew.jackson@arm.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Jackson <Andrew.Jackson@arm.com>

The probe routine was disabling the clock even
if the system was configured successfully.  Add
a return statement to leave clocks enabled.

Signed-off-by: Andrew Jackson <Andrew.Jackson@arm.com>
---
Spotted while reviewing clock preparation

 sound/soc/adi/axi-i2s.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/sound/soc/adi/axi-i2s.c b/sound/soc/adi/axi-i2s.c
index 7752860..4c23381 100644
--- a/sound/soc/adi/axi-i2s.c
+++ b/sound/soc/adi/axi-i2s.c
@@ -240,6 +240,8 @@ static int axi_i2s_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_clk_disable;
 
+	return 0;
+
 err_clk_disable:
 	clk_disable_unprepare(i2s->clk);
 	return ret;
-- 
1.7.1

