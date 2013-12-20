Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab3LTIb1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 03:31:27 -0500
Received: from mga09.intel.com ([134.134.136.24]:24983 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755187Ab3LTIbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 03:31:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,519,1384329600"; 
   d="scan'208";a="427700612"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [UPDATE RFC PATCH 15/15] ACPI/thinkpad: Fix wrong <acpi/acpi.h> inclusion in Thinkpad ACPI users.
Date: Fri, 20 Dec 2013 16:30:42 +0800
Message-Id: <b6ef94e61a18b87939cf9495a1c9212c1b7f5465.1387528106.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1387336613.git.lv.zheng@intel.com>
References: <cover.1387336613.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_ACPI dependent code should include <linux/acpi.h> instead of
directly including <acpi/acpi.h>.  This patch cleans up such wrong
inclusions for Thinkpad ACPI users.

Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org
Cc: ibm-acpi-devel@lists.sourceforge.net
Cc: platform-driver-x86@vger.kernel.org
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 sound/pci/hda/patch_conexant.c |    2 +-
 sound/pci/hda/patch_realtek.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 3fbf288..6df4c35 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -3243,7 +3243,7 @@ enum {
 #if IS_ENABLED(CONFIG_THINKPAD_ACPI)
 
 #include <linux/thinkpad_acpi.h>
-#include <acpi/acpi.h>
+#include <linux/acpi.h>
 
 static int (*led_set_func)(int, bool);
 
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 34de5dc..5dca90e 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3726,7 +3726,7 @@ static void alc290_fixup_mono_speakers(struct hda_codec *codec,
 #if IS_ENABLED(CONFIG_THINKPAD_ACPI)
 
 #include <linux/thinkpad_acpi.h>
-#include <acpi/acpi.h>
+#include <linux/acpi.h>
 
 static int (*led_set_func)(int, bool);
 
-- 
1.7.10

