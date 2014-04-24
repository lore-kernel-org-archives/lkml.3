Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974AbaDXM2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:28:51 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:35949 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756944AbaDXM2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:28:48 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linaro-kernel@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Peter Griffin <peter.griffin@linaro.org>,
        Simon Horman <horms+renesas@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
Subject: [PATCH 01/13] video: sh_mobile_lcdcfb depends on meram
Date: Thu, 24 Apr 2014 13:28:17 +0100
Message-Id: <1398342509-10243-2-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398342509-10243-1-git-send-email-peter.griffin@linaro.org>
References: <1398342509-10243-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The sh_mobile_lcdcfb driver calls interfaces provided
by the corresponding "meram" helper. This fails if meram
is a module but lcdcfb is built-in.

To work around it, this uses special Kconfig magic to
only allow lcdcfb to be built if
a) both are modules,
b) meram is built-in, or
c) meram is disabled and the helpers stubbed out

Changing meram from 'y' to 'm' now forces clcd to
be a module as well, which seems to be the desired
behavior.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Cc: Simon Horman <horms+renesas@verge.net.au>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-sh@vger.kernel.org
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-fbdev@vger.kernel.org
---
 drivers/video/fbdev/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
index e1f4727..a4116bf 100644
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -1971,6 +1971,7 @@ config FB_W100
 config FB_SH_MOBILE_LCDC
 	tristate "SuperH Mobile LCDC framebuffer support"
 	depends on FB && (SUPERH || ARCH_SHMOBILE) && HAVE_CLK
+	depends on FB_SH_MOBILE_MERAM || !FB_SH_MOBILE_MERAM
 	select FB_SYS_FILLRECT
 	select FB_SYS_COPYAREA
 	select FB_SYS_IMAGEBLIT
-- 
1.7.9.5

