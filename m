Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbaIORyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 13:54:51 -0400
Received: from mail-ig0-f202.google.com ([209.85.213.202]:41848 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135AbaIORyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 13:54:05 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        James Hogan <james.hogan@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>,
        David Daney <david.daney@cavium.com>,
        John Crispin <blogic@openwrt.org>,
        Jayachandran C <jchandra@broadcom.com>,
        Qais Yousef <qais.yousef@imgtec.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonas Gorski <jogo@openwrt.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH v3 3/3] MIPS: Move device-trees to arch/mips/boot/dts
Date: Mon, 15 Sep 2014 10:53:59 -0700
Message-Id: <1410803639-3159-4-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1410803639-3159-1-git-send-email-abrestic@chromium.org>
References: <1410803639-3159-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the MIPS device-trees into appropriate vendor sub-directories under
arch/mips/boot/dts/.  Update the Makefiles and Kconfig files accordingly,
selecting BUILTIN_DTB when necessary.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
Changes from v2:
 - squahsed moving of dts files into a single patch
 - used $(dts-dirs) for descending into vendor subdirs
Changes from v1:
 - added vendor subdirs
---
 arch/mips/Kconfig                                          |  2 ++
 arch/mips/boot/dts/Makefile                                |  6 ++++++
 arch/mips/boot/dts/cavium-octeon/Makefile                  |  9 +++++++++
 arch/mips/{ => boot/dts}/cavium-octeon/octeon_3xxx.dts     |  0
 arch/mips/{ => boot/dts}/cavium-octeon/octeon_68xx.dts     |  0
 arch/mips/boot/dts/lantiq/Makefile                         |  9 +++++++++
 arch/mips/{lantiq/dts => boot/dts/lantiq}/danube.dtsi      |  0
 arch/mips/{lantiq/dts => boot/dts/lantiq}/easy50712.dts    |  0
 arch/mips/boot/dts/mti/Makefile                            |  9 +++++++++
 arch/mips/{mti-sead3 => boot/dts/mti}/sead3.dts            |  0
 arch/mips/boot/dts/netlogic/Makefile                       | 12 ++++++++++++
 arch/mips/{netlogic/dts => boot/dts/netlogic}/xlp_evp.dts  |  0
 arch/mips/{netlogic/dts => boot/dts/netlogic}/xlp_fvp.dts  |  0
 arch/mips/{netlogic/dts => boot/dts/netlogic}/xlp_gvp.dts  |  0
 arch/mips/{netlogic/dts => boot/dts/netlogic}/xlp_svp.dts  |  0
 arch/mips/boot/dts/ralink/Makefile                         | 12 ++++++++++++
 arch/mips/{ralink/dts => boot/dts/ralink}/mt7620a.dtsi     |  0
 arch/mips/{ralink/dts => boot/dts/ralink}/mt7620a_eval.dts |  0
 arch/mips/{ralink/dts => boot/dts/ralink}/rt2880.dtsi      |  0
 arch/mips/{ralink/dts => boot/dts/ralink}/rt2880_eval.dts  |  0
 arch/mips/{ralink/dts => boot/dts/ralink}/rt3050.dtsi      |  0
 arch/mips/{ralink/dts => boot/dts/ralink}/rt3052_eval.dts  |  0
 arch/mips/{ralink/dts => boot/dts/ralink}/rt3883.dtsi      |  0
 arch/mips/{ralink/dts => boot/dts/ralink}/rt3883_eval.dts  |  0
 arch/mips/cavium-octeon/.gitignore                         |  2 --
 arch/mips/cavium-octeon/Makefile                           | 10 ----------
 arch/mips/lantiq/Kconfig                                   |  1 +
 arch/mips/lantiq/Makefile                                  |  2 --
 arch/mips/lantiq/dts/Makefile                              |  1 -
 arch/mips/mti-sead3/Makefile                               |  4 ----
 arch/mips/netlogic/Kconfig                                 |  4 ++++
 arch/mips/netlogic/Makefile                                |  1 -
 arch/mips/netlogic/dts/Makefile                            |  4 ----
 arch/mips/ralink/Kconfig                                   |  4 ++++
 arch/mips/ralink/Makefile                                  |  2 --
 arch/mips/ralink/dts/Makefile                              |  4 ----
 36 files changed, 68 insertions(+), 30 deletions(-)
 create mode 100644 arch/mips/boot/dts/cavium-octeon/Makefile
 rename arch/mips/{ => boot/dts}/cavium-octeon/octeon_3xxx.dts (100%)
 rename arch/mips/{ => boot/dts}/cavium-octeon/octeon_68xx.dts (100%)
 create mode 100644 arch/mips/boot/dts/lantiq/Makefile
 rename arch/mips/{lantiq/dts => boot/dts/lantiq}/danube.dtsi (100%)
 rename arch/mips/{lantiq/dts => boot/dts/lantiq}/easy50712.dts (100%)
 create mode 100644 arch/mips/boot/dts/mti/Makefile
 rename arch/mips/{mti-sead3 => boot/dts/mti}/sead3.dts (100%)
 create mode 100644 arch/mips/boot/dts/netlogic/Makefile
 rename arch/mips/{netlogic/dts => boot/dts/netlogic}/xlp_evp.dts (100%)
 rename arch/mips/{netlogic/dts => boot/dts/netlogic}/xlp_fvp.dts (100%)
 rename arch/mips/{netlogic/dts => boot/dts/netlogic}/xlp_gvp.dts (100%)
 rename arch/mips/{netlogic/dts => boot/dts/netlogic}/xlp_svp.dts (100%)
 create mode 100644 arch/mips/boot/dts/ralink/Makefile
 rename arch/mips/{ralink/dts => boot/dts/ralink}/mt7620a.dtsi (100%)
 rename arch/mips/{ralink/dts => boot/dts/ralink}/mt7620a_eval.dts (100%)
 rename arch/mips/{ralink/dts => boot/dts/ralink}/rt2880.dtsi (100%)
 rename arch/mips/{ralink/dts => boot/dts/ralink}/rt2880_eval.dts (100%)
 rename arch/mips/{ralink/dts => boot/dts/ralink}/rt3050.dtsi (100%)
 rename arch/mips/{ralink/dts => boot/dts/ralink}/rt3052_eval.dts (100%)
 rename arch/mips/{ralink/dts => boot/dts/ralink}/rt3883.dtsi (100%)
 rename arch/mips/{ralink/dts => boot/dts/ralink}/rt3883_eval.dts (100%)
 delete mode 100644 arch/mips/cavium-octeon/.gitignore
 delete mode 100644 arch/mips/lantiq/dts/Makefile
 delete mode 100644 arch/mips/netlogic/dts/Makefile
 delete mode 100644 arch/mips/ralink/dts/Makefile

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index ffa8388..57ee48e 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -353,6 +353,7 @@ config MIPS_SEAD3
 	bool "MIPS SEAD3 board"
 	select BOOT_ELF32
 	select BOOT_RAW
