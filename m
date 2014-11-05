Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbaKEDTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 22:19:17 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:40092 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109AbaKEDTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 22:19:13 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v2 06/13] backports: update dependencies map file
Date: Tue,  4 Nov 2014 19:18:30 -0800
Message-Id: <1415157517-15442-7-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415157517-15442-1-git-send-email-mcgrof@do-not-panic.com>
References: <1415157517-15442-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

During development of kernel integration support using CONFIG_BACKPORT
was evaluated as a prefix over CPTCFG even for packaging backports,
for some reason this change lifted some restrictions one some device
drivers which was present before and as such requires some changes to
the dependencies map file to ensure correct compilation for respective
kernel versions.

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 dependencies | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/dependencies b/dependencies
index 4964aa6..64903dc 100644
--- a/dependencies
+++ b/dependencies
@@ -16,6 +16,8 @@ USB_GSPCA_OV534 3.5
 # we only support on >= 3.4 give that reguatory itself depends
 # on -EPROBE_DEFER.
 SOC_CAMERA 3.4
+VIDEO_S5K5BAF 3.4
+VIDEO_S5K4ECGX 3.4
 # 49920bc6 and 1003cab8 and while it seems there is a
 # one to one map DMA_FROM_DEVICE to DMA_DEV_TO_MEM
 # I can't verify this fully yet.
@@ -29,16 +31,29 @@ DVB_USB_RTL28XXU 3.4
 # missing linux/gpio/consumer.h
 VIDEO_ADV7604 3.13
 # missing function clk_prepare_enable(), clk_disable_unprepare() and devm_regulator_bulk_get()
-VIDEO_MT9P031 3.3
-VIDEO_MT9T001 3.3
 VIDEO_MT9V032 3.3
-VIDEO_NOON010PC30 3.3
-VIDEO_S5K6A3 3.3
 VIDEO_S5K6AA 3.3
-VIDEO_S5K5BAF 3.3
-VIDEO_S5K4ECGX 3.3
-VIDEO_M5MOLS 3.3
-VIDEO_S5C73M3 3.3
+
+# missing devm_regulator_bulk_get
+VIDEO_MT9T001 3.5
+VIDEO_NOON010PC30 3.5
+VIDEO_MT9P031 3.5
+
+# missing of_property_read_bool() added via fa4d34cc on v3.4-rc1~71, backport
+# that attomically and you can enable this for older kernels.
+VIDEO_ADV7343 3.4
+
+# for whoever wants to backport this: GPIOF_EXPORT was redefined via commit
+# 79a9becd on v3.13-rc1~120^2~15, before this it was redefined via commit
+# f567fde2 on v3.5-rc7~32^2~4 and finally added via commit fc3a1f04 on
+# v3.5-rc1~93^2~25. We don't address any of these changes yet so we require
+# the latest interpretation.
+VIDEO_S5K6AA 3.13
+VIDEO_S5K6A3 3.13
+
+# missing linux/sizes.h
+VIDEO_M5MOLS 3.6
+VIDEO_S5C73M3 3.6
 
 # missing function devm_regmap_init_i2c()
 VIDEO_LM3646 3.3
-- 
2.1.1

