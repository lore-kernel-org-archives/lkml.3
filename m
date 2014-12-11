Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572AbaLKEPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 23:15:52 -0500
Received: from mail-qg0-f73.google.com ([209.85.192.73]:34166 "EHLO
	mail-qg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbaLKEPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 23:15:50 -0500
From: Ben Zhang <benzh@chromium.org>
To: Mark Brown <broonie@kernel.org>
Cc: alsa-devel@alsa-project.org, Liam Girdwood <lgirdwood@gmail.com>,
        Bard Liao <bardliao@realtek.com>, Oder Chiou <oder_chiou@realtek.com>,
        Anatol Pomozov <anatol@google.com>, Dylan Reid <dgreid@chromium.org>,
        Albert Chen <albertchen@realtek.com>, linux-kernel@vger.kernel.org,
        Ben Zhang <benzh@chromium.org>
Subject: [PATCH 1/3] ASoC: rt5677: add REGMAP_I2C and REGMAP_IRQ dependency
Date: Wed, 10 Dec 2014 20:15:25 -0800
Message-Id: <1418271327-14710-1-git-send-email-benzh@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The codec driver uses regmap to do i2c read/write.
The codec driver started to use REGMAP_IRQ since:

5e3363ad1b7b2e1f197a3f56b01e21cb155ad454
ASoC: rt5677: add GPIO IRQ support

Signed-off-by: Ben Zhang <benzh@chromium.org>
---
 sound/soc/codecs/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 6f21a76..60f9425 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -503,6 +503,8 @@ config SND_SOC_RT5670
 
 config SND_SOC_RT5677
 	tristate
+	select REGMAP_I2C
+	select REGMAP_IRQ
 
 config SND_SOC_RT5677_SPI
 	tristate
-- 
2.2.0.rc0.207.ga3a616c