+	select BUILTIN_DTB
 	select CEVT_R4K
 	select CSRC_R4K
 	select CSRC_GIC
@@ -741,6 +742,7 @@ config CAVIUM_OCTEON_SOC
 	select ARCH_SPARSEMEM_ENABLE
 	select SYS_SUPPORTS_SMP
 	select NR_CPUS_DEFAULT_16
+	select BUILTIN_DTB
 	help
 	  This option supports all of the Octeon reference boards from Cavium
 	  Networks. It builds a kernel that dynamically determines the Octeon
diff --git a/arch/mips/boot/dts/Makefile b/arch/mips/boot/dts/Makefile
index 4a78bad..527f71b 100644
--- a/arch/mips/boot/dts/Makefile
+++ b/arch/mips/boot/dts/Makefile
@@ -1,3 +1,9 @@
+dts-dirs	+= cavium-octeon
+dts-dirs	+= lantiq
+dts-dirs	+= mti
+dts-dirs	+= netlogic
+dts-dirs	+= ralink
+
 obj-y		+= $(addsuffix /, $(dts-dirs))
 
 subdir-y	:= $(dts-dirs)
diff --git a/arch/mips/boot/dts/cavium-octeon/Makefile b/arch/mips/boot/dts/cavium-octeon/Makefile
new file mode 100644
index 0000000..f9a57e4
--- /dev/null
+++ b/arch/mips/boot/dts/cavium-octeon/Makefile
@@ -0,0 +1,9 @@
+dtb-$(CONFIG_CAVIUM_OCTEON_SOC)	+= octeon_3xxx.dtb octeon_68xx.dtb
+
+obj-y		+= $(patsubst %.dtb, %.dtb.o, $(dtb-y))
+
+# Force kbuild to make empty built-in.o if necessary
+obj-		+= dummy.o
+
+always		:= $(dtb-y)
+clean-files	:= *.dtb *.dtb.S
diff --git a/arch/mips/cavium-octeon/octeon_3xxx.dts b/arch/mips/boot/dts/cavium-octeon/octeon_3xxx.dts
similarity index 100%
rename from arch/mips/cavium-octeon/octeon_3xxx.dts
rename to arch/mips/boot/dts/cavium-octeon/octeon_3xxx.dts
diff --git a/arch/mips/cavium-octeon/octeon_68xx.dts b/arch/mips/boot/dts/cavium-octeon/octeon_68xx.dts
similarity index 100%
rename from arch/mips/cavium-octeon/octeon_68xx.dts
rename to arch/mips/boot/dts/cavium-octeon/octeon_68xx.dts
diff --git a/arch/mips/boot/dts/lantiq/Makefile b/arch/mips/boot/dts/lantiq/Makefile
new file mode 100644
index 0000000..6162d2d
--- /dev/null
+++ b/arch/mips/boot/dts/lantiq/Makefile
@@ -0,0 +1,9 @@
+dtb-$(CONFIG_DT_EASY50712)	+= easy50712.dtb
+
+obj-y		+= $(patsubst %.dtb, %.dtb.o, $(dtb-y))
+
+# Force kbuild to make empty built-in.o if necessary
+obj-		+= dummy.o
+
+always		:= $(dtb-y)
+clean-files	:= *.dtb *.dtb.S
diff --git a/arch/mips/lantiq/dts/danube.dtsi b/arch/mips/boot/dts/lantiq/danube.dtsi
similarity index 100%
rename from arch/mips/lantiq/dts/danube.dtsi
rename to arch/mips/boot/dts/lantiq/danube.dtsi
diff --git a/arch/mips/lantiq/dts/easy50712.dts b/arch/mips/boot/dts/lantiq/easy50712.dts
similarity index 100%
rename from arch/mips/lantiq/dts/easy50712.dts
rename to arch/mips/boot/dts/lantiq/easy50712.dts
diff --git a/arch/mips/boot/dts/mti/Makefile b/arch/mips/boot/dts/mti/Makefile
new file mode 100644
index 0000000..abc024d
--- /dev/null
+++ b/arch/mips/boot/dts/mti/Makefile
@@ -0,0 +1,9 @@
+dtb-$(CONFIG_MIPS_SEAD3)	+= sead3.dtb
+
+obj-y		+= $(patsubst %.dtb, %.dtb.o, $(dtb-y))
+
+# Force kbuild to make empty built-in.o if necessary
+obj-		+= dummy.o
+
+always		:= $(dtb-y)
+clean-files	:= *.dtb *.dtb.S
diff --git a/arch/mips/mti-sead3/sead3.dts b/arch/mips/boot/dts/mti/sead3.dts
similarity index 100%
rename from arch/mips/mti-sead3/sead3.dts
rename to arch/mips/boot/dts/mti/sead3.dts
diff --git a/arch/mips/boot/dts/netlogic/Makefile b/arch/mips/boot/dts/netlogic/Makefile
new file mode 100644
index 0000000..e53ce4a
--- /dev/null
+++ b/arch/mips/boot/dts/netlogic/Makefile
@@ -0,0 +1,12 @@
+dtb-$(CONFIG_DT_XLP_EVP)	+= xlp_evp.dtb
+dtb-$(CONFIG_DT_XLP_SVP)	+= xlp_svp.dtb
+dtb-$(CONFIG_DT_XLP_FVP)	+= xlp_fvp.dtb
+dtb-$(CONFIG_DT_XLP_GVP)	+= xlp_gvp.dtb
+
+obj-y		+= $(patsubst %.dtb, %.dtb.o, $(dtb-y))
+
+# Force kbuild to make empty built-in.o if necessary
+obj-		+= dummy.o
+
+always		:= $(dtb-y)
+clean-files	:= *.dtb *.dtb.S
diff --git a/arch/mips/netlogic/dts/xlp_evp.dts b/arch/mips/boot/dts/netlogic/xlp_evp.dts
similarity index 100%
rename from arch/mips/netlogic/dts/xlp_evp.dts
rename to arch/mips/boot/dts/netlogic/xlp_evp.dts
diff --git a/arch/mips/netlogic/dts/xlp_fvp.dts b/arch/mips/boot/dts/netlogic/xlp_fvp.dts
similarity index 100%
rename from arch/mips/netlogic/dts/xlp_fvp.dts
rename to arch/mips/boot/dts/netlogic/xlp_fvp.dts
diff --git a/arch/mips/netlogic/dts/xlp_gvp.dts b/arch/mips/boot/dts/netlogic/xlp_gvp.dts
similarity index 100%
rename from arch/mips/netlogic/dts/xlp_gvp.dts
rename to arch/mips/boot/dts/netlogic/xlp_gvp.dts
diff --git a/arch/mips/netlogic/dts/xlp_svp.dts b/arch/mips/boot/dts/netlogic/xlp_svp.dts
similarity index 100%
rename from arch/mips/netlogic/dts/xlp_svp.dts
rename to arch/mips/boot/dts/netlogic/xlp_svp.dts
diff --git a/arch/mips/boot/dts/ralink/Makefile b/arch/mips/boot/dts/ralink/Makefile
new file mode 100644
index 0000000..1119fa5
--- /dev/null
+++ b/arch/mips/boot/dts/ralink/Makefile
@@ -0,0 +1,12 @@
+dtb-$(CONFIG_DTB_RT2880_EVAL)	+= rt2880_eval.dtb
+dtb-$(CONFIG_DTB_RT305X_EVAL)	+= rt3052_eval.dtb
+dtb-$(CONFIG_DTB_RT3883_EVAL)	+= rt3883_eval.dtb
+dtb-$(CONFIG_DTB_MT7620A_EVAL)	+= mt7620a_eval.dtb
+
+obj-y		+= $(patsubst %.dtb, %.dtb.o, $(dtb-y))
+
+# Force kbuild to make empty built-in.o if necessary
+obj-		+= dummy.o
+
+always		:= $(dtb-y)
+clean-files	:= *.dtb *.dtb.S
diff --git a/arch/mips/ralink/dts/mt7620a.dtsi b/arch/mips/boot/dts/ralink/mt7620a.dtsi
similarity index 100%
rename from arch/mips/ralink/dts/mt7620a.dtsi
rename to arch/mips/boot/dts/ralink/mt7620a.dtsi
diff --git a/arch/mips/ralink/dts/mt7620a_eval.dts b/arch/mips/boot/dts/ralink/mt7620a_eval.dts
similarity index 100%
rename from arch/mips/ralink/dts/mt7620a_eval.dts
rename to arch/mips/boot/dts/ralink/mt7620a_eval.dts
diff --git a/arch/mips/ralink/dts/rt2880.dtsi b/arch/mips/boot/dts/ralink/rt2880.dtsi
similarity index 100%
rename from arch/mips/ralink/dts/rt2880.dtsi
rename to arch/mips/boot/dts/ralink/rt2880.dtsi
diff --git a/arch/mips/ralink/dts/rt2880_eval.dts b/arch/mips/boot/dts/ralink/rt2880_eval.dts
similarity index 100%
rename from arch/mips/ralink/dts/rt2880_eval.dts
rename to arch/mips/boot/dts/ralink/rt2880_eval.dts
diff --git a/arch/mips/ralink/dts/rt3050.dtsi b/arch/mips/boot/dts/ralink/rt3050.dtsi
similarity index 100%
rename from arch/mips/ralink/dts/rt3050.dtsi
rename to arch/mips/boot/dts/ralink/rt3050.dtsi
diff --git a/arch/mips/ralink/dts/rt3052_eval.dts b/arch/mips/boot/dts/ralink/rt3052_eval.dts
similarity index 100%
rename from arch/mips/ralink/dts/rt3052_eval.dts
rename to arch/mips/boot/dts/ralink/rt3052_eval.dts
diff --git a/arch/mips/ralink/dts/rt3883.dtsi b/arch/mips/boot/dts/ralink/rt3883.dtsi
similarity index 100%
rename from arch/mips/ralink/dts/rt3883.dtsi
rename to arch/mips/boot/dts/ralink/rt3883.dtsi
diff --git a/arch/mips/ralink/dts/rt3883_eval.dts b/arch/mips/boot/dts/ralink/rt3883_eval.dts
similarity index 100%
rename from arch/mips/ralink/dts/rt3883_eval.dts
rename to arch/mips/boot/dts/ralink/rt3883_eval.dts
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
diff --git a/arch/mips/lantiq/Kconfig b/arch/mips/lantiq/Kconfig
index c002191..e10d333 100644
--- a/arch/mips/lantiq/Kconfig
+++ b/arch/mips/lantiq/Kconfig
@@ -30,6 +30,7 @@ choice
 config DT_EASY50712
 	bool "Easy50712"
 	depends on SOC_XWAY
