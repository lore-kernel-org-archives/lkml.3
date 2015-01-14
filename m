Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbbANPJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 10:09:24 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:54335 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949AbbANPJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 10:09:20 -0500
From: Hanjun Guo <hanjun.guo@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>
Cc: Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Jon Masters <jcm@redhat.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh@kernel.org>, Robert Richter <rric@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        phoenix.liyi@huawei.com, Timur Tabi <timur@codeaurora.org>,
        suravee.suthikulpanit@amd.com, wangyijing@huawei.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        Al Stone <al.stone@linaro.org>, Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH v7 16/17] ARM64 / ACPI: Enable ARM64 in Kconfig
Date: Wed, 14 Jan 2015 23:05:04 +0800
Message-Id: <1421247905-3749-17-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org>
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graeme Gregory <graeme.gregory@linaro.org>

Add Kconfigs to build ACPI on ARM64, and make ACPI available on ARM64.

acpi_idle driver is x86/IA64 dependent now, so make CONFIG_ACPI_PROCESSOR
depend on X86 || IA64, and implement it on ARM64 in the future.

Reviewed-by: Grant Likely <grant.likely@linaro.org>
Tested-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Tested-by: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
Signed-off-by: Al Stone <al.stone@linaro.org>
Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 arch/arm64/Kconfig   | 2 ++
 drivers/acpi/Kconfig | 6 +++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index c19ae5d..915aa16 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -647,6 +647,8 @@ source "drivers/Kconfig"
 
 source "drivers/firmware/Kconfig"
 
+source "drivers/acpi/Kconfig"
+
 source "fs/Kconfig"
 
 source "arch/arm64/kvm/Kconfig"
diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 8951cef..3e3bd35 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -5,8 +5,7 @@
 menuconfig ACPI
 	bool "ACPI (Advanced Configuration and Power Interface) Support"
 	depends on !IA64_HP_SIM
-	depends on IA64 || X86
-	depends on PCI
+	depends on ((IA64 || X86) && PCI) || (ARM64 && EXPERT)
 	select PNP
 	default y
 	help
@@ -163,6 +162,7 @@ config ACPI_PROCESSOR
 	tristate "Processor"
 	select THERMAL
 	select CPU_IDLE
+	depends on X86 || IA64
 	default y
 	help
 	  This driver installs ACPI as the idle handler for Linux and uses
@@ -263,7 +263,7 @@ config ACPI_DEBUG
 
 config ACPI_PCI_SLOT
 	bool "PCI slot detection driver"
-	depends on SYSFS
+	depends on SYSFS && PCI
 	default n
 	help
 	  This driver creates entries in /sys/bus/pci/slots/ for all PCI
-- 
1.9.1

