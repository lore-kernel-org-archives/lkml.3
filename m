Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab3LSNjX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 08:39:23 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:59827 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab3LSNjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 08:39:20 -0500
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>, Ingo Molnar <mingo@kernel.org>,
        <x86@kernel.org>, <linux-fbdev@vger.kernel.org>,
        David Herrmann <dh.herrmann@gmail.com>, <stable@vger.kernel.org>
Subject: [PATCH] x86: sysfb: fool-proof CONFIG_X86_SYSFB
Date: Thu, 19 Dec 2013 14:38:50 +0100
Message-Id: <1387460330-13989-1-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Turns out, people do not read help-texts of new config-options and enable
them nonetheless. So several reports came in with X86_SYSFB=y and
FB_SIMPLE=n, which in almost all situations prevents firmware-fbs from
being probed.

X86_SYSFB clearly states that it turns legacy vesa/efi framebuffers into a
format compatible to simplefb (and does nothing else..). So to avoid
further complaints about missing gfx-support during boot, simply depend on
FB_SIMPLE now.
As FB_SIMPLE is disabled by default and usually only enabled on selected
ARM architectures, x86 users should thus never see the X86_SYSFB
config-option. And if they do, everything is fine as simplefb will be
available.

Note that most of the sysfb code is enabled independently of X86_SYSFB.
The config option only selects a compatibility mode for simplefb. It was
introduced to ease the transition to SimpleDRM and disabling fbdev. As
this is still ongoing, there's no need for non-developers to care for
X86_SYSFB so just change the help-text recommendation to "n".

Cc: <stable@vger.kernel.org> # 3.11+
Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 arch/x86/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e903c71..9317ede 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2298,6 +2298,7 @@ source "drivers/rapidio/Kconfig"
 
 config X86_SYSFB
 	bool "Mark VGA/VBE/EFI FB as generic system framebuffer"
+	depends on (FB_SIMPLE = y)
 	help
 	  Firmwares often provide initial graphics framebuffers so the BIOS,
 	  bootloader or kernel can show basic video-output during boot for
@@ -2320,7 +2321,7 @@ config X86_SYSFB
 	  and others enabled as fallback if a system framebuffer is
 	  incompatible with simplefb.
 
-	  If unsure, say Y.
+	  If unsure, say N.
 
 endmenu
 
-- 
1.8.5.1