+	select BUILTIN_DTB
 endchoice
 
 config PCI_LANTIQ
diff --git a/arch/mips/lantiq/Makefile b/arch/mips/lantiq/Makefile
index d6bdc57..690257a 100644
--- a/arch/mips/lantiq/Makefile
+++ b/arch/mips/lantiq/Makefile
@@ -6,8 +6,6 @@
 
 obj-y := irq.o clk.o prom.o
 
-obj-y += dts/
-
 obj-$(CONFIG_EARLY_PRINTK) += early_printk.o
 
 obj-$(CONFIG_SOC_TYPE_XWAY) += xway/
diff --git a/arch/mips/lantiq/dts/Makefile b/arch/mips/lantiq/dts/Makefile
deleted file mode 100644
index 6fa72dd..0000000
--- a/arch/mips/lantiq/dts/Makefile
+++ /dev/null
@@ -1 +0,0 @@
-obj-$(CONFIG_DT_EASY50712) := easy50712.dtb.o
diff --git a/arch/mips/mti-sead3/Makefile b/arch/mips/mti-sead3/Makefile
index 071786f..febf433 100644
--- a/arch/mips/mti-sead3/Makefile
+++ b/arch/mips/mti-sead3/Makefile
@@ -19,9 +19,5 @@ obj-y				+= sead3-i2c-dev.o sead3-i2c.o \
 
 obj-$(CONFIG_EARLY_PRINTK)	+= sead3-console.o
 obj-$(CONFIG_USB_EHCI_HCD)	+= sead3-ehci.o
