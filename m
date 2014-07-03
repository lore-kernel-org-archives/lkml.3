Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750900AbaGCEZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 00:25:40 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:41085 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaGCEZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 00:25:38 -0400
From: Konstantinos Tsimpoukas <kostaslinuxxx@gmail.com>
To: Konstantinos Tsimpoukas <kostaslinuxxx@gmail.com>,
        <alsa-devel@alsa-project.org>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        <linux-sound@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] ice1712: Correcting/completing #defines for REGS
Date: Wed,  2 Jul 2014 23:25:27 -0500
Message-Id: <1404361527-14068-1-git-send-email-kostaslinuxxx@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small patch completes #defines for Control/Status Register,
adds comments for the missing ones there and on the Interrupt Mask
Register and additionally corrects "#define ICE1712_SERR_LEVEL 0x04 -> 0x08",
according to documentation.

Signed-off-by: Konstantinos Tsimpoukas <kostaslinuxxx@gmail.com>
---
 sound/pci/ice1712/ice1712.h | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/sound/pci/ice1712/ice1712.h b/sound/pci/ice1712/ice1712.h
index b209fc3..58f8f2a 100644
--- a/sound/pci/ice1712/ice1712.h
+++ b/sound/pci/ice1712/ice1712.h
@@ -41,14 +41,17 @@
 #define ICEREG(ice, x) ((ice)->port + ICE1712_REG_##x)
 
 #define ICE1712_REG_CONTROL		0x00	/* byte */
-#define   ICE1712_RESET			0x80	/* reset whole chip */
-#define   ICE1712_SERR_LEVEL		0x04	/* SERR# level otherwise edge */
+#define   ICE1712_RESET			0x80	/* soft reset whole chip */
+#define   ICE1712_SERR_ASSERT_DS_DMA	0x40    /* disabled SERR# assertion for the DS DMA Ch-C irq otherwise enabled */
+#define   ICE1712_DOS_VOL		0x10    /* DOS WT/FM volume control */
+#define   ICE1712_SERR_LEVEL		0x08	/* SERR# level otherwise edge */
+#define   ICE1712_SERR_ASSERT_SB	0x02	/* disabled SERR# assertion for SB irq otherwise enabled */
 #define   ICE1712_NATIVE		0x01	/* native mode otherwise SB */
 #define ICE1712_REG_IRQMASK		0x01	/* byte */
-#define   ICE1712_IRQ_MPU1		0x80
-#define   ICE1712_IRQ_TIMER		0x40
-#define   ICE1712_IRQ_MPU2		0x20
-#define   ICE1712_IRQ_PROPCM		0x10
+#define   ICE1712_IRQ_MPU1		0x80	/* MIDI irq mask */
+#define   ICE1712_IRQ_TIMER		0x40	/* Timer mask */
+#define   ICE1712_IRQ_MPU2		0x20	/* Secondary MIDI irq mask */
+#define   ICE1712_IRQ_PROPCM		0x10	/* professional multi-track */
 #define   ICE1712_IRQ_FM		0x08	/* FM/MIDI - legacy */
 #define   ICE1712_IRQ_PBKDS		0x04	/* playback DS channels */
 #define   ICE1712_IRQ_CONCAP		0x02	/* consumer capture */
-- 
1.9.1

