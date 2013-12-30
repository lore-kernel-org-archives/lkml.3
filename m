Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab3L3Dip (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 22:38:45 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:62814 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab3L3Dio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 22:38:44 -0500
Date: Mon, 30 Dec 2013 11:37:45 +0800
From: Wang YanQing <udknight@gmail.com>
To: gregkh@linuxfoundation.org
Cc: jslaby@suse.cz, airlied@redhat.com, akpm@linux-foundation.org,
        kilobyte@angband.pl, linux-kernel@vger.kernel.org
Subject: [PATCH] fonts:Kconfig: fix default enable FONT_8x8 and FONT_8x16 at
 the same time
Message-ID: <20131230033745.GA5855@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	gregkh@linuxfoundation.org, jslaby@suse.cz, airlied@redhat.com,
	akpm@linux-foundation.org, kilobyte@angband.pl,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FONT_8x8 and FONT_8x16 have the same default value line:
"default y if !SPARC && !FONTS"

I test run "make defconfig" for x86 will enable FONT_8x8 and FONT_8x16 at
the same time.

This patch fix it, because FONT_AUTOSELECT choice FONT_8x16, so
I decide to disable FONT_8x8, this patch will reduce size of kernel.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 lib/fonts/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/fonts/Kconfig b/lib/fonts/Kconfig
index 34fd931..11d3758 100644
--- a/lib/fonts/Kconfig
+++ b/lib/fonts/Kconfig
@@ -23,7 +23,6 @@ config FONTS
 config FONT_8x8
 	bool "VGA 8x8 font" if FONTS
 	depends on FRAMEBUFFER_CONSOLE || STI_CONSOLE
-	default y if !SPARC && !FONTS
 	help
 	  This is the "high resolution" font for the VGA frame buffer (the one
 	  provided by the text console 80x50 (and higher) modes).
-- 
1.8.3.4.8.g69490f3.dirty
