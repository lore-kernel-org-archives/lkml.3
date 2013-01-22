Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab3AVVqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 16:46:15 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:49546 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab3AVVqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 16:46:14 -0500
From: Rob Clark <robdclark@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: patches@linaro.org, linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Tony Lindgren <tony@atomide.com>, Greg KH <greg@kroah.com>,
        Rob Clark <robdclark@gmail.com>
Subject: [PATCH] OMAPDSS: enable omapdss for ARCH_MULTIPLATFORM
Date: Tue, 22 Jan 2013 15:46:00 -0600
Message-Id: <1358891160-9534-1-git-send-email-robdclark@gmail.com>
X-Mailer: git-send-email 1.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At least core omapdss does not have any build dependencies on
ARCH_OMAP2PLUS, and adding this dependency in the Kconfig breaks omapdrm
for ARCH_MULTIPLATFORM builds.

Signed-off-by: Rob Clark <robdclark@gmail.com>
---
 drivers/video/omap2/Kconfig | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/video/omap2/Kconfig b/drivers/video/omap2/Kconfig
index b07b2b0..011e549 100644
--- a/drivers/video/omap2/Kconfig
+++ b/drivers/video/omap2/Kconfig
@@ -1,9 +1,14 @@
 config OMAP2_VRFB
 	bool
 
-if ARCH_OMAP2PLUS
+if ARCH_OMAP2PLUS || ARCH_MULTIPLATFORM
 
 source "drivers/video/omap2/dss/Kconfig"
+
+endif
+
+if ARCH_OMAP2PLUS
+
 source "drivers/video/omap2/omapfb/Kconfig"
 source "drivers/video/omap2/displays/Kconfig"
 
-- 
1.8.1

