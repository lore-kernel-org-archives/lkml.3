Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916AbaB0Lzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:55:50 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:50198 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074AbaB0Lzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:55:43 -0500
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: <linux-fbdev@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <linux-kernel@vger.kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        David Airlie <airlied@linux.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH 3/3] video: Kconfig: move drm and fb into separate menus
Date: Thu, 27 Feb 2014 13:54:46 +0200
Message-ID: <1393502086-9433-4-git-send-email-tomi.valkeinen@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393502086-9433-1-git-send-email-tomi.valkeinen@ti.com>
References: <1393502086-9433-1-git-send-email-tomi.valkeinen@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the moment the "Device Drivers / Graphics support" kernel config page
looks rather messy, with DRM and fbdev driver selections on the same
page, some on the top level Graphics support page, some under their
respective subsystems.

If I'm not mistaken, this is caused by the drivers depending on other
things than DRM or FB, which causes Kconfig to arrange the options in
not-so-neat manner.

Both DRM and FB have a main menuconfig option for the whole DRM or FB
subsystem. Optimally, this would be enough to arrange all DRM and FB
options under the respective subsystem, but for whatever reason this
doesn't work reliably.

This patch adds an explicit submenu for DRM and FB, making it much
clearer which options are related to FB, and which to DRM.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Rob Clark <robdclark@gmail.com>
Reviewed-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/Kconfig | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index f0f26a0b746e..70d174090a54 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -21,9 +21,13 @@ source "drivers/gpu/vga/Kconfig"
 
 source "drivers/gpu/host1x/Kconfig"
 
+menu "Direct Rendering Manager"
 source "drivers/gpu/drm/Kconfig"
+endmenu
 
+menu "Framebuffer Devices"
 source "drivers/video/fbdev/Kconfig"
+endmenu
 
 source "drivers/video/backlight/Kconfig"
 
-- 
1.8.3.2

