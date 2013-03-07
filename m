Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab3CGHOd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 02:14:33 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:55425 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab3CGHOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 02:14:30 -0500
From: Prabhakar lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Sekhar Nori <nsekhar@ti.com>, "Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: [PATCH] davinci: vpif: Fix module build for capture and display
Date: Thu,  7 Mar 2013 12:44:21 +0530
Message-Id: <1362640461-29106-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.lad@ti.com>

export the symbols which are used by two modules vpif_capture and
vpif_display.

This patch fixes following error:
ERROR: "ch_params" [drivers/media/platform/davinci/vpif_display.ko] undefined!
ERROR: "vpif_ch_params_count" [drivers/media/platform/davinci/vpif_display.ko] undefined!
ERROR: "vpif_base" [drivers/media/platform/davinci/vpif_display.ko] undefined!
ERROR: "ch_params" [drivers/media/platform/davinci/vpif_capture.ko] undefined!
ERROR: "vpif_ch_params_count" [drivers/media/platform/davinci/vpif_capture.ko] undefined!
ERROR: "vpif_base" [drivers/media/platform/davinci/vpif_capture.ko] undefined!
make[1]: *** [__modpost] Error 1

Reported-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
---
 drivers/media/platform/davinci/vpif.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
index 28638a8..8fbb4a2 100644
--- a/drivers/media/platform/davinci/vpif.c
+++ b/drivers/media/platform/davinci/vpif.c
@@ -44,6 +44,8 @@ static struct resource	*res;
 spinlock_t vpif_lock;
 
 void __iomem *vpif_base;
+EXPORT_SYMBOL(vpif_base);
+
 struct clk *vpif_clk;
 
 /**
@@ -220,8 +222,10 @@ const struct vpif_channel_config_params ch_params[] = {
 		.stdid = V4L2_STD_625_50,
 	},
 };
+EXPORT_SYMBOL(ch_params);
 
 const unsigned int vpif_ch_params_count = ARRAY_SIZE(ch_params);
+EXPORT_SYMBOL(vpif_ch_params_count);
 
 static inline void vpif_wr_bit(u32 reg, u32 bit, u32 val)
 {
-- 
1.7.4.1

