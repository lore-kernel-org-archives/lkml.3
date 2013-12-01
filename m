Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab3LAUBP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 15:01:15 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53212 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3LAUBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 15:01:14 -0500
Date: Sun, 1 Dec 2013 21:01:13 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: sre@ring0.de, sre@debian.org, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Compile failure on linux-n900 branch -- MEDIA_CAMERA_SUPPORT
 needed for n900 compilation
Message-ID: <20131201200112.GE9743@amd.pavel.ucw.cz>
References: <20131127125149.GA9389@amd.pavel.ucw.cz>
 <201312011050.18256@pali>
 <20131201192120.GD9743@amd.pavel.ucw.cz>
 <201312012025.13622@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201312012025.13622@pali>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> board-rx51-camera.c is not part of mainline kernel and will never 
> be (due to DT migration). So maybe it could be better to add 
> #ifdef to board-rx51-camera.c. Keeping changes for Makefile/Kconfig 
> files is harder because of future rebase...

Ok, that makes sense.

This breaks compilation, too, but I don't think I want to fix that.

  Example code (PVR_EXAMPLES) [N/m/y] (NEW) 

(Select Y to break compile).

Thanks,
								Pavel

---

Fix compilation in !CONFIG_MEDIA_CAMERA_SUPPORT case, and make it such
that it is unlikely to cause merge conflicts later.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/arch/arm/mach-omap2/board-rx51-camera.c b/arch/arm/mach-omap2/board-rx51-camera.c
index 8b4b59a..bae2cc0 100644
--- a/arch/arm/mach-omap2/board-rx51-camera.c
+++ b/arch/arm/mach-omap2/board-rx51-camera.c
@@ -31,6 +31,7 @@
 
 #include <asm/gpio.h>
 
+#ifdef CONFIG_MEDIA_CAMERA_SUPPORT
 #include "../../../drivers/media/platform/omap3isp/isp.h"
 #include "../../../drivers/media/platform/omap3isp/ispreg.h"
 
@@ -375,9 +376,11 @@ static struct isp_platform_data rx51_isp_platform_data = {
 		{ .dev_id = "2-0010"},
 	.subdevs = rx51_camera_subdevs,
 };
+#endif
 
 void __init rx51_camera_init(void)
 {
+#ifdef CONFIG_MEDIA_CAMERA_SUPPORT
 	if (rx51_camera_hw_init()) {
 		printk(KERN_WARNING "%s: Unable to initialize camera\n",
 		       __func__);
@@ -387,4 +390,5 @@ void __init rx51_camera_init(void)
 	if (omap3_init_camera(&rx51_isp_platform_data) < 0)
 		printk(KERN_WARNING "%s: Unable to register camera platform "
 		       "device\n", __func__);
+#endif
 }




-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
