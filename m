Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbaH2NaK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 09:30:10 -0400
Received: from mail-pd0-f202.google.com ([209.85.192.202]:35593 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbaH2NaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 09:30:05 -0400
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
Subject: [PATCH v2 7/7] MIPS: ralink: Move device-trees to arch/mips/boot/dts/ralink/
Date: Thu, 28 Aug 2014 20:56:59 -0700
Message-Id: <1409284619-6910-1-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1409191812-23697-1-git-send-email-abrestic@chromium.org>
References: <1409191812-23697-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the Ralink device-trees to arch/mips/boot/dts/ralink/ and update
the Makefiles accordingly.  A built-in device-tree is optional, so
select BUILTIN_DTB when it is requested.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
Looks like this one didn't make it through the first time.
---
 arch/mips/boot/dts/Makefile                                | 1 +
 arch/mips/boot/dts/ralink/Makefile                         | 4 ++++
 arch/mips/{ralink/dts => boot/dts/ralink}/mt7620a.dtsi     | 0
 arch/mips/{ralink/dts => boot/dts/ralink}/mt7620a_eval.dts | 0
 arch/mips/{ralink/dts => boot/dts/ralink}/rt2880.dtsi      | 0
 arch/mips/{ralink/dts => boot/dts/ralink}/rt2880_eval.dts  | 0
 arch/mips/{ralink/dts => boot/dts/ralink}/rt3050.dtsi      | 0
 arch/mips/{ralink/dts => boot/dts/ralink}/rt3052_eval.dts  | 0
 arch/mips/{ralink/dts => boot/dts/ralink}/rt3883.dtsi      | 0
 arch/mips/{ralink/dts => boot/dts/ralink}/rt3883_eval.dts  | 0
 arch/mips/ralink/Kconfig                                   | 4 ++++
 arch/mips/ralink/Makefile                                  | 2 --
 arch/mips/ralink/dts/Makefile                              | 4 ----
 13 files changed, 9 insertions(+), 6 deletions(-)
 create mode 100644 arch/mips/boot/dts/ralink/Makefile
 rename arch/mips/{ralink/dts => boot/dts/ralink}/mt7620a.dtsi (100%)
 rename arch/mips/{ralink/dts => boot/dts/ralink}/mt7620a_eval.dts (100%)
 rename arch/mips/{ralink/dts => boot/dts/ralink}/rt2880.dtsi (100%)
 rename arch/mips/{ralink/dts => boot/dts/ralink}/rt2880_eval.dts (100%)
 rename arch/mips/{ralink/dts => boot/dts/ralink}/rt3050.dtsi (100%)
 rename arch/mips/{ralink/dts => boot/dts/ralink}/rt3052_eval.dts (100%)
 rename arch/mips/{ralink/dts => boot/dts/ralink}/rt3883.dtsi (100%)
 rename arch/mips/{ralink/dts => boot/dts/ralink}/rt3883_eval.dts (100%)
 delete mode 100644 arch/mips/ralink/dts/Makefile

diff --git a/arch/mips/boot/dts/Makefile b/arch/mips/boot/dts/Makefile
index a861be5..47406f7 100644
--- a/arch/mips/boot/dts/Makefile
+++ b/arch/mips/boot/dts/Makefile
@@ -2,6 +2,7 @@ include arch/mips/boot/dts/cavium-octeon/Makefile
 include arch/mips/boot/dts/lantiq/Makefile
 include arch/mips/boot/dts/mti/Makefile
 include arch/mips/boot/dts/netlogic/Makefile
+include arch/mips/boot/dts/ralink/Makefile
 
 obj-y		+= $(patsubst %.dtb, %.dtb.o, $(dtb-y))
 
diff --git a/arch/mips/boot/dts/ralink/Makefile b/arch/mips/boot/dts/ralink/Makefile
new file mode 100644
index 0000000..81a567e
--- /dev/null
+++ b/arch/mips/boot/dts/ralink/Makefile
@@ -0,0 +1,4 @@
+dtb-$(CONFIG_DTB_RT2880_EVAL)	+= ralink/rt2880_eval.dtb
+dtb-$(CONFIG_DTB_RT305X_EVAL)	+= ralink/rt3052_eval.dtb
+dtb-$(CONFIG_DTB_RT3883_EVAL)	+= ralink/rt3883_eval.dtb
+dtb-$(CONFIG_DTB_MT7620A_EVAL)	+= ralink/mt7620a_eval.dtb
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

