Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab3LTS6T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 13:58:19 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38024 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab3LTS6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 13:58:18 -0500
Message-ID: <52B49347.3090209@infradead.org>
Date: Fri, 20 Dec 2013 10:58:15 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        David Airlie <airlied@linux.ie>, alevy@redhat.com
Subject: [PATCH -next] gpu: fix qxl missing crc32_le
References: <20131220172503.b2b7cb92f437d974f032e1a4@canb.auug.org.au>
In-Reply-To: <20131220172503.b2b7cb92f437d974f032e1a4@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix build error: qxl uses crc32 functions so it needs to select
CRC32.

Also use angle quotes around a kernel header file name.

drivers/built-in.o: In function `qxl_display_read_client_monitors_config':
(.text+0x19d754): undefined reference to `crc32_le'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 drivers/gpu/drm/qxl/Kconfig       |    1 +
 drivers/gpu/drm/qxl/qxl_display.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- linux-next-20131220.orig/drivers/gpu/drm/qxl/qxl_display.c
+++ linux-next-20131220/drivers/gpu/drm/qxl/qxl_display.c
@@ -24,7 +24,7 @@
  */
 
 
-#include "linux/crc32.h"
+#include <linux/crc32.h>
 
 #include "qxl_drv.h"
 #include "qxl_object.h"
--- linux-next-20131220.orig/drivers/gpu/drm/qxl/Kconfig
+++ linux-next-20131220/drivers/gpu/drm/qxl/Kconfig
@@ -8,6 +8,7 @@ config DRM_QXL
 	select DRM_KMS_HELPER
 	select DRM_KMS_FB_HELPER
 	select DRM_TTM
+	select CRC32
 	help
 	  QXL virtual GPU for Spice virtualization desktop integration.
 	  Do not enable this driver unless your distro ships a corresponding
