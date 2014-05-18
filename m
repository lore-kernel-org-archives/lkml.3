Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591AbaERNtg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 09:49:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbaERNte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 09:49:34 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Mark Brown <broonie@linaro.org>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Cc: Carlo Caione <carlo@caione.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-sunxi@googlegroups.com, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 3/3] arizona-mfd-codecs: Add mfd_register_supply_aliases() calls
Date: Sun, 18 May 2014 15:49:13 +0200
Message-Id: <1400420953-20705-4-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1400420953-20705-1-git-send-email-hdegoede@redhat.com>
References: <1400420953-20705-1-git-send-email-hdegoede@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mfd-core no longer registers the supply aliases, instead the platform
driver probe method must now call mfd_register_supply_aliases().

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 sound/soc/codecs/wm5102.c | 5 +++++
 sound/soc/codecs/wm5110.c | 5 +++++
 sound/soc/codecs/wm8997.c | 7 ++++++-
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm5102.c b/sound/soc/codecs/wm5102.c
index dcf1d12..fab08cc 100644
--- a/sound/soc/codecs/wm5102.c
+++ b/sound/soc/codecs/wm5102.c
@@ -26,6 +26,7 @@
 #include <sound/initval.h>
 #include <sound/tlv.h>
 
+#include <linux/mfd/core.h>
 #include <linux/mfd/arizona/core.h>
 #include <linux/mfd/arizona/registers.h>
 
@@ -1825,6 +1826,10 @@ static int wm5102_probe(struct platform_device *pdev)
 	struct wm5102_priv *wm5102;
 	int i, ret;
 
+	ret = mfd_register_supply_aliases(pdev);
+	if (ret)
+		return ret;
+
 	wm5102 = devm_kzalloc(&pdev->dev, sizeof(struct wm5102_priv),
 			      GFP_KERNEL);
 	if (wm5102 == NULL)
diff --git a/sound/soc/codecs/wm5110.c b/sound/soc/codecs/wm5110.c
index df5a38d..a1a6923 100644
--- a/sound/soc/codecs/wm5110.c
+++ b/sound/soc/codecs/wm5110.c
@@ -26,6 +26,7 @@
 #include <sound/initval.h>
 #include <sound/tlv.h>
 
+#include <linux/mfd/core.h>
 #include <linux/mfd/arizona/core.h>
 #include <linux/mfd/arizona/registers.h>
 
@@ -1656,6 +1657,10 @@ static int wm5110_probe(struct platform_device *pdev)
 	struct wm5110_priv *wm5110;
 	int i, ret;
 
+	ret = mfd_register_supply_aliases(pdev);
+	if (ret)
+		return ret;
+
 	wm5110 = devm_kzalloc(&pdev->dev, sizeof(struct wm5110_priv),
 			      GFP_KERNEL);
 	if (wm5110 == NULL)
diff --git a/sound/soc/codecs/wm8997.c b/sound/soc/codecs/wm8997.c
index 004186b..099b148 100644
--- a/sound/soc/codecs/wm8997.c
+++ b/sound/soc/codecs/wm8997.c
@@ -26,6 +26,7 @@
 #include <sound/initval.h>
 #include <sound/tlv.h>
 
+#include <linux/mfd/core.h>
 #include <linux/mfd/arizona/core.h>
 #include <linux/mfd/arizona/registers.h>
 
@@ -1107,7 +1108,11 @@ static int wm8997_probe(struct platform_device *pdev)
 {
 	struct arizona *arizona = dev_get_drvdata(pdev->dev.parent);
 	struct wm8997_priv *wm8997;
-	int i;
+	int i, ret;
+
+	ret = mfd_register_supply_aliases(pdev);
+	if (ret)
+		return ret;
 
 	wm8997 = devm_kzalloc(&pdev->dev, sizeof(struct wm8997_priv),
 			      GFP_KERNEL);
-- 
1.9.0

