Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759198Ab3FMSfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:35:44 -0400
Received: from etezian.org ([198.101.225.253]:56450 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758886Ab3FMS26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:28:58 -0400
From: Andi Shyti <andi@etezian.org>
To: arnd@arndb.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, pc@asdf.org, oatilla@gmail.com,
        andi@etezian.org
Subject: [PATCH 15/19] bh1770glc: Modified scaler variable
Date: Thu, 13 Jun 2013 20:20:49 +0200
Message-Id: <b4178a04234f32dd4e0b37e86d812f0c5a051ee8.1371145891.git.andi@etezian.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1371145891.git.andi@etezian.org>
References: <cover.1371145891.git.andi@etezian.org>
In-Reply-To: <cover.1371145891.git.andi@etezian.org>
References: <cover.1371145891.git.andi@etezian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Onur Atilla <oatilla@gmail.com>

Changed all exposed scalers to 8192 (Q13) in order to
achieve consistency in the sysfs interface.

Signed-off-by: Onur Atilla <oatilla@gmail.com>
Signed-off-by: Andi Shyti <andi@etezian.org>
---
 drivers/misc/bh1770glc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/bh1770glc.c b/drivers/misc/bh1770glc.c
index 054d3f3..cb63c25 100644
--- a/drivers/misc/bh1770glc.c
+++ b/drivers/misc/bh1770glc.c
@@ -105,8 +105,6 @@
 #define BH1770_ENABLE		1
 #define BH1770_PROX_CHANNELS	1
 
-#define BH1770_LUX_GA_SCALE	16384
-#define BH1770_LUX_CF_SCALE	2048 /* CF ChipFactor */
 #define BH1770_LUX_DEFAULT_RATE		1 /* Index to lux rate table */
 #define BH1770_PROX_DEFAULT_RATE	1 /* Direct HW value =~ 50Hz */
 #define BH1770_PROX_DEF_RATE_THRESH	6 /* Direct HW value =~ 5 Hz */
@@ -122,6 +120,8 @@
 #define BH1770_PROX_DEF_THRES		100
 #define BH1770_DEFAULT_PERSISTENCE	10
 #define BH1770_PROX_MAX_PERSISTENCE	50
+#define BH1770_LUX_GA_SCALE		8192
+#define BH1770_LUX_CF_SCALE		8192 /* CF ChipFactor */
 #define BH1770_NEUTRAL_CF		BH1770_LUX_CF_SCALE
 #define BH1770_LUX_CORR_SCALE		4096
 
-- 
1.7.10.4

