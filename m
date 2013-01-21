Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435Ab3AURWE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 12:22:04 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:65274 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833Ab3AURRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 12:17:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Rob Clark <rob@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 15/15] staging/omapdrm: don't build on multiplatform
Date: Mon, 21 Jan 2013 17:16:08 +0000
Message-Id: <1358788568-11137-16-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358788568-11137-1-git-send-email-arnd@arndb.de>
References: <1358788568-11137-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:UFu4rqDPO2bN/gDwE8luIptPtN14ce0GkIZDtbMLyTh
 Mlg26pgmKfREP6pVI5KUsGrYMg3WPebTYB+KNI3l+8TIFzTKXu
 cu8qElBfxnmcbNMJnTaa62aunUrzZ4ryOmeYGFhCpdpCboTyOB
 uKVQYpmQnZsgco+Lq2v+qxKLEx7L/o/Hhj6muHvOHztIf4CMfG
 VNc3y+Iz/LmQi7s09vTVPQItivmDRETygaEhHiMK0vwghLLayc
 53UIsALmyZsLrDeTwpTvKcSDD86v8vHd2LGwfROiHy1kUSylhb
 pX4lYnj8WROajB4cx67KM3rRu1gqd3A88sAKGmT0XJcKKCoQqA
 z9vPthep7wNR4kcrtcsTD2uUm8/6kLfZ2rZmiRfBY
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The omapdrm driver is incorrectly flagged to allow building
on non-omap platforms, when ARCH_MULTIPLATFORM is set.

This does not work, because it unconditionally selects
the OMAP2_DSS symbol that only works on OMAP.
The problem was introduced in 5e3b087499 "staging:
drm/omap: add support for ARCH_MULTIPLATFORM", which this
patch partly reverts.

Without this patch, building allyesconfig results in:

warning: (VIDEO_OMAP2_VOUT && DRM_OMAP) selects OMAP2_DSS which has unmet direct dependencies (HAS_IOMEM && ARCH_OMAP2PLUS)
warning: (VIDEO_OMAP2_VOUT && DRM_OMAP) selects OMAP2_DSS which has unmet direct dependencies (HAS_IOMEM && ARCH_OMAP2PLUS)
drivers/video/omap2/dss/dss.c: In function 'dss_calc_clock_div':
drivers/video/omap2/dss/dss.c:572:20: error: 'CONFIG_OMAP2_DSS_MIN_FCK_PER_PCK' undeclared (first use in this function)
drivers/video/omap2/dss/dss.c:572:20: note: each undeclared identifier is reported only once for each function it appears in
drivers/staging/omapdrm/omap_connector.c: In function 'omap_connector_dpms':
drivers/staging/omapdrm/omap_connector.c:116:8: error: 'OMAP_DSS_DISPLAY_SUSPENDED' undeclared (first use in this function)
drivers/staging/omapdrm/omap_connector.c:116:8: note: each undeclared identifier is reported only once for each function it appears in

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Rob Clark <rob@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/omapdrm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/omapdrm/Kconfig b/drivers/staging/omapdrm/Kconfig
index b724a41..81a7cba 100644
--- a/drivers/staging/omapdrm/Kconfig
+++ b/drivers/staging/omapdrm/Kconfig
@@ -2,7 +2,7 @@
 config DRM_OMAP
 	tristate "OMAP DRM"
 	depends on DRM && !CONFIG_FB_OMAP2
-	depends on ARCH_OMAP2PLUS || ARCH_MULTIPLATFORM
+	depends on ARCH_OMAP2PLUS
 	select DRM_KMS_HELPER
 	select OMAP2_DSS
 	select FB_SYS_FILLRECT
-- 
1.7.10.4