-obj-$(CONFIG_OF)		+= sead3.dtb.o
 
 CFLAGS_sead3-setup.o = -I$(src)/../../../scripts/dtc/libfdt
-
-$(obj)/%.dtb: $(obj)/%.dts
-	$(call if_changed,dtc)
diff --git a/arch/mips/netlogic/Kconfig b/arch/mips/netlogic/Kconfig
index 4eb683a..0823321 100644
--- a/arch/mips/netlogic/Kconfig
+++ b/arch/mips/netlogic/Kconfig
@@ -4,6 +4,7 @@ if NLM_XLP_BOARD
 config DT_XLP_EVP
 	bool "Built-in device tree for XLP EVP boards"
 	default y
+	select BUILTIN_DTB
 	help
 	  Add an FDT blob for XLP EVP boards into the kernel.
 	  This DTB will be used if the firmware does not pass in a DTB
@@ -13,6 +14,7 @@ config DT_XLP_EVP
 config DT_XLP_SVP
 	bool "Built-in device tree for XLP SVP boards"
 	default y
+	select BUILTIN_DTB
 	help
 	  Add an FDT blob for XLP VP boards into the kernel.
 	  This DTB will be used if the firmware does not pass in a DTB
@@ -22,6 +24,7 @@ config DT_XLP_SVP
 config DT_XLP_FVP
 	bool "Built-in device tree for XLP FVP boards"
 	default y
