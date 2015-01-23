Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbbAWQKV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:10:21 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:52822 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbbAWQKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:10:09 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 1/2] of: Allow selection of OF_DYNAMIC and OF_OVERLAY if OF_UNITTEST
Date: Fri, 23 Jan 2015 17:10:04 +0100
Message-Id: <1422029405-9353-2-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422029405-9353-1-git-send-email-geert+renesas@glider.be>
References: <1422029405-9353-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently OF_DYNAMIC and OF_OVERLAY are not visible to the user, and are
selected automatically only when needed.

Allow them to be enabled manually to improve device tree unit test
coverage.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/of/Kconfig | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index 38d1c51f58b108db..e9301686493933cc 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -34,7 +34,11 @@ config OF_PROMTREE
 # Hardly any platforms need this.  It is safe to select, but only do so if you
 # need it.
 config OF_DYNAMIC
-	bool
+	bool "Support for dynamic device trees" if OF_UNITTEST
+	help
+	  On some platforms, the device tree can be manipulated at runtime.
+	  While this option is selected automatically on such platforms, you
+	  can enable it manually to improve device tree unit test coverage.
 
 config OF_ADDRESS
 	def_bool y
@@ -84,9 +88,14 @@ config OF_RESOLVE
 	bool
 
 config OF_OVERLAY
-	bool
+	bool "Support for device tree overlays" if OF_UNITTEST
 	depends on OF
 	select OF_DYNAMIC
 	select OF_RESOLVE
+	help
+	  Overlays are a method to dynamically modify part of the kernel's
+	  device tree with dynamically loaded data.
+	  While this option is selected automatically when needed, you can
+	  enable it manually to improve device tree unit test coverage.
 
 endmenu # OF
-- 
1.9.1

