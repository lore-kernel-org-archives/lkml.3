Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab3CKUrK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 16:47:10 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:56481 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752738Ab3CKUrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 16:47:06 -0400
Message-ID: <1363034823.3137.110.camel@x61.thuisdomein>
Subject: [PATCH] backlight: fix typo "MACH_SAM9...EK" three times
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Purdie <rpurdie@rpsys.net>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 11 Mar 2013 21:47:03 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Mar 2013 20:47:03.0315 (UTC) FILETIME=[95D88E30:01CE1E99]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix three typos (originally) introduced by commit
a9a84c37d1ee50db8f3752b117caf2b48dcd4f8a ("atmel_lcdfb: backlight
control").

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Tested by grepping the tree.

1) So two of these typos were introduced in v2.6.25. (The third was
introduced in commit 915190f7d4f08e413e5fde6b0abcd5375aeacdf4 ("[ARM]
5614/1: at91: atmel_lcdfb: add at91sam9g10 support to atmel LCD
driver")). Checking these commits reveals that the default value of 'y'
has never been set automatically in all releases since v2.6.25! Perhaps
this line might as well be dropped.

 drivers/video/backlight/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index db10d01..a4481df 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -161,7 +161,7 @@ if BACKLIGHT_CLASS_DEVICE
 config BACKLIGHT_ATMEL_LCDC
 	bool "Atmel LCDC Contrast-as-Backlight control"
 	depends on FB_ATMEL
-	default y if MACH_SAM9261EK || MACH_SAM9G10EK || MACH_SAM9263EK
+	default y if MACH_AT91SAM9261EK || MACH_AT91SAM9G10EK || MACH_AT91SAM9263EK
 	help
 	  This provides a backlight control internal to the Atmel LCDC
 	  driver.  If the LCD "contrast control" on your board is wired
-- 
1.7.11.7