+	select BUILTIN_DTB
 	help
 	  Add an FDT blob for XLP FVP board into the kernel.
 	  This DTB will be used if the firmware does not pass in a DTB
@@ -31,6 +34,7 @@ config DT_XLP_FVP
 config DT_XLP_GVP
 	bool "Built-in device tree for XLP GVP boards"
 	default y
+	select BUILTIN_DTB
 	help
 	  Add an FDT blob for XLP GVP board into the kernel.
 	  This DTB will be used if the firmware does not pass in a DTB
diff --git a/arch/mips/netlogic/Makefile b/arch/mips/netlogic/Makefile
index 7602d13..36d169b 100644
--- a/arch/mips/netlogic/Makefile
+++ b/arch/mips/netlogic/Makefile
@@ -1,4 +1,3 @@
 obj-$(CONFIG_NLM_COMMON)	+=	common/
 obj-$(CONFIG_CPU_XLR)		+=	xlr/
 obj-$(CONFIG_CPU_XLP)		+=	xlp/
-obj-$(CONFIG_CPU_XLP)		+=	dts/
diff --git a/arch/mips/netlogic/dts/Makefile b/arch/mips/netlogic/dts/Makefile
deleted file mode 100644
index 25c8e87..0000000
--- a/arch/mips/netlogic/dts/Makefile
+++ /dev/null
@@ -1,4 +0,0 @@
-obj-$(CONFIG_DT_XLP_EVP) := xlp_evp.dtb.o
-obj-$(CONFIG_DT_XLP_SVP) += xlp_svp.dtb.o
-obj-$(CONFIG_DT_XLP_FVP) += xlp_fvp.dtb.o
-obj-$(CONFIG_DT_XLP_GVP) += xlp_gvp.dtb.o
diff --git a/arch/mips/ralink/Kconfig b/arch/mips/ralink/Kconfig
index 4a29665..77e8a96 100644
--- a/arch/mips/ralink/Kconfig
+++ b/arch/mips/ralink/Kconfig
@@ -42,18 +42,22 @@ choice
 	config DTB_RT2880_EVAL
 		bool "RT2880 eval kit"
 		depends on SOC_RT288X
