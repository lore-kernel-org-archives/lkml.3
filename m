Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965190AbaH1CKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 22:10:21 -0400
Received: from mail-oa0-f74.google.com ([209.85.219.74]:63680 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935926AbaH1CKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 22:10:17 -0400
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
Subject: [PATCH v2 1/7] MIPS: Create common infrastructure for building built-in device-trees
Date: Wed, 27 Aug 2014 19:10:06 -0700
Message-Id: <1409191812-23697-2-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1409191812-23697-1-git-send-email-abrestic@chromium.org>
References: <1409191812-23697-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for moving the device-trees to a common location,
introduce the config option BUILTIN_DTB, which can be selected by
platforms that use a device-tree built into the kernel image, and
create a Makefile to build the device-trees in arch/mips/boot/dts/.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 arch/mips/Kconfig           | 3 +++
 arch/mips/Makefile          | 6 ++++++
 arch/mips/boot/dts/Makefile | 3 +++
 3 files changed, 12 insertions(+)
 create mode 100644 arch/mips/boot/dts/Makefile

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index df51e78..19b8aac 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -2481,6 +2481,9 @@ config USE_OF
 	select OF_EARLY_FLATTREE
 	select IRQ_DOMAIN
 
+config BUILTIN_DTB
+	bool
+
 endmenu
 
 config LOCKDEP_SUPPORT
diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index 9336509..72cdd6a 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -324,6 +324,12 @@ endif
 
 CLEAN_FILES += vmlinux.32 vmlinux.64
 
+# device-trees
+core-$(CONFIG_BUILTIN_DTB) += arch/mips/boot/dts/
+
+%.dtb %.dtb.S %.dtb.o: | scripts
+	$(Q)$(MAKE) $(build)=arch/mips/boot/dts arch/mips/boot/dts/$@
+
 archprepare:
 ifdef CONFIG_MIPS32_N32
 	@echo '  Checking missing-syscalls for N32'
diff --git a/arch/mips/boot/dts/Makefile b/arch/mips/boot/dts/Makefile
new file mode 100644
index 0000000..0fef69d
--- /dev/null
+++ b/arch/mips/boot/dts/Makefile
@@ -0,0 +1,3 @@
+obj-y		+= $(patsubst %.dtb, %.dtb.o, $(dtb-y))
+
+clean-files	+= */*.dtb.S
-- 
2.1.0.rc2.206.gedb03e5

