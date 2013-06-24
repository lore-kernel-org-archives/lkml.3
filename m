Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408Ab3FXUmP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 16:42:15 -0400
Received: from mail-yh0-f74.google.com ([209.85.213.74]:57547 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab3FXUmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 16:42:14 -0400
From: Doug Anderson <dianders@chromium.org>
To: Russell King <rmk+kernel@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>
Cc: Olof Johansson <olof@lixom.net>, Mike Frysinger <vapier@gentoo.org>,
        Doug Anderson <dianders@chromium.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: Fix dtb dependency to use order-only prerequisites
Date: Mon, 24 Jun 2013 13:41:57 -0700
Message-Id: <1372106517-19105-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The %.dtb dependency is specified to depend on the PHONY "scripts".
That means that it'll build every time even if the underlying dtb file
hasn't been touched.  Use an order-only prerequisites to fix this.
Also mark "dtbs" as PHONY for correctness.

This was broken in (70b0476 ARM: 7513/1: Make sure dtc is built before
running it).

Reported-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 arch/arm/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 1ba358b..fe8144e 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -289,9 +289,10 @@ zImage Image xipImage bootpImage uImage: vmlinux
 zinstall uinstall install: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $@
 
-%.dtb: scripts
+%.dtb: | scripts
 	$(Q)$(MAKE) $(build)=$(boot)/dts MACHINE=$(MACHINE) $(boot)/dts/$@
 
+PHONY += dtbs
 dtbs: scripts
 	$(Q)$(MAKE) $(build)=$(boot)/dts MACHINE=$(MACHINE) dtbs
 
-- 
1.8.3

