Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932981Ab3DYRdi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 13:33:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61211 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932668Ab3DYR3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 13:29:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 09/21] drm: export drm_vm_open_locked
Date: Thu, 25 Apr 2013 19:28:52 +0200
Message-Id: <1366910944-3033663-10-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:pCssDLMZdOy+Gasw6F2FZO9rR0uFXBcUBfFZdelr0rn
 aUt2EzNZMSY0bkQmECHNMjtMnk+iTx9IgDofketucu5lhg/7Y+
 9ogjduUUZTSfOiatubeR56jwGhNJBCTTIjDVdTh48rbdWd7SLn
 lVpXb5h0X3DziRDrv/1F1sMb8WZZHjFG1w9KUwda+i5RNTBxpz
 3xgNWHxa1ohqdEqRApeDYQyV/xDQ9mwlffM+HGkX+AUXQ/jY1H
 I4MaaHd1zL99lYl+AIdYHVaeiPf32p/qieAJVf7FR3/eg6grHI
 pVQJ9OeQ13LyHHjvFPaPkx/4eBTyotfBx7u2ZaGBzwWERs1jv4
 tz8aIajScdWSStZIDmn8s9t4Sy6epSRtnmFzh1dYW
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EXYNOS DRM driver uses drm_vm_open_locked in its mmap() function,
and it can be built as a loadable module, which currently fails.
This exports the symbol from the DRM core to avoid

ERROR: "drm_vm_open_locked" [drivers/gpu/drm/exynos/exynosdrm.ko] undefined!

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
Cc: Inki Dae <inki.dae@samsung.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: Seung-Woo Kim <sw0312.kim@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
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

