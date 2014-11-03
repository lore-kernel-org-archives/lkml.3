Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbaKCOm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 09:42:27 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38830 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbaKCOmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 09:42:20 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Olof Johansson <olof@lixom.net>, Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v4 02/14] regulator: Add function to map modes to struct regulator_desc
Date: Mon,  3 Nov 2014 15:40:37 +0100
Message-Id: <1415025649-8119-3-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415025649-8119-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1415025649-8119-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulator-initial-mode and regulator-mode DT properties allows to
configure the regulator operating modes at startup or when a system
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
 include/linux/regulator/driver.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 28da08e..b54d037 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -243,6 +243,8 @@ enum regulator_type {
  *
  * @enable_time: Time taken for initial enable of regulator (in uS).
  * @off_on_delay: guard time (in uS), before re-enabling a regulator
+ *
+ * @map_modes: Callback invoked to translate between hardware to standard modes.
  */
 struct regulator_desc {
 	const char *name;
@@ -285,6 +287,8 @@ struct regulator_desc {
 	unsigned int enable_time;
 
 	unsigned int off_on_delay;
+
+	unsigned int (*map_modes)(unsigned int mode);
 };
 
 /**
-- 
2.1.0

