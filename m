Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbaC1Rr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 13:47:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51315 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbaC1Ra6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:30:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 3.13 08/46] partly revert commit 8a10bc9: parisc/sti_console: prefer Linux fonts over built-in ROM fonts
Date: Fri, 28 Mar 2014 10:31:52 -0700
Message-Id: <20140328173135.768522838@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140328173134.630198216@linuxfoundation.org>
References: <20140328173134.630198216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit a2fb4d782c61f77480e586578eeb4dfd27d134ea upstream.

STI console is used on parisc and m68k HP machines. This patch partly reverts
my previous commit and as such restores the fonts for the m68k machines.

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/fonts/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/lib/fonts/Kconfig
+++ b/lib/fonts/Kconfig
@@ -9,7 +9,7 @@ if FONT_SUPPORT
 
 config FONTS
 	bool "Select compiled-in fonts"
-	depends on FRAMEBUFFER_CONSOLE
+	depends on FRAMEBUFFER_CONSOLE || STI_CONSOLE
 	help
 	  Say Y here if you would like to use fonts other than the default
 	  your frame buffer console usually use.
@@ -22,7 +22,7 @@ config FONTS
 
 config FONT_8x8
 	bool "VGA 8x8 font" if FONTS
-	depends on FRAMEBUFFER_CONSOLE
+	depends on FRAMEBUFFER_CONSOLE || STI_CONSOLE
 	default y if !SPARC && !FONTS
 	help
 	  This is the "high resolution" font for the VGA frame buffer (the one
@@ -45,7 +45,7 @@ config FONT_8x16
 
 config FONT_6x11
 	bool "Mac console 6x11 font (not supported by all drivers)" if FONTS
-	depends on FRAMEBUFFER_CONSOLE
+	depends on FRAMEBUFFER_CONSOLE || STI_CONSOLE
 	default y if !SPARC && !FONTS && MAC
 	help
 	  Small console font with Macintosh-style high-half glyphs.  Some Mac


