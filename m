Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682Ab3GDM1F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:27:05 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:49576 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755418Ab3GDM0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:26:36 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        David Herrmann <dh.herrmann@gmail.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Subject: [PATCH v2 08/14] fbdev: fbcon: select VT_HW_CONSOLE_BINDING
Date: Thu,  4 Jul 2013 14:25:08 +0200
Message-Id: <1372940714-12470-9-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1372940714-12470-1-git-send-email-dh.herrmann@gmail.com>
References: <1372940714-12470-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fbdev provides framebuffer hotplugging, hence, we need to allow fbcon to
unbind from framebuffers. Unfortunately, fbcon_fb_unbind() cannot unbind
from the last framebuffer, unless console-unbinding is supported.

Fixing fbcon_unbind() to return 0 caused some horrible NULL-derefs in the
VT layer and I couldn't figure out why. Hence, lets just require
console-unbinding so fbdev hotplugging works with fbcon.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 drivers/video/console/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/video/console/Kconfig b/drivers/video/console/Kconfig
index bc922c4..538d700 100644
--- a/drivers/video/console/Kconfig
+++ b/drivers/video/console/Kconfig
@@ -89,7 +89,8 @@ config DUMMY_CONSOLE_ROWS
 
 config FRAMEBUFFER_CONSOLE
 	tristate "Framebuffer Console support"
-	depends on FB
+	depends on FB && !UML
+	select VT_HW_CONSOLE_BINDING
 	select CRC32
 	help
 	  Low-level framebuffer-based console driver.
-- 
1.8.3.2

