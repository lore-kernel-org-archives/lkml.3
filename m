Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab3LATV0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 14:21:26 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51764 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab3LATVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 14:21:22 -0500
Date: Sun, 1 Dec 2013 20:21:20 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: sre@ring0.de, sre@debian.org, kernel list <linux-kernel@vger.kernel.org>
Subject: Compile failure on linux-n900 branch -- MEDIA_CAMERA_SUPPORT
 needed for n900 compilation
Message-ID: <20131201192120.GD9743@amd.pavel.ucw.cz>
References: <20131127125149.GA9389@amd.pavel.ucw.cz>
 <20131130172938.GA5194@amd.pavel.ucw.cz>
 <20131130231532.GA6688@amd.pavel.ucw.cz>
 <201312011050.18256@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201312011050.18256@pali>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I just hit this one:

  CC      arch/arm/mach-omap2/board-rx51-camera.o
In file included from arch/arm/mach-omap2/board-rx51-camera.c:34:0:
arch/arm/mach-omap2/../../../drivers/media/platform/omap3isp/isp.h: In
function 'isp_pad_buffer_type':
arch/arm/mach-omap2/../../../drivers/media/platform/omap3isp/isp.h:347:19:
error: 'const struct v4l2_subdev' has no member named 'entity'
arch/arm/mach-omap2/../../../drivers/media/platform/omap3isp/isp.h:350:12:
error: 'const struct v4l2_subdev' has no member named 'entity'
make[1]: *** [arch/arm/mach-omap2/board-rx51-camera.o] Error 1
make: *** [arch/arm/mach-omap2] Error 2
make: *** Waiting for unfinished jobs....
Command exited with non-zero status 2

Problem seems to be that isp.h expects CONFIG_MEDIA_CONTROLLER to be set,
but board-rx51-camera.c is always compiled. We could do

config MACH_NOKIA_RX51
        bool "Nokia N900 (RX-51) phone"
-        depends on ARCH_OMAP3
+        depends on ARCH_OMAP3 && MEDIA_CONTROLLER
        default y
	select OMAP_PACKAGE_CBB
 
...but that's cruel to the user. Would this be acceptable?

config MACH_NOKIA_RX51
        bool "Nokia N900 (RX-51) phone"
        depends on ARCH_OMAP3
        default y
	select OMAP_PACKAGE_CBB
+	select MEDIA_CONTROLLER
+       select MEDIA_CAMERA_SUPPORT

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
