Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264AbaAWOQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 09:16:16 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:51082 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932244AbaAWOQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 09:16:12 -0500
From: David Herrmann <dh.herrmann@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: Ingo Molnar <mingo@kernel.org>, linux-fbdev@vger.kernel.org,
        Dave Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-kernel@vger.kernel.org,
        Tom Gundersen <teg@jklm.no>, David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH 11/11] x86/sysfb: allow sysfb+simpledrm combination
Date: Thu, 23 Jan 2014 15:15:03 +0100
Message-Id: <1390486503-1504-12-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390486503-1504-1-git-send-email-dh.herrmann@gmail.com>
References: <1390486503-1504-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We used to protect X86_SYSFB by depending on FB_SIMPLE so users don't
accidentally end up without a kernel console. Now that DRM_SIMPLEDRM also
provides a simple-framebuffer driver, we can whitelist this driver, too.
---
 arch/x86/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 93df439..f3eae6a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2299,7 +2299,7 @@ source "drivers/rapidio/Kconfig"
 
 config X86_SYSFB
 	bool "Mark VGA/VBE/EFI FB as generic system framebuffer"
-	depends on FB_SIMPLE
+	depends on FB_SIMPLE || DRM_SIMPLEDRM
 	select SYSFB
 	help
 	  Firmwares often provide initial graphics framebuffers so the BIOS,
-- 
1.8.5.3

