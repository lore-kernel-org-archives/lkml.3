Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161131Ab3BNWsH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 17:48:07 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:56316 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161085Ab3BNWsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 17:48:01 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Dave Airlie <airlied@redhat.com>,
        Shirish S <s.shirish@samsung.com>, Inki Dae <inki.dae@samsung.com>,
        Rob Clark <rob@ti.com>
Subject: [PATCH 5/9] drm: export drm_vm_open_locked
Date: Thu, 14 Feb 2013 23:47:47 +0100
Message-Id: <1360882071-4072668-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360882071-4072668-1-git-send-email-arnd@arndb.de>
References: <1360882071-4072668-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:h4Gu2Pb96WeCObVd2Bbg2TQZwQJPz0xwjI89oqWDoj+
 Mj1lbiztwo6NUbXvZNWm6lrw+d0wuqOYQ+U+gylU2r8yM6bXYJ
 YtOB1SwF3YiYr9G5fXMDK581UiuyrNJry4t9hp3YGUGph8HPns
 KM7/lsi5OzQgkQwEPfXfnbDdlwhKn/YeCHTyf3Vp3ri8Ue/+dc
 wm1LhsS3GV7GO/chPWR+1pn5ePfQ1bIlwwhrh+IcJEYW9xMKKR
 q9+sDy9nmxq7Klo4U9RYH9CAmRho/t6Ufz5Ryc8a/+DsdfYKTz
 p4ESd5arybafg2J1SN/Z2JCFR2+Yl3nSFpwSg2zShUtXQJ4jTd
 aozBqlOQ0Hf3uvSO2uHFuC5mNanCKXqbF38nnoB14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the exynos DRM driver can now be built as a module on
all multiplatform configurations, an existing bug has
become visible: The exynos driver uses the drm_vm_open_locked
function that is not exported. The obvious solution is to
export that symbol.

Without this patch, building ARM allmodconfig results in:

ERROR: "drm_vm_open_locked" [drivers/gpu/drm/exynos/exynosdrm.ko] undefined!

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Shirish S <s.shirish@samsung.com>
Cc: Inki Dae <inki.dae@samsung.com>
Cc: Rob Clark <rob@ti.com>
---
 drivers/gpu/drm/drm_vm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/drm_vm.c b/drivers/gpu/drm/drm_vm.c
index db7bd29..1d4f7c9 100644
--- a/drivers/gpu/drm/drm_vm.c
+++ b/drivers/gpu/drm/drm_vm.c
@@ -422,6 +422,7 @@ void drm_vm_open_locked(struct drm_device *dev,
 		list_add(&vma_entry->head, &dev->vmalist);
 	}
 }
+EXPORT_SYMBOL_GPL(drm_vm_open_locked);
 
 static void drm_vm_open(struct vm_area_struct *vma)
 {
-- 
1.8.1.2

