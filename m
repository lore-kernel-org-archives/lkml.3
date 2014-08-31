Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbaHaXIJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 19:08:09 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:54966 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbaHaXIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 19:08:06 -0400
From: Max Filippov <jcmvbkbc@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, David Airlie <airlied@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH] drm/vmwgfx: select FB when DRM_VMWGFX is selected
Date: Mon,  1 Sep 2014 03:07:47 +0400
Message-Id: <1409526467-20944-1-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise, if FB is not selected build fails at linking step:
  vmwgfx_fb.c:(.text+0x4098b): undefined reference to `register_framebuffer'
  vmwgfx_fb.c:(.text+0x409c0): undefined reference to `framebuffer_release'
  vmwgfx_fb.c:(.text+0x409f4): undefined reference to `unregister_framebuffer'
  vmwgfx_fb.c:(.text+0x40a0e): undefined reference to `framebuffer_release'

Patch ae6445ac7475ff05 drm/vmwgfx: depends on FB
added dependency on FB that was subsequently removed in patch
04381b987292256d drm: Move plane helpers into drm_kms_helper.ko

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 drivers/gpu/drm/vmwgfx/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/Kconfig b/drivers/gpu/drm/vmwgfx/Kconfig
index 67720f7..4fba548 100644
--- a/drivers/gpu/drm/vmwgfx/Kconfig
+++ b/drivers/gpu/drm/vmwgfx/Kconfig
@@ -1,6 +1,7 @@
 config DRM_VMWGFX
 	tristate "DRM driver for VMware Virtual GPU"
 	depends on DRM && PCI
+	select FB
 	select FB_DEFERRED_IO
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
-- 
1.7.7.6

