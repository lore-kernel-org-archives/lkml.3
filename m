Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936163AbaH1DQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 23:16:23 -0400
Received: from mail-qc0-f202.google.com ([209.85.216.202]:52425 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934196AbaH1DQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 23:16:08 -0400
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
Subject: [PATCH v2 6/7] MIPS: Netlogic: Move device-trees to arch/mips/boot/dts/netlogic/
Date: Wed, 27 Aug 2014 19:10:11 -0700
Message-Id: <1409191812-23697-7-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1409191812-23697-1-git-send-email-abrestic@chromium.org>
References: <1409191812-23697-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the Netlogic XLP device-trees to arch/mips/boot/dts/netlogic/ and
update the Makefiles accordingly.  A built-in device-tree is optional,
so select BUILTIN_DTB when it is requested.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 arch/mips/boot/dts/Makefile                               | 1 +
 arch/mips/boot/dts/netlogic/Makefile                      | 4 ++++
 arch/mips/{netlogic/dts => boot/dts/netlogic}/xlp_evp.dts | 0
 arch/mips/{netlogic/dts => boot/dts/netlogic}/xlp_fvp.dts | 0
 arch/mips/{netlogic/dts => boot/dts/netlogic}/xlp_gvp.dts | 0
 arch/mips/{netlogic/dts => boot/dts/netlogic}/xlp_svp.dts | 0
 arch/mips/netlogic/Kconfig                                | 4 ++++
 arch/mips/netlogic/Makefile                               | 1 -
 arch/mips/netlogic/dts/Makefile                           | 4 ----
 9 files changed, 9 insertions(+), 5 deletions(-)
 create mode 100644 arch/mips/boot/dts/netlogic/Makefile
 rename arch/mips/{netlogic/dts => boot/dts/netlogic}/xlp_evp.dts (100%)
 rename arch/mips/{netlogic/dts => boot/dts/netlogic}/xlp_fvp.dts (100%)
 rename arch/mips/{netlogic/dts => boot/dts/netlogic}/xlp_gvp.dts (100%)
 rename arch/mips/{netlogic/dts => boot/dts/netlogic}/xlp_svp.dts (100%)
 delete mode 100644 arch/mips/netlogic/dts/Makefile

diff --git a/arch/mips/boot/dts/Makefile b/arch/mips/boot/dts/Makefile
index e32cc0f..a861be5 100644
--- a/arch/mips/boot/dts/Makefile
+++ b/arch/mips/boot/dts/Makefile
@@ -1,6 +1,7 @@
 include arch/mips/boot/dts/cavium-octeon/Makefile
 include arch/mips/boot/dts/lantiq/Makefile
 include arch/mips/boot/dts/mti/Makefile
+include arch/mips/boot/dts/netlogic/Makefile
 
 obj-y		+= $(patsubst %.dtb, %.dtb.o, $(dtb-y))
 
diff --git a/arch/mips/boot/dts/netlogic/Makefile b/arch/mips/boot/dts/netlogic/Makefile
new file mode 100644
index 0000000..d15f045
--- /dev/null
+++ b/arch/mips/boot/dts/netlogic/Makefile
@@ -0,0 +1,4 @@
+dtb-$(CONFIG_DT_XLP_EVP)	+= netlogic/xlp_evp.dtb
+dtb-$(CONFIG_DT_XLP_SVP)	+= netlogic/xlp_svp.dtb
+dtb-$(CONFIG_DT_XLP_FVP)	+= netlogic/xlp_fvp.dtb
+dtb-$(CONFIG_DT_XLP_GVP)	+= netlogic/xlp_gvp.dtb
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
-- 
2.1.0.rc2.206.gedb03e5

