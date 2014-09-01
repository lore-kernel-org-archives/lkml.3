Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbaIAG0h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 02:26:37 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:49681 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361AbaIAG0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 02:26:30 -0400
From: Mikko Rapeli <mikko.rapeli@iki.fi>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, mikko.rapeli@iki.fi
Subject: [RFC PATCH v2 03/27] Makefile: propagate verbose options
Date: Mon,  1 Sep 2014 09:25:54 +0300
Message-Id: <1409552778-2537-4-git-send-email-mikko.rapeli@iki.fi>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1409552778-2537-1-git-send-email-mikko.rapeli@iki.fi>
References: <1408660449-4011-1-git-send-email-mikko.rapeli@iki.fi>
 <1409552778-2537-1-git-send-email-mikko.rapeli@iki.fi>
X-SA-Exim-Connect-IP: 217.30.184.161
X-SA-Exim-Mail-From: mcfrisk@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Usefull when debugging the make scripts.

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 Makefile | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index 25b85ab..df0eb14 100644
--- a/Makefile
+++ b/Makefile
@@ -855,13 +855,13 @@ quiet_cmd_link-vmlinux = LINK    $@
 # execute if the rest of the kernel build went well.
 vmlinux: scripts/link-vmlinux.sh $(vmlinux-deps) FORCE
 ifdef CONFIG_HEADERS_CHECK
-	$(Q)$(MAKE) -f $(srctree)/Makefile headers_check
+	$(Q)$(MAKE) V=$(KBUILD_VERBOSE) -f $(srctree)/Makefile headers_check
 endif
 ifdef CONFIG_SAMPLES
-	$(Q)$(MAKE) $(build)=samples
+	$(Q)$(MAKE) V=$(KBUILD_VERBOSE) $(build)=samples
 endif
 ifdef CONFIG_BUILD_DOCSRC
-	$(Q)$(MAKE) $(build)=Documentation
+	$(Q)$(MAKE) V=$(KBUILD_VERBOSE) $(build)=Documentation
 endif
 	+$(call if_changed,link-vmlinux)
 
@@ -1012,7 +1012,7 @@ headers_check_all: headers_install_all
 PHONY += headers_check
 headers_check: headers_install
 	$(Q)$(MAKE) $(hdr-inst)=include/uapi HDRCHECK=1
-	$(Q)$(MAKE) $(hdr-inst)=arch/$(hdr-arch)/include/uapi/asm $(hdr-dst) HDRCHECK=1
+	$(Q)$(MAKE) V=$(KBUILD_VERBOSE) $(hdr-inst)=arch/$(hdr-arch)/include/uapi/asm $(hdr-dst) HDRCHECK=1
 
 # ---------------------------------------------------------------------------
 # Modules
-- 
2.1.0

