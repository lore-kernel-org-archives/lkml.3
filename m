Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbaLXJje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 04:39:34 -0500
Received: from regular1.263xmail.com ([211.150.99.135]:38429 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaLXJjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 04:39:14 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-ADDR-CHECKED: 0
X-RL-SENDER: jay.xu@rock-chips.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: jay.xu@rock-chips.com
X-UNIQUE-TAG: <3461901d13c7c3ed798583ae2bb342c0>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Jianqun Xu <jay.xu@rock-chips.com>
To: lgirdwood@gmail.com, heiko@sntech.de, broonie@kernel.org, perex@perex.cz,
        tiwai@suse.de, sonnyrao@chromium.org
Cc: linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org, Jianqun Xu <jay.xu@rock-chips.com>
Subject: [PATCH v2 1/3] ASoC: rockchip: i2s: fix error defination of transmit data level
Date: Wed, 24 Dec 2014 17:37:00 +0800
Message-Id: <1419413822-11539-2-git-send-email-jay.xu@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419413822-11539-1-git-send-email-jay.xu@rock-chips.com>
References: <1419325709-15374-1-git-send-email-jay.xu@rock-chips.com>
 <1419413822-11539-1-git-send-email-jay.xu@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to description about "Transmit Data Level",

This bit field controls the level at which a DMA request
is made by the transmit logic.

It is equal to the watermark level.

That is, the dma_tx_req signal is generated when the number
of valid data entries in the TXFIFO
(TXFIFO0 if CSR=00
 TXFIFO1 if CSR=01
 TXFIFO2 if CSR=10
 TXFIFO3 if CSR=11)
is equal to or below this field value.

Different to receive data level, transmit data level does not need
to "-1".

Signed-off-by: Jianqun Xu <jay.xu@rock-chips.com>
---
changes since v1:
- none

 sound/soc/rockchip/rockchip_i2s.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/rockchip/rockchip_i2s.h b/sound/soc/rockchip/rockchip_i2s.h
index 89a5d8b..93f456f 100644
--- a/sound/soc/rockchip/rockchip_i2s.h
+++ b/sound/soc/rockchip/rockchip_i2s.h
@@ -127,7 +127,7 @@
 #define I2S_DMACR_TDE_DISABLE	(0 << I2S_DMACR_TDE_SHIFT)
 #define I2S_DMACR_TDE_ENABLE	(1 << I2S_DMACR_TDE_SHIFT)
 #define I2S_DMACR_TDL_SHIFT	0
-#define I2S_DMACR_TDL(x)	((x - 1) << I2S_DMACR_TDL_SHIFT)
+#define I2S_DMACR_TDL(x)	((x) << I2S_DMACR_TDL_SHIFT)
 #define I2S_DMACR_TDL_MASK	(0x1f << I2S_DMACR_TDL_SHIFT)
 
 /*
-- 
1.9.1


