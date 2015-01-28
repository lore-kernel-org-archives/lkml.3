Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933462AbbA2CLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:11:34 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:54588 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933408AbbA2CLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:11:30 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Felipe Balbi <balbi@ti.com>
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] usb: musb: add omap-control dependency
Date: Wed, 28 Jan 2015 22:51:04 +0100
Message-ID: <3080978.V631px3tUy@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <4595774.yLOm5IvvqR@wuerfel>
References: <4595774.yLOm5IvvqR@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:CBalSN+uq0kYeblxfUxv/kKd/i1OrnjJudWuBX/ZRTnUWHFHN6y
 qqaJgW0cBBg26oeWA3eEdGIUPi2QiCBePIDeOno6srt7S/XRcNZbISZEFfJ73oh0nLOHBqE
 RoqhKsYLidyF6jsZgWychVdB9C78k+Bb84gT4/YGhTMc33my5Ikv9mFJcJ4PiD1ZPUMF/Dz
 F4OIC0NvR9a+hO3dtHx/w==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The omap musb front-end calls into the phy driver directly
instead of using a generic phy interface, which causes a link
error when the specific driver is not built-in:

drivers/built-in.o: In function `omap2430_musb_disable':
usb/musb/omap2430.c:480: undefined reference to `omap_control_usb_set_mode'
drivers/built-in.o: In function `omap2430_musb_enable':
usb/musb/omap2430.c:466: undefined reference to `omap_control_usb_set_mode'
usb/musb/omap2430.c:447: undefined reference to `omap_control_usb_set_mode'
drivers/built-in.o: In function `omap_musb_set_mailbox':
usb/musb/omap2430.c:273: undefined reference to `omap_control_usb_set_mode'
usb/musb/omap2430.c:304: undefined reference to `omap_control_usb_set_mode'
drivers/built-in.o:(.debug_addr+0xbd9e0): more undefined references to `omap_control_usb_set_mode' follow

This adds an explicit dependency.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: ca784be36cc725 ("usb: start using the control module driver")

diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
index 26c835f1b726..14e1628483d9 100644
--- a/drivers/usb/musb/Kconfig
+++ b/drivers/usb/musb/Kconfig
@@ -79,7 +79,7 @@ config USB_MUSB_TUSB6010
 
 config USB_MUSB_OMAP2PLUS
 	tristate "OMAP2430 and onwards"
-	depends on ARCH_OMAP2PLUS && USB
+	depends on ARCH_OMAP2PLUS && USB && OMAP_CONTROL_PHY
 	select GENERIC_PHY
 
 config USB_MUSB_AM35X

