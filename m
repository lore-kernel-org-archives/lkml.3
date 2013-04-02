Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759855Ab3DBCCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 22:02:17 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:58909 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758738Ab3DBCCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 22:02:15 -0400
Date: Tue, 2 Apr 2013 10:01:37 +0800
From: Wang YanQing <udknight@gmail.com>
To: airlied@linux.ie
Cc: lars@metafoo.de, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH]gpu:drm: Add missing dependency on DRM KMS/FB CMA helper
Message-ID: <20130402020137.GA32592@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>, airlied@linux.ie,
	lars@metafoo.de, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 2e3b3c42f06ff6801b3d7839757bbdb231619083
(Add DRM KMS/FB CMA helper) add a kbuild entry,
config DRM_KMS_CMA_HELPER, in DRM's Kconfig without
dependence on DRM, it cause DRM's kconfig can't
be show in a submenu.

This patch fix it.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 drivers/gpu/drm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 1e82882..28e3cb4 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -63,6 +63,7 @@ config DRM_GEM_CMA_HELPER
 
 config DRM_KMS_CMA_HELPER
 	bool
+	depends on DRM
 	select DRM_GEM_CMA_HELPER
 	select FB_SYS_FILLRECT
 	select FB_SYS_COPYAREA
-- 
1.7.12.4.dirty
