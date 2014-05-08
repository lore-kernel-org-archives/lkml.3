Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbaEHMJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 08:09:38 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:58115 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbaEHMJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 08:09:37 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] drivers: Remove duplicate conditionally included subdirs
Date: Thu,  8 May 2014 14:09:32 +0200
Message-Id: <1399550972-28042-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "macintosh" and "nfs" subdirectories are already traversed
unconditionally, so there's no need to keep the conditional entries.

The unconditional "macintosh" entry used to depend on CONFIG_PPC_PMAC,
but the dependency was dropped in commit
45941d0481f538324fa21d6450116d13f6e51e91 ("[PATCH] enable mouse button 2+3
emulation for x86 macs"), forgetting the second entry for CONFIG_MAC.

The two "nfc" entries were introduced by two separate commits: commit
0329326e85aaa30fb8d427828c718d565c287385 ("NFC: Driver for NXP
Semiconductors PN544 NFC chip."), and commit
3e256b8f8dfa309a80b5dece388d85d9a9801a29 ("NFC: add nfc subsystem core").

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/Makefile |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/Makefile b/drivers/Makefile
index 7183b6af5dac..ea247d6ca12b 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -80,7 +80,6 @@ obj-$(CONFIG_PCCARD)		+= pcmcia/
 obj-$(CONFIG_DIO)		+= dio/
 obj-$(CONFIG_SBUS)		+= sbus/
 obj-$(CONFIG_ZORRO)		+= zorro/
-obj-$(CONFIG_MAC)		+= macintosh/
 obj-$(CONFIG_ATA_OVER_ETH)	+= block/aoe/
 obj-$(CONFIG_PARIDE) 		+= block/paride/
 obj-$(CONFIG_TC)		+= tc/
@@ -138,7 +137,6 @@ obj-y				+= clk/
 
 obj-$(CONFIG_MAILBOX)		+= mailbox/
 obj-$(CONFIG_HWSPINLOCK)	+= hwspinlock/
-obj-$(CONFIG_NFC)		+= nfc/
 obj-$(CONFIG_IOMMU_SUPPORT)	+= iommu/
 obj-$(CONFIG_REMOTEPROC)	+= remoteproc/
 obj-$(CONFIG_RPMSG)		+= rpmsg/
-- 
1.7.9.5

