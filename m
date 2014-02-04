Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934918AbaBDVYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:24:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57475 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934697AbaBDVMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:12:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 3.13 124/140] parisc/sti_console: prefer Linux fonts over built-in ROM fonts
Date: Tue,  4 Feb 2014 13:11:51 -0800
Message-Id: <20140204211040.515241526@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204211036.967663852@linuxfoundation.org>
References: <20140204211036.967663852@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 8a10bc9d27ceb084b0d8be621a033a475eb9fdfd upstream.

The built-in ROM fonts lack many necessary ASCII characters, which is
why it makes sens to prefer the Linux fonts instead if they are
available.  This makes consoles on STI graphics cards which are not
supported by the stifb driver (e.g. Visualize FXe) looks much nicer.

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/console/sticore.c |    2 +-
 lib/fonts/Kconfig               |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/video/console/sticore.c
+++ b/drivers/video/console/sticore.c
@@ -488,7 +488,7 @@ static int sti_init_glob_cfg(struct sti_
 	return 0;
 }
 
-#ifdef CONFIG_FONTS
+#ifdef CONFIG_FONT_SUPPORT
 static struct sti_cooked_font *
 sti_select_fbfont(struct sti_cooked_rom *cooked_rom, const char *fbfont_name)
 {
--- a/lib/fonts/Kconfig
+++ b/lib/fonts/Kconfig
@@ -9,7 +9,7 @@ if FONT_SUPPORT
 
 config FONTS
 	bool "Select compiled-in fonts"
-	depends on FRAMEBUFFER_CONSOLE || STI_CONSOLE
+	depends on FRAMEBUFFER_CONSOLE
 	help
 	  Say Y here if you would like to use fonts other than the default
 	  your frame buffer console usually use.
@@ -22,7 +22,7 @@ config FONTS
 
 config FONT_8x8
 	bool "VGA 8x8 font" if FONTS
-	depends on FRAMEBUFFER_CONSOLE || STI_CONSOLE
+	depends on FRAMEBUFFER_CONSOLE
 	default y if !SPARC && !FONTS
 	help
 	  This is the "high resolution" font for the VGA frame buffer (the one
@@ -45,7 +45,7 @@ config FONT_8x16
 
 config FONT_6x11
 	bool "Mac console 6x11 font (not supported by all drivers)" if FONTS
-	depends on FRAMEBUFFER_CONSOLE || STI_CONSOLE
+	depends on FRAMEBUFFER_CONSOLE
 	default y if !SPARC && !FONTS && MAC
 	help
 	  Small console font with Macintosh-style high-half glyphs.  Some Mac


