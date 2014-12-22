Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbaLVX1w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 18:27:52 -0500
Received: from mail-oi0-f73.google.com ([209.85.218.73]:55235 "EHLO
	mail-oi0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798AbaLVX1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 18:27:49 -0500
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH 2/2] MIPS: Add dtbs_install target
Date: Mon, 22 Dec 2014 15:27:43 -0800
Message-Id: <1419290863-19788-2-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
In-Reply-To: <1419290863-19788-1-git-send-email-abrestic@chromium.org>
References: <1419290863-19788-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the dtbs_install Makefile target to install the dtb files into
$INSTALL_DTBS_PATH.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 arch/mips/Makefile | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index 9c4b9c8..6ff26bc 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -356,6 +356,10 @@ PHONY += dtbs
 dtbs: scripts
 	$(Q)$(MAKE) $(build)=arch/mips/boot/dts
 
+PHONY += dtbs_install
+dtbs_install:
+	$(Q)$(MAKE) $(dtbinst)=arch/mips/boot/dts
+
 archprepare:
 ifdef CONFIG_MIPS32_N32
 	@echo '  Checking missing-syscalls for N32'
@@ -392,6 +396,7 @@ define archhelp
 	echo '  uImage               - U-Boot image'
 	echo '  uImage.gz            - U-Boot image (gzip)'
 	echo '  dtbs                 - Device-tree blobs for enabled boards'
+	echo '  dtbs_install         - Install dtbs to $(INSTALL_DTBS_PATH)'
 	echo
 	echo '  These will be default as appropriate for a configured platform.'
 endef
-- 
2.2.0.rc0.207.ga3a616c

