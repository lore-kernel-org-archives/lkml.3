Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbaLYR5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 12:57:22 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:50439 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbaLYR5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 12:57:03 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: ralf@linux-mips.org
Cc: f.fainelli@gmail.com, jaedon.shin@gmail.com, abrestic@chromium.org,
        tglx@linutronix.de, jason@lakedaemon.net, jogo@openwrt.org,
        arnd@arndb.de, computersforpeace@gmail.com, linux-mips@linux-mips.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V6 02/25] MIPS: Move device-trees into vendor sub-directories
Date: Thu, 25 Dec 2014 09:48:57 -0800
Message-Id: <1419529760-9520-3-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1419529760-9520-1-git-send-email-cernekee@gmail.com>
References: <1419529760-9520-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Bresticker <abrestic@chromium.org>

Move the MIPS device-trees into the appropriate vendor sub-directories.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
Tested-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/mips/Makefile                                 |  2 +-
 arch/mips/boot/dts/Makefile                        | 33 ++++++++--------------
 arch/mips/boot/dts/brcm/Makefile                   |  9 ++++++
 arch/mips/boot/dts/{ => brcm}/bcm3384.dtsi         |  0
 arch/mips/boot/dts/{ => brcm}/bcm93384wvg.dts      |  0
 arch/mips/boot/dts/cavium-octeon/Makefile          |  9 ++++++
 .../boot/dts/{ => cavium-octeon}/octeon_3xxx.dts   |  0
 .../boot/dts/{ => cavium-octeon}/octeon_68xx.dts   |  0
 arch/mips/boot/dts/lantiq/Makefile                 |  9 ++++++
 arch/mips/boot/dts/{ => lantiq}/danube.dtsi        |  0
 arch/mips/boot/dts/{ => lantiq}/easy50712.dts      |  0
 arch/mips/boot/dts/mti/Makefile                    |  9 ++++++
 arch/mips/boot/dts/{ => mti}/sead3.dts             |  0
 arch/mips/boot/dts/netlogic/Makefile               | 12 ++++++++
 arch/mips/boot/dts/{ => netlogic}/xlp_evp.dts      |  0
 arch/mips/boot/dts/{ => netlogic}/xlp_fvp.dts      |  0
 arch/mips/boot/dts/{ => netlogic}/xlp_gvp.dts      |  0
 arch/mips/boot/dts/{ => netlogic}/xlp_svp.dts      |  0
 arch/mips/boot/dts/ralink/Makefile                 | 12 ++++++++
 arch/mips/boot/dts/{ => ralink}/mt7620a.dtsi       |  0
 arch/mips/boot/dts/{ => ralink}/mt7620a_eval.dts   |  0
 arch/mips/boot/dts/{ => ralink}/rt2880.dtsi        |  0
 arch/mips/boot/dts/{ => ralink}/rt2880_eval.dts    |  0
 arch/mips/boot/dts/{ => ralink}/rt3050.dtsi        |  0
 arch/mips/boot/dts/{ => ralink}/rt3052_eval.dts    |  0
 arch/mips/boot/dts/{ => ralink}/rt3883.dtsi        |  0
 arch/mips/boot/dts/{ => ralink}/rt3883_eval.dts    |  0
 27 files changed, 73 insertions(+), 22 deletions(-)
 create mode 100644 arch/mips/boot/dts/brcm/Makefile
 rename arch/mips/boot/dts/{ => brcm}/bcm3384.dtsi (100%)
 rename arch/mips/boot/dts/{ => brcm}/bcm93384wvg.dts (100%)
 create mode 100644 arch/mips/boot/dts/cavium-octeon/Makefile
 rename arch/mips/boot/dts/{ => cavium-octeon}/octeon_3xxx.dts (100%)
 rename arch/mips/boot/dts/{ => cavium-octeon}/octeon_68xx.dts (100%)
 create mode 100644 arch/mips/boot/dts/lantiq/Makefile
 rename arch/mips/boot/dts/{ => lantiq}/danube.dtsi (100%)
 rename arch/mips/boot/dts/{ => lantiq}/easy50712.dts (100%)
 create mode 100644 arch/mips/boot/dts/mti/Makefile
 rename arch/mips/boot/dts/{ => mti}/sead3.dts (100%)
 create mode 100644 arch/mips/boot/dts/netlogic/Makefile
 rename arch/mips/boot/dts/{ => netlogic}/xlp_evp.dts (100%)
 rename arch/mips/boot/dts/{ => netlogic}/xlp_fvp.dts (100%)
 rename arch/mips/boot/dts/{ => netlogic}/xlp_gvp.dts (100%)
 rename arch/mips/boot/dts/{ => netlogic}/xlp_svp.dts (100%)
 create mode 100644 arch/mips/boot/dts/ralink/Makefile
 rename arch/mips/boot/dts/{ => ralink}/mt7620a.dtsi (100%)
 rename arch/mips/boot/dts/{ => ralink}/mt7620a_eval.dts (100%)
 rename arch/mips/boot/dts/{ => ralink}/rt2880.dtsi (100%)
 rename arch/mips/boot/dts/{ => ralink}/rt2880_eval.dts (100%)
 rename arch/mips/boot/dts/{ => ralink}/rt3050.dtsi (100%)
 rename arch/mips/boot/dts/{ => ralink}/rt3052_eval.dts (100%)
 rename arch/mips/boot/dts/{ => ralink}/rt3883.dtsi (100%)
 rename arch/mips/boot/dts/{ => ralink}/rt3883_eval.dts (100%)

diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index 2563a08..269db7e 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -350,7 +350,7 @@ core-$(CONFIG_BUILTIN_DTB) += arch/mips/boot/dts/
 
 PHONY += dtbs
 dtbs: scripts
-	$(Q)$(MAKE) $(build)=arch/mips/boot/dts dtbs
+	$(Q)$(MAKE) $(build)=arch/mips/boot/dts
 
 archprepare:
 ifdef CONFIG_MIPS32_N32
diff --git a/arch/mips/boot/dts/Makefile b/arch/mips/boot/dts/Makefile
index 4f49fa4..5d95e4b 100644
--- a/arch/mips/boot/dts/Makefile
+++ b/arch/mips/boot/dts/Makefile
@@ -1,21 +1,12 @@
-dtb-$(CONFIG_BCM3384)			+= bcm93384wvg.dtb
-dtb-$(CONFIG_CAVIUM_OCTEON_SOC)		+= octeon_3xxx.dtb octeon_68xx.dtb
-dtb-$(CONFIG_DT_EASY50712)		+= easy50712.dtb
-dtb-$(CONFIG_DT_XLP_EVP)		+= xlp_evp.dtb
-dtb-$(CONFIG_DT_XLP_SVP)		+= xlp_svp.dtb
-dtb-$(CONFIG_DT_XLP_FVP)		+= xlp_fvp.dtb
-dtb-$(CONFIG_DT_XLP_GVP)		+= xlp_gvp.dtb
-dtb-$(CONFIG_DTB_RT2880_EVAL)		+= rt2880_eval.dtb
-dtb-$(CONFIG_DTB_RT305X_EVAL)		+= rt3052_eval.dtb
-dtb-$(CONFIG_DTB_RT3883_EVAL)		+= rt3883_eval.dtb
-dtb-$(CONFIG_DTB_MT7620A_EVAL)		+= mt7620a_eval.dtb
-dtb-$(CONFIG_MIPS_SEAD3)		+= sead3.dtb
-
-obj-y		+= $(patsubst %.dtb, %.dtb.o, $(dtb-y))
-
-targets		+= dtbs
-targets		+= $(dtb-y)
-
-dtbs: $(addprefix $(obj)/, $(dtb-y))
-
-clean-files	+= *.dtb *.dtb.S
+dts-dirs	+= brcm
+dts-dirs	+= cavium-octeon
+dts-dirs	+= lantiq
+dts-dirs	+= mti
+dts-dirs	+= netlogic
+dts-dirs	+= ralink
+
+obj-y		:= $(addsuffix /, $(dts-dirs))
+
+always		:= $(dtb-y)
+subdir-y	:= $(dts-dirs)
+clean-files	:= *.dtb *.dtb.S
diff --git a/arch/mips/boot/dts/brcm/Makefile b/arch/mips/boot/dts/brcm/Makefile
new file mode 100644
index 0000000..a353d4e
--- /dev/null
+++ b/arch/mips/boot/dts/brcm/Makefile
@@ -0,0 +1,9 @@
+dtb-$(CONFIG_BCM3384)		+= bcm93384wvg.dtb
+
+obj-y				+= $(patsubst %.dtb, %.dtb.o, $(dtb-y))
+
+# Force kbuild to make empty built-in.o if necessary
+obj-				+= dummy.o
+
+always				:= $(dtb-y)
+clean-files			:= *.dtb *.dtb.S
diff --git a/arch/mips/boot/dts/bcm3384.dtsi b/arch/mips/boot/dts/brcm/bcm3384.dtsi
similarity index 100%
rename from arch/mips/boot/dts/bcm3384.dtsi
rename to arch/mips/boot/dts/brcm/bcm3384.dtsi
diff --git a/arch/mips/boot/dts/bcm93384wvg.dts b/arch/mips/boot/dts/brcm/bcm93384wvg.dts
similarity index 100%
rename from arch/mips/boot/dts/bcm93384wvg.dts
rename to arch/mips/boot/dts/brcm/bcm93384wvg.dts
diff --git a/arch/mips/boot/dts/cavium-octeon/Makefile b/arch/mips/boot/dts/cavium-octeon/Makefile
new file mode 100644
index 0000000..5b99c40
--- /dev/null
+++ b/arch/mips/boot/dts/cavium-octeon/Makefile
@@ -0,0 +1,9 @@
+dtb-$(CONFIG_CAVIUM_OCTEON_SOC)	+= octeon_3xxx.dtb octeon_68xx.dtb
+
+obj-y				+= $(patsubst %.dtb, %.dtb.o, $(dtb-y))
+
+# Force kbuild to make empty built-in.o if necessary
+obj-				+= dummy.o
+
+always				:= $(dtb-y)
+clean-files			:= *.dtb *.dtb.S
diff --git a/arch/mips/boot/dts/octeon_3xxx.dts b/arch/mips/boot/dts/cavium-octeon/octeon_3xxx.dts
similarity index 100%
rename from arch/mips/boot/dts/octeon_3xxx.dts
rename to arch/mips/boot/dts/cavium-octeon/octeon_3xxx.dts
diff --git a/arch/mips/boot/dts/octeon_68xx.dts b/arch/mips/boot/dts/cavium-octeon/octeon_68xx.dts
similarity index 100%
rename from arch/mips/boot/dts/octeon_68xx.dts
rename to arch/mips/boot/dts/cavium-octeon/octeon_68xx.dts
diff --git a/arch/mips/boot/dts/lantiq/Makefile b/arch/mips/boot/dts/lantiq/Makefile
new file mode 100644
index 0000000..0906c62
--- /dev/null
+++ b/arch/mips/boot/dts/lantiq/Makefile
@@ -0,0 +1,9 @@
+dtb-$(CONFIG_DT_EASY50712)	+= easy50712.dtb
+
+obj-y				+= $(patsubst %.dtb, %.dtb.o, $(dtb-y))
+
+# Force kbuild to make empty built-in.o if necessary
+obj-				+= dummy.o
+
+always				:= $(dtb-y)
+clean-files			:= *.dtb *.dtb.S
diff --git a/arch/mips/boot/dts/danube.dtsi b/arch/mips/boot/dts/lantiq/danube.dtsi
similarity index 100%
rename from arch/mips/boot/dts/danube.dtsi
rename to arch/mips/boot/dts/lantiq/danube.dtsi
diff --git a/arch/mips/boot/dts/easy50712.dts b/arch/mips/boot/dts/lantiq/easy50712.dts
similarity index 100%
rename from arch/mips/boot/dts/easy50712.dts
rename to arch/mips/boot/dts/lantiq/easy50712.dts
diff --git a/arch/mips/boot/dts/mti/Makefile b/arch/mips/boot/dts/mti/Makefile
new file mode 100644
index 0000000..ef1f3db
--- /dev/null
+++ b/arch/mips/boot/dts/mti/Makefile
@@ -0,0 +1,9 @@
+dtb-$(CONFIG_MIPS_SEAD3)	+= sead3.dtb
+
+obj-y				+= $(patsubst %.dtb, %.dtb.o, $(dtb-y))
+
+# Force kbuild to make empty built-in.o if necessary
+obj-				+= dummy.o
+
+always				:= $(dtb-y)
+clean-files			:= *.dtb *.dtb.S
diff --git a/arch/mips/boot/dts/sead3.dts b/arch/mips/boot/dts/mti/sead3.dts
similarity index 100%
rename from arch/mips/boot/dts/sead3.dts
rename to arch/mips/boot/dts/mti/sead3.dts
diff --git a/arch/mips/boot/dts/netlogic/Makefile b/arch/mips/boot/dts/netlogic/Makefile
new file mode 100644
index 0000000..e126cd3
--- /dev/null
+++ b/arch/mips/boot/dts/netlogic/Makefile
@@ -0,0 +1,12 @@
+dtb-$(CONFIG_DT_XLP_EVP)	+= xlp_evp.dtb
+dtb-$(CONFIG_DT_XLP_SVP)	+= xlp_svp.dtb
+dtb-$(CONFIG_DT_XLP_FVP)	+= xlp_fvp.dtb
+dtb-$(CONFIG_DT_XLP_GVP)	+= xlp_gvp.dtb
+
+obj-y				+= $(patsubst %.dtb, %.dtb.o, $(dtb-y))
+
+# Force kbuild to make empty built-in.o if necessary
+obj-				+= dummy.o
+
+always				:= $(dtb-y)
+clean-files			:= *.dtb *.dtb.S
diff --git a/arch/mips/boot/dts/xlp_evp.dts b/arch/mips/boot/dts/netlogic/xlp_evp.dts
similarity index 100%
rename from arch/mips/boot/dts/xlp_evp.dts
rename to arch/mips/boot/dts/netlogic/xlp_evp.dts
diff --git a/arch/mips/boot/dts/xlp_fvp.dts b/arch/mips/boot/dts/netlogic/xlp_fvp.dts
similarity index 100%
rename from arch/mips/boot/dts/xlp_fvp.dts
rename to arch/mips/boot/dts/netlogic/xlp_fvp.dts
diff --git a/arch/mips/boot/dts/xlp_gvp.dts b/arch/mips/boot/dts/netlogic/xlp_gvp.dts
similarity index 100%
rename from arch/mips/boot/dts/xlp_gvp.dts
rename to arch/mips/boot/dts/netlogic/xlp_gvp.dts
diff --git a/arch/mips/boot/dts/xlp_svp.dts b/arch/mips/boot/dts/netlogic/xlp_svp.dts
similarity index 100%
rename from arch/mips/boot/dts/xlp_svp.dts
rename to arch/mips/boot/dts/netlogic/xlp_svp.dts
diff --git a/arch/mips/boot/dts/ralink/Makefile b/arch/mips/boot/dts/ralink/Makefile
new file mode 100644
index 0000000..2a72259
--- /dev/null
+++ b/arch/mips/boot/dts/ralink/Makefile
@@ -0,0 +1,12 @@
+dtb-$(CONFIG_DTB_RT2880_EVAL)	+= rt2880_eval.dtb
+dtb-$(CONFIG_DTB_RT305X_EVAL)	+= rt3052_eval.dtb
+dtb-$(CONFIG_DTB_RT3883_EVAL)	+= rt3883_eval.dtb
+dtb-$(CONFIG_DTB_MT7620A_EVAL)	+= mt7620a_eval.dtb
+
+obj-y				+= $(patsubst %.dtb, %.dtb.o, $(dtb-y))
+
+# Force kbuild to make empty built-in.o if necessary
+obj-				+= dummy.o
+
+always				:= $(dtb-y)
+clean-files			:= *.dtb *.dtb.S
diff --git a/arch/mips/boot/dts/mt7620a.dtsi b/arch/mips/boot/dts/ralink/mt7620a.dtsi
similarity index 100%
rename from arch/mips/boot/dts/mt7620a.dtsi
rename to arch/mips/boot/dts/ralink/mt7620a.dtsi
diff --git a/arch/mips/boot/dts/mt7620a_eval.dts b/arch/mips/boot/dts/ralink/mt7620a_eval.dts
similarity index 100%
rename from arch/mips/boot/dts/mt7620a_eval.dts
rename to arch/mips/boot/dts/ralink/mt7620a_eval.dts
diff --git a/arch/mips/boot/dts/rt2880.dtsi b/arch/mips/boot/dts/ralink/rt2880.dtsi
similarity index 100%
rename from arch/mips/boot/dts/rt2880.dtsi
rename to arch/mips/boot/dts/ralink/rt2880.dtsi
diff --git a/arch/mips/boot/dts/rt2880_eval.dts b/arch/mips/boot/dts/ralink/rt2880_eval.dts
similarity index 100%
rename from arch/mips/boot/dts/rt2880_eval.dts
rename to arch/mips/boot/dts/ralink/rt2880_eval.dts
diff --git a/arch/mips/boot/dts/rt3050.dtsi b/arch/mips/boot/dts/ralink/rt3050.dtsi
similarity index 100%
rename from arch/mips/boot/dts/rt3050.dtsi
rename to arch/mips/boot/dts/ralink/rt3050.dtsi
diff --git a/arch/mips/boot/dts/rt3052_eval.dts b/arch/mips/boot/dts/ralink/rt3052_eval.dts
similarity index 100%
rename from arch/mips/boot/dts/rt3052_eval.dts
rename to arch/mips/boot/dts/ralink/rt3052_eval.dts
diff --git a/arch/mips/boot/dts/rt3883.dtsi b/arch/mips/boot/dts/ralink/rt3883.dtsi
similarity index 100%
rename from arch/mips/boot/dts/rt3883.dtsi
rename to arch/mips/boot/dts/ralink/rt3883.dtsi
diff --git a/arch/mips/boot/dts/rt3883_eval.dts b/arch/mips/boot/dts/ralink/rt3883_eval.dts
similarity index 100%
rename from arch/mips/boot/dts/rt3883_eval.dts
rename to arch/mips/boot/dts/ralink/rt3883_eval.dts
-- 
2.1.1

