Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932988AbbA2BwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:52:07 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:52205 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464AbbA2BwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:52:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/7] [media] timberdale: do not select TIMB_DMA
Date: Wed, 28 Jan 2015 22:17:41 +0100
Message-Id: <1422479867-3370921-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 2.1.0.rc2
In-Reply-To: <1422479867-3370921-1-git-send-email-arnd@arndb.de>
References: <1422479867-3370921-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V03:K0:I7im+ZZ4nZo7T5EbfkU8X6pAq9PJ5BQPGkzMOfgR2T5rUhPhTI3
 8rLKZQaG7BkO55NEMkovL+Po0HWFhEPAA6XiA3aN9J/dUnICFI9ok7yx/BwvjRWiHEFStW2
 NeY334lLvcOG4ckLwiGfxFgewJX9+RRXc5g0yEO9RC+FMjJva+t83DWPJiXM3mNm5OGP9rc
 fhoFa5ZtHYYLKGsGkPFXA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The timberdale media driver requires the use of the respective
dma engine driver, but that may not be enabled, causing a
Kconfig warning:

warning: (VIDEO_TIMBERDALE) selects TIMB_DMA which has unmet direct dependencies (DMADEVICES && MFD_TIMBERDALE)

This fixes the dependency by removing the inappropriate 'select'
statement and replacing it with a direct dependency on the
drivers that provide the services this needs.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 7155043c2d027 ("[media] enable COMPILE_TEST for media drivers")
---
 drivers/media/platform/Kconfig | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 765bffb49a72..6a1334be7544 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -56,10 +56,8 @@ config VIDEO_VIU
 
 config VIDEO_TIMBERDALE
 	tristate "Support for timberdale Video In/LogiWIN"
-	depends on VIDEO_V4L2 && I2C && DMADEVICES
-	depends on MFD_TIMBERDALE || COMPILE_TEST
-	select DMA_ENGINE
-	select TIMB_DMA
+	depends on VIDEO_V4L2 && I2C
+	depends on (MFD_TIMBERDALE && TIMB_DMA) || COMPILE_TEST
 	select VIDEO_ADV7180
 	select VIDEOBUF_DMA_CONTIG
 	---help---
-- 
2.1.0.rc2

