Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751200AbaH1Msd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 08:48:33 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:57574 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbaH1Msb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 08:48:31 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        alsa-devel@alsa-project.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] ASoC: Allow SND_SOC_WM8978 to be selected manually
Date: Thu, 28 Aug 2014 14:48:24 +0200
Message-Id: <1409230104-22750-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using a DT-based multi-platform kernel, there's not always Kconfig
logic that selects the right codec driver.
Allow the user to manually select WM8978.

This is needed for Armadillo 800 EVA using a generic r8a7740 multi-platform
kernel.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 sound/soc/codecs/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 7678122f8fe0..8ab154756934 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -731,7 +731,8 @@ config SND_SOC_WM8974
 	tristate
 
 config SND_SOC_WM8978
-	tristate
+	tristate "Wolfson Microelectronics WM8978 codec"
+	depends on I2C
 
 config SND_SOC_WM8983
 	tristate
-- 
1.9.1

