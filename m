Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbaKJNoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 08:44:12 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:48074 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbaKJNoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 08:44:10 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Olof Johansson <olof@lixom.net>, Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v6 2/5] regulator: Add mode mapping function to struct regulator_desc
Date: Mon, 10 Nov 2014 14:43:52 +0100
Message-Id: <1415627035-3088-3-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415627035-3088-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1415627035-3088-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "regulator-initial-mode" and "regulator-mode" DT properties allows
to configure the regulator operating modes at startup or when a system
enters into a susend state.

But these properties use as valid values the operating modes supported
by each device while the core deals with the standard operating modes.
So a mapping function is needed to translate from the hardware specific
modes to the standard ones.

This mapping is a non-varying configuration for each regulator, so add
a function pointer to struct regulator_desc that will allow drivers to
define their callback to do the modes translation.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---

Changes in v6:
 - Rename function from .map_modes to .of_map_mode. Suggested by Mark Brown.
 - Remove obvious explanation from the function doc. Suggested by Mark Brown.

Changes in v5:
 - Add a better explanation of what mode is passed as an argument and what
   mode is returned. Suggested by Krzysztof Kozlowski.
 - Explain that this callback is needed to be able to parse the regulator
   initial and suspend state modes. Suggested by Krzysztof Kozlowski.

 include/linux/regulator/driver.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 28da08e..5f1e9ca 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -243,6 +243,8 @@ enum regulator_type {
  *
  * @enable_time: Time taken for initial enable of regulator (in uS).
  * @off_on_delay: guard time (in uS), before re-enabling a regulator
+ *
+ * @of_map_mode: Maps a hardware mode defined in a DeviceTree to a standard mode
  */
 struct regulator_desc {
 	const char *name;
@@ -285,6 +287,8 @@ struct regulator_desc {
 	unsigned int enable_time;
 
 	unsigned int off_on_delay;
+
+	unsigned int (*of_map_mode)(unsigned int mode);
 };
 
 /**
-- 
2.1.0

