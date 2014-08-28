Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936155AbaH1CLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 22:11:00 -0400
Received: from mail-pa0-f74.google.com ([209.85.220.74]:47036 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936127AbaH1CKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 22:10:18 -0400
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
Subject: [PATCH v2 3/7] MIPS: Octeon: Move device-trees to arch/mips/boot/dts/cavium-octeon/
Date: Wed, 27 Aug 2014 19:10:08 -0700
Message-Id: <1409191812-23697-4-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1409191812-23697-1-git-send-email-abrestic@chromium.org>
References: <1409191812-23697-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the Octeon device-trees to arch/mips/boot/dts/cavium-octeon/ and
update the Makefiles accordingly.  Since Octeon requires the device-tree
to be built into the kernel, select BUILTIN_DTB as well.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 arch/mips/Kconfig                                      |  1 +
 arch/mips/boot/dts/Makefile                            |  2 ++
 arch/mips/boot/dts/cavium-octeon/Makefile              |  2 ++
 arch/mips/{ => boot/dts}/cavium-octeon/octeon_3xxx.dts |  0
 arch/mips/{ => boot/dts}/cavium-octeon/octeon_68xx.dts |  0
 arch/mips/cavium-octeon/.gitignore                     |  2 --
 arch/mips/cavium-octeon/Makefile                       | 10 ----------
 7 files changed, 5 insertions(+), 12 deletions(-)
 create mode 100644 arch/mips/boot/dts/cavium-octeon/Makefile
 rename arch/mips/{ => boot/dts}/cavium-octeon/octeon_3xxx.dts (100%)
 rename arch/mips/{ => boot/dts}/cavium-octeon/octeon_68xx.dts (100%)
 delete mode 100644 arch/mips/cavium-octeon/.gitignore

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 19b8aac..dbfcf35 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -741,6 +741,7 @@ config CAVIUM_OCTEON_SOC
 	select ARCH_SPARSEMEM_ENABLE
 	select SYS_SUPPORTS_SMP
 	select NR_CPUS_DEFAULT_16
+	select BUILTIN_DTB
 	help
 	  This option supports all of the Octeon reference boards from Cavium
 	  Networks. It builds a kernel that dynamically determines the Octeon
diff --git a/arch/mips/boot/dts/Makefile b/arch/mips/boot/dts/Makefile
index dcb7810..a8daed1 100644
--- a/arch/mips/boot/dts/Makefile
+++ b/arch/mips/boot/dts/Makefile
@@ -1,3 +1,5 @@
+include arch/mips/boot/dts/cavium-octeon/Makefile
+
 obj-y		+= $(patsubst %.dtb, %.dtb.o, $(dtb-y))
 
 targets		+= dtbs
diff --git a/arch/mips/boot/dts/cavium-octeon/Makefile b/arch/mips/boot/dts/cavium-octeon/Makefile
new file mode 100644
index 0000000..4663d75
--- /dev/null
+++ b/arch/mips/boot/dts/cavium-octeon/Makefile
@@ -0,0 +1,2 @@
+dtb-$(CONFIG_CAVIUM_OCTEON_SOC)	+= cavium-octeon/octeon_3xxx.dtb \
+				cavium-octeon/octeon_68xx.dtb
diff --git a/arch/mips/cavium-octeon/octeon_3xxx.dts b/arch/mips/boot/dts/cavium-octeon/octeon_3xxx.dts
similarity index 100%
rename from arch/mips/cavium-octeon/octeon_3xxx.dts
rename to arch/mips/boot/dts/cavium-octeon/octeon_3xxx.dts
diff --git a/arch/mips/cavium-octeon/octeon_68xx.dts b/arch/mips/boot/dts/cavium-octeon/octeon_68xx.dts
similarity index 100%
rename from arch/mips/cavium-octeon/octeon_68xx.dts
rename to arch/mips/boot/dts/cavium-octeon/octeon_68xx.dts
diff --git a/arch/mips/cavium-octeon/.gitignore b/arch/mips/cavium-octeon/.gitignore
deleted file mode 100644
index 39c9686..0000000
--- a/arch/mips/cavium-octeon/.gitignore
+++ /dev/null
@@ -1,2 +0,0 @@
-*.dtb.S
-*.dtb
diff --git a/arch/mips/cavium-octeon/Makefile b/arch/mips/cavium-octeon/Makefile
index 4e95204..42f5f1a 100644
--- a/arch/mips/cavium-octeon/Makefile
+++ b/arch/mips/cavium-octeon/Makefile
@@ -20,13 +20,3 @@ obj-y += executive/
 obj-$(CONFIG_MTD)		      += flash_setup.o
 obj-$(CONFIG_SMP)		      += smp.o
 obj-$(CONFIG_OCTEON_ILM)	      += oct_ilm.o
-
-DTS_FILES = octeon_3xxx.dts octeon_68xx.dts
-DTB_FILES = $(patsubst %.dts, %.dtb, $(DTS_FILES))
-
-obj-y += $(patsubst %.dts, %.dtb.o, $(DTS_FILES))
-
-# Let's keep the .dtb files around in case we want to look at them.
-.SECONDARY:  $(addprefix $(obj)/, $(DTB_FILES))
-
-clean-files += $(DTB_FILES) $(patsubst %.dtb, %.dtb.S, $(DTB_FILES))
-- 
2.1.0.rc2.206.gedb03e5

