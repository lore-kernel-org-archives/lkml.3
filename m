Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbaJULcP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 07:32:15 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:34061 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040AbaJULcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 07:32:13 -0400
X-RL-SENDER: jay.xu@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: jay.xu@rock-chips.com
X-UNIQUE-TAG: <b7917f226db86becc66acd70c7335f92>
X-DNS-TYPE: 1
From: Jianqun <jay.xu@rock-chips.com>
To: heiko@sntech.de, lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz,
        tiwai@suse.de, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Cc: huangtao@rock-chips.com, cf@rock-chips.com,
        Jianqun <jay.xu@rock-chips.com>
Subject: [PATCH] ASoC: rockchip-i2s: add rockchip-max98090 driver support
Date: Tue, 21 Oct 2014 19:31:50 +0800
Message-Id: <1413891110-21059-1-git-send-email-jay.xu@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to add support for rockchip board with max98090 codec.
It also needs sound node in dt file.

Tested on rockchip board based on rk3288.

Signed-off-by: Jianqun <jay.xu@rock-chips.com>
---
 sound/soc/rockchip/Kconfig | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/sound/soc/rockchip/Kconfig b/sound/soc/rockchip/Kconfig
index 78fc159..482cbba 100644
--- a/sound/soc/rockchip/Kconfig
+++ b/sound/soc/rockchip/Kconfig
@@ -9,3 +9,16 @@ config SND_SOC_ROCKCHIP
 
 config SND_SOC_ROCKCHIP_I2S
 	tristate
+	depends on CLKDEV_LOOKUP && SND_SOC_ROCKCHIP
+	help
+	  Say Y or M if you want to add support for I2S driver for Rockchip
+	  I2S device.
+
+config SND_SOC_ROCKCHIP_MAX98090
+	tristate "ASoC support Rockchip board with max98090"
+	depends on I2C && GPIOLIB
+	select SND_SOC_ROCKCHIP_I2S
+	select SND_SOC_MAX98090
+	help
+	  Say Y or M here if you want to add support for Rockchio board using
+	  a max98090 codec.
-- 
1.9.1

