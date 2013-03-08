Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933304Ab3CHKt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 05:49:26 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:50829 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab3CHKtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 05:49:25 -0500
From: Prabhakar lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Sekhar Nori <nsekhar@ti.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v2] davinci: vpif: Fix module build for capture and display
Date: Fri,  8 Mar 2013 16:19:07 +0530
Message-Id: <1362739747-4166-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

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
Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 Changes for v2:
 1: use EXPORT_SYMBOL_GPL instead of EXPORT_SYMBOL() as pointed by
    Sekhar.

 drivers/media/platform/davinci/vpif.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
index 28638a8..42c7eba 100644
--- a/drivers/media/platform/davinci/vpif.c
+++ b/drivers/media/platform/davinci/vpif.c
@@ -44,6 +44,8 @@ static struct resource	*res;
 spinlock_t vpif_lock;
 
 void __iomem *vpif_base;
+EXPORT_SYMBOL_GPL(vpif_base);
+
 struct clk *vpif_clk;
 
 /**
@@ -220,8 +222,10 @@ const struct vpif_channel_config_params ch_params[] = {
 		.stdid = V4L2_STD_625_50,
 	},
 };
+EXPORT_SYMBOL_GPL(ch_params);
 
 const unsigned int vpif_ch_params_count = ARRAY_SIZE(ch_params);
+EXPORT_SYMBOL_GPL(vpif_ch_params_count);
 
 static inline void vpif_wr_bit(u32 reg, u32 bit, u32 val)
 {
-- 
1.7.4.1

