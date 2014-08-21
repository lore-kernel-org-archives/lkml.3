Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbaHUUGD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 16:06:03 -0400
Received: from mail-ie0-f201.google.com ([209.85.223.201]:40821 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbaHUUEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 16:04:50 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: James Hogan <james.hogan@imgtec.com>, Paul Burton <paul.burton@imgtec.com>,
        David Daney <david.daney@cavium.com>,
        John Crispin <blogic@openwrt.org>,
        Jayachandran C <jchandra@broadcom.com>,
        Qais Yousef <qais.yousef@imgtec.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH 4/7] MIPS: Lantiq: Move device-trees to arch/mips/boot/dts/
Date: Thu, 21 Aug 2014 13:04:23 -0700
Message-Id: <1408651466-8334-5-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1408651466-8334-1-git-send-email-abrestic@chromium.org>
References: <1408651466-8334-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the Lantiq device-trees to arch/mips/boot/dts/ and update the
Makefiles accordingly.  There is currently only a single Lantiq
device-tree (EASY50712), and it's required to be built into the kernel,
so select BUILTIN_DTB for it.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 arch/mips/boot/dts/Makefile                  | 1 +
 arch/mips/{lantiq => boot}/dts/danube.dtsi   | 0
 arch/mips/{lantiq => boot}/dts/easy50712.dts | 0
 arch/mips/lantiq/Kconfig                     | 1 +
 arch/mips/lantiq/Makefile                    | 2 --
 arch/mips/lantiq/dts/Makefile                | 1 -
 6 files changed, 2 insertions(+), 3 deletions(-)
 rename arch/mips/{lantiq => boot}/dts/danube.dtsi (100%)
 rename arch/mips/{lantiq => boot}/dts/easy50712.dts (100%)
 delete mode 100644 arch/mips/lantiq/dts/Makefile

diff --git a/arch/mips/boot/dts/Makefile b/arch/mips/boot/dts/Makefile
index 51acad6..4f265ec 100644
--- a/arch/mips/boot/dts/Makefile
+++ b/arch/mips/boot/dts/Makefile
@@ -1,4 +1,5 @@
 dtb-$(CONFIG_CAVIUM_OCTEON_SOC)		+= octeon_3xxx.dtb octeon_68xx.dtb
+dtb-$(CONFIG_DT_EASY50712)		+= easy50712.dtb
 
 obj-y		+= $(patsubst %.dtb, %.dtb.o, $(dtb-y))
 
diff --git a/arch/mips/lantiq/dts/danube.dtsi b/arch/mips/boot/dts/danube.dtsi
similarity index 100%
rename from arch/mips/lantiq/dts/danube.dtsi
rename to arch/mips/boot/dts/danube.dtsi
diff --git a/arch/mips/lantiq/dts/easy50712.dts b/arch/mips/boot/dts/easy50712.dts
similarity index 100%
rename from arch/mips/lantiq/dts/easy50712.dts
rename to arch/mips/boot/dts/easy50712.dts
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
-- 
2.1.0.rc2.206.gedb03e5

