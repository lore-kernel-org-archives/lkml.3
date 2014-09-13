Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266AbaIMBRH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 21:17:07 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:52845 "EHLO
	vasmtpcom.263.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751685AbaIMBRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 21:17:05 -0400
X-RL-SENDER: jay.xu@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: jay.xu@rock-chips.com
X-UNIQUE-TAG: <0d2ad325bded2ec36936f159d2e8adf8>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Jianqun <jay.xu@rock-chips.com>
To: heiko@sntech.de, lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz,
        tiwai@suse.de, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Cc: huangtao@rock-chips.com, cf@rock-chips.com,
        Jianqun <jay.xu@rock-chips.com>
Subject: [PATCH 4/5] ASoC: rockchip-i2s: fix registers' property of rockchip i2s controller
Date: Sat, 13 Sep 2014 08:42:12 +0800
Message-Id: <1410568932-21823-1-git-send-email-jay.xu@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410568723-21559-1-git-send-email-jay.xu@rock-chips.com>
References: <1410568723-21559-1-git-send-email-jay.xu@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reference rockchip I2S controller TRM, modify some registers' property
I2S_FIFOLR: read / write, but not volatile, not precious
I2S_INTSR: read / write
I2S_CLR: volatile, register value will be cleared by read

Test on RK3288 with max98090.

Signed-off-by: Jianqun Xu <jay.xu@rock-chips.com>
---
 sound/soc/rockchip/rockchip_i2s.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/rockchip/rockchip_i2s.c b/sound/soc/rockchip/rockchip_i2s.c
index 1b9b404..6595383 100644
--- a/sound/soc/rockchip/rockchip_i2s.c
+++ b/sound/soc/rockchip/rockchip_i2s.c
@@ -365,6 +365,8 @@ static bool rockchip_i2s_rd_reg(struct device *dev, unsigned int reg)
 	case I2S_XFER:
 	case I2S_CLR:
 	case I2S_RXDR:
+	case I2S_FIFOLR:
+	case I2S_INTSR:
 		return true;
 	default:
 		return false;
@@ -374,8 +376,8 @@ static bool rockchip_i2s_rd_reg(struct device *dev, unsigned int reg)
 static bool rockchip_i2s_volatile_reg(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
-	case I2S_FIFOLR:
 	case I2S_INTSR:
+	case I2S_CLR:
 		return true;
 	default:
 		return false;
@@ -385,8 +387,6 @@ static bool rockchip_i2s_volatile_reg(struct device *dev, unsigned int reg)
 static bool rockchip_i2s_precious_reg(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
-	case I2S_FIFOLR:
-		return true;
 	default:
 		return false;
 	}
-- 
1.9.1