+		select BUILTIN_DTB
 
 	config DTB_RT305X_EVAL
 		bool "RT305x eval kit"
 		depends on SOC_RT305X
+		select BUILTIN_DTB
 
 	config DTB_RT3883_EVAL
 		bool "RT3883 eval kit"
 		depends on SOC_RT3883
+		select BUILTIN_DTB
 
 	config DTB_MT7620A_EVAL
 		bool "MT7620A eval kit"
 		depends on SOC_MT7620
+		select BUILTIN_DTB
 
 endchoice
 
diff --git a/arch/mips/ralink/Makefile b/arch/mips/ralink/Makefile
index 98ae349..2c09c8a 100644
--- a/arch/mips/ralink/Makefile
+++ b/arch/mips/ralink/Makefile
@@ -16,5 +16,3 @@ obj-$(CONFIG_SOC_RT3883) += rt3883.o
 obj-$(CONFIG_SOC_MT7620) += mt7620.o
 
 obj-$(CONFIG_EARLY_PRINTK) += early_printk.o
-
-obj-y += dts/
diff --git a/arch/mips/ralink/dts/Makefile b/arch/mips/ralink/dts/Makefile
deleted file mode 100644
index 18194fa..0000000
--- a/arch/mips/ralink/dts/Makefile
+++ /dev/null
@@ -1,4 +0,0 @@
-obj-$(CONFIG_DTB_RT2880_EVAL) := rt2880_eval.dtb.o
-obj-$(CONFIG_DTB_RT305X_EVAL) := rt3052_eval.dtb.o
-obj-$(CONFIG_DTB_RT3883_EVAL) := rt3883_eval.dtb.o
-obj-$(CONFIG_DTB_MT7620A_EVAL) := mt7620a_eval.dtb.o
-- 
2.1.0.rc2.206.gedb03e5

