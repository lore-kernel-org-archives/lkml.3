Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936204AbaH1Chi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 22:37:38 -0400
Received: from mail-oa0-f74.google.com ([209.85.219.74]:35346 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933108AbaH1Chh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 22:37:37 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: James Hogan <james.hogan@imgtec.com>, Paul Burton <paul.burton@imgtec.com>,
        David Daney <david.daney@cavium.com>,
        John Crispin <blogic@openwrt.org>,
        Jayachandran C <jchandra@broadcom.com>,
        Qais Yousef <qais.yousef@imgtec.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonas Gorski <jogo@openwrt.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH v2 2/7] MIPS: Add support for building device-tree binaries
Date: Wed, 27 Aug 2014 19:10:07 -0700
Message-Id: <1409191812-23697-3-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1409191812-23697-1-git-send-email-abrestic@chromium.org>
References: <1409191812-23697-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a 'dtbs' Makefile target that just builds the device-tree binaries
enabled by the configuration.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 arch/mips/Makefile          | 5 +++++
 arch/mips/boot/.gitignore   | 1 +
 arch/mips/boot/dts/Makefile | 7 ++++++-
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index 72cdd6a..26672e1 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -330,6 +330,10 @@ core-$(CONFIG_BUILTIN_DTB) += arch/mips/boot/dts/
 %.dtb %.dtb.S %.dtb.o: | scripts
 	$(Q)$(MAKE) $(build)=arch/mips/boot/dts arch/mips/boot/dts/$@
 
+PHONY += dtbs
+dtbs: scripts
+	$(Q)$(MAKE) $(build)=arch/mips/boot/dts dtbs
+
 archprepare:
 ifdef CONFIG_MIPS32_N32
 	@echo '  Checking missing-syscalls for N32'
@@ -364,6 +368,7 @@ define archhelp
 	echo '  vmlinuz.srec         - SREC zboot image'
 	echo '  uImage               - U-Boot image'
 	echo '  uImage.gz            - U-Boot image (gzip)'
+	echo '  dtbs                 - Device-tree blobs for enabled boards'
 	echo
 	echo '  These will be default as appropriate for a configured platform.'
 endef
diff --git a/arch/mips/boot/.gitignore b/arch/mips/boot/.gitignore
index a73d6e2..d3962cd 100644
--- a/arch/mips/boot/.gitignore
+++ b/arch/mips/boot/.gitignore
@@ -5,3 +5,4 @@ zImage
 zImage.tmp
 calc_vmlinuz_load_addr
 uImage
+*.dtb
diff --git a/arch/mips/boot/dts/Makefile b/arch/mips/boot/dts/Makefile
index 0fef69d..dcb7810 100644
--- a/arch/mips/boot/dts/Makefile
+++ b/arch/mips/boot/dts/Makefile
@@ -1,3 +1,8 @@
 obj-y		+= $(patsubst %.dtb, %.dtb.o, $(dtb-y))
 
-clean-files	+= */*.dtb.S
+targets		+= dtbs
+targets		+= $(dtb-y)
+
+dtbs: $(addprefix $(obj)/, $(dtb-y))
+
+clean-files	+= */*.dtb */*.dtb.S
-- 
2.1.0.rc2.206.gedb03e5

