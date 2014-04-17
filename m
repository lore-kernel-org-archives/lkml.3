Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161117AbaDQJzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 05:55:19 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54906 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751209AbaDQJzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 05:55:08 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: perex@perex.cz, iwai@suse.de
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 2/6] sound: lx_core: Switch to using BIT macro
Date: Thu, 17 Apr 2014 11:51:17 +0200
Message-Id: <1397728281-26050-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397728281-26050-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1397728281-26050-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move to using the BIT macro for a few defines. It also allows to discard the
french comment that was saying exactly what the BIT macro is now pointing out.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 sound/pci/lx6464es/lx_core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/sound/pci/lx6464es/lx_core.c b/sound/pci/lx6464es/lx_core.c
index 6a1d90a308ea..652f6dfc7e1a 100644
--- a/sound/pci/lx6464es/lx_core.c
+++ b/sound/pci/lx6464es/lx_core.c
@@ -24,6 +24,7 @@
 
 /* #define RMH_DEBUG 1 */
 
+#include <linux/bitops.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
@@ -966,9 +967,9 @@ int lx_level_peaks(struct lx6464es *chip, int is_capture, int channels,
 
 /* interrupt handling */
 #define PCX_IRQ_NONE 0
-#define IRQCS_ACTIVE_PCIDB  0x00002000L         /* Bit nÃÂ¸ 13 */
-#define IRQCS_ENABLE_PCIIRQ 0x00000100L         /* Bit nÃÂ¸ 08 */
-#define IRQCS_ENABLE_PCIDB  0x00000200L         /* Bit nÃÂ¸ 09 */
+#define IRQCS_ACTIVE_PCIDB	BIT(13)
+#define IRQCS_ENABLE_PCIIRQ	BIT(8)
+#define IRQCS_ENABLE_PCIDB	BIT(9)
 
 static u32 lx_interrupt_test_ack(struct lx6464es *chip)
 {
-- 
1.9.1

