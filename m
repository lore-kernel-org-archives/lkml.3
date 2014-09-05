Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbaIEGs4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 02:48:56 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:48438 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbaIEGsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 02:48:52 -0400
From: Robert Richter <rric@kernel.org>
To: Olof Johansson <olof@lixom.net>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Michal Marek <mmarek@suse.cz>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Richter <rrichter@cavium.com>
Subject: [PATCH 1/6] dts, arm64: Add dtbs_install make target
Date: Fri,  5 Sep 2014 08:48:07 +0200
Message-Id: <1409899692-1455-2-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1409899692-1455-1-git-send-email-rric@kernel.org>
References: <1409899692-1455-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <rrichter@cavium.com>

This adds the dtbs_install make target to arm64. The target has been
introduced already to arch/arm with the following commit:

 f4d4ffc03efc kbuild: dtbs_install: new make target

Implementation for arm64 is the same as for arm.

With 'dtbs_install' all config enabled dtb files are installed to
either the INSTALL_DTBS_PATH directory or the default location:

 $INSTALL_PATH/dtbs/$KERNELRELEASE

Signed-off-by: Robert Richter <rrichter@cavium.com>
---
 arch/arm64/Makefile          | 6 ++++--
 arch/arm64/boot/dts/Makefile | 4 +++-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index 2df5e5daeebe..e0a8292bc832 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -71,8 +71,9 @@ zinstall install: vmlinux
 %.dtb: scripts
 	$(Q)$(MAKE) $(build)=$(boot)/dts $(boot)/dts/$@
 
-dtbs: scripts
-	$(Q)$(MAKE) $(build)=$(boot)/dts dtbs
+PHONY += dtbs dtbs_install
+dtbs dtbs_install: prepare scripts
+	$(Q)$(MAKE) $(build)=$(boot)/dts $@
 
 PHONY += vdso_install
 vdso_install:
@@ -86,6 +87,7 @@ define archhelp
   echo  '* Image.gz      - Compressed kernel image (arch/$(ARCH)/boot/Image.gz)'
   echo  '  Image         - Uncompressed kernel image (arch/$(ARCH)/boot/Image)'
   echo  '* dtbs          - Build device tree blobs for enabled boards'
+  echo  '  dtbs_install  - Install dtbs to $(INSTALL_DTBS_PATH)'
   echo  '  install       - Install uncompressed kernel'
   echo  '  zinstall      - Install compressed kernel'
   echo  '                  Install using (your) ~/bin/installkernel or'
diff --git a/arch/arm64/boot/dts/Makefile b/arch/arm64/boot/dts/Makefile
index c52bdb051f66..82e1c4cf8780 100644
--- a/arch/arm64/boot/dts/Makefile
+++ b/arch/arm64/boot/dts/Makefile
@@ -1,9 +1,11 @@
 dtb-$(CONFIG_ARCH_VEXPRESS) += rtsm_ve-aemv8a.dtb foundation-v8.dtb
 dtb-$(CONFIG_ARCH_XGENE) += apm-mustang.dtb
 
-targets += dtbs
+targets += dtbs dtbs_install
 targets += $(dtb-y)
 
 dtbs: $(addprefix $(obj)/, $(dtb-y))
 
 clean-files := *.dtb
+
+dtbs_install: $(addsuffix _dtbinst_, $(dtb-y))
-- 
2.0.1

