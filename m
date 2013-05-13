Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab3EMX7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 19:59:54 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:33684 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571Ab3EMX7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 19:59:21 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, Jerome Glisse <j.glisse@gmail.com>,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v3 8/9] drm: Remove mtrr_add and mtrr_del fallback hack for non-MTRR systems
Date: Mon, 13 May 2013 16:58:47 -0700
Message-Id: <59d447ca22519276803d6b12b5ce125e8cb77c19.1368485053.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <cover.1368485053.git.luto@amacapital.net>
References: <cover.1368485053.git.luto@amacapital.net>
In-Reply-To: <cover.1368485053.git.luto@amacapital.net>
References: <cover.1368485053.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no users left in drivers/gpu.

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 include/drm/drmP.h         |  5 +----
 include/drm/drm_os_linux.h | 16 ----------------
 2 files changed, 1 insertion(+), 20 deletions(-)

diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index 3e6cfa0..7a9fef5 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -55,16 +55,13 @@
 #include <linux/mm.h>
 #include <linux/cdev.h>
 #include <linux/mutex.h>
+#include <linux/io.h>
 #include <linux/slab.h>
 #if defined(__alpha__) || defined(__powerpc__)
 #include <asm/pgtable.h>	/* For pte_wrprotect */
 #endif
-#include <asm/io.h>
 #include <asm/mman.h>
 #include <asm/uaccess.h>
-#ifdef CONFIG_MTRR
-#include <asm/mtrr.h>
-#endif
 #if defined(CONFIG_AGP) || defined(CONFIG_AGP_MODULE)
 #include <linux/types.h>
 #include <linux/agp_backend.h>
diff --git a/include/drm/drm_os_linux.h b/include/drm/drm_os_linux.h
index 3933691..35c7c2b 100644
--- a/include/drm/drm_os_linux.h
+++ b/include/drm/drm_os_linux.h
@@ -65,22 +65,6 @@ struct no_agp_kern {
 #define DRM_AGP_KERN            struct no_agp_kern
 #endif
 
-#if !(__OS_HAS_MTRR)
-static __inline__ int mtrr_add(unsigned long base, unsigned long size,
-			       unsigned int type, char increment)
-{
-	return -ENODEV;
-}
-
-static __inline__ int mtrr_del(int reg, unsigned long base, unsigned long size)
-{
-	return -ENODEV;
-}
-
-#define MTRR_TYPE_WRCOMB     1
-
-#endif
-
 /** Other copying of data to kernel space */
 #define DRM_COPY_FROM_USER(arg1, arg2, arg3)		\
 	copy_from_user(arg1, arg2, arg3)
-- 
1.8.1.4

