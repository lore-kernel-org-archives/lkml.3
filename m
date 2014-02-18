Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbaBRJ5G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 04:57:06 -0500
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:60863 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754413AbaBRJ5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 04:57:03 -0500
Message-ID: <1392717420.30073.3.camel@x220>
Subject: [PATCH v2] acpi: Remove Kconfig symbol ACPI_PROCFS
From: Paul Bolle <pebolle@tiscali.nl>
To: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 18 Feb 2014 10:57:00 +0100
In-Reply-To: <1392583450.28866.91.camel@x220>
References: <1392570485.28866.10.camel@x220>
	 <49750510.SeydVA5ctE@vostro.rjw.lan> <1392583450.28866.91.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Feb 2014 09:57:01.0203 (UTC) FILETIME=[C4E08E30:01CF2C8F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing cares about ACPI_PROCFS. This has been the case since v2.6.38.
This Kconfig symbol serves no purpose and its help text is now
misleading. It can safely be removed. If this symbol would be needed
again in the future it can be readded in a commit that adds code that
actually uses it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
v2: clean up defconfigs too, as Rafael suggested. Still tested with "git
grep" only.

 arch/ia64/configs/generic_defconfig |  1 -
 arch/ia64/configs/tiger_defconfig   |  1 -
 arch/ia64/configs/zx1_defconfig     |  1 -
 arch/x86/configs/i386_defconfig     |  1 -
 arch/x86/configs/x86_64_defconfig   |  1 -
 drivers/acpi/Kconfig                | 13 -------------
 6 files changed, 18 deletions(-)

diff --git a/arch/ia64/configs/generic_defconfig b/arch/ia64/configs/generic_defconfig
index efbd292..f4a0daa 100644
--- a/arch/ia64/configs/generic_defconfig
+++ b/arch/ia64/configs/generic_defconfig
@@ -25,7 +25,6 @@ CONFIG_KEXEC=y
 CONFIG_CRASH_DUMP=y
 CONFIG_EFI_VARS=y
 CONFIG_BINFMT_MISC=m
-CONFIG_ACPI_PROCFS=y
 CONFIG_ACPI_BUTTON=m
 CONFIG_ACPI_FAN=m
 CONFIG_ACPI_DOCK=y
diff --git a/arch/ia64/configs/tiger_defconfig b/arch/ia64/configs/tiger_defconfig
index 0f4e9e4..0fed9ae 100644
--- a/arch/ia64/configs/tiger_defconfig
+++ b/arch/ia64/configs/tiger_defconfig
@@ -26,7 +26,6 @@ CONFIG_IA64_PALINFO=y
 CONFIG_KEXEC=y
 CONFIG_EFI_VARS=y
 CONFIG_BINFMT_MISC=m
-CONFIG_ACPI_PROCFS=y
 CONFIG_ACPI_BUTTON=m
 CONFIG_ACPI_FAN=m
 CONFIG_ACPI_PROCESSOR=m
diff --git a/arch/ia64/configs/zx1_defconfig b/arch/ia64/configs/zx1_defconfig
index fc7aba0..54bc72e 100644
--- a/arch/ia64/configs/zx1_defconfig
+++ b/arch/ia64/configs/zx1_defconfig
@@ -16,7 +16,6 @@ CONFIG_IA64_PALINFO=y
 CONFIG_CRASH_DUMP=y
 CONFIG_EFI_VARS=y
 CONFIG_BINFMT_MISC=y
-CONFIG_ACPI_PROCFS=y
 CONFIG_HOTPLUG_PCI=y
 CONFIG_HOTPLUG_PCI_ACPI=y
 CONFIG_PACKET=y
diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index a7fef26..619e7f7 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -60,7 +60,6 @@ CONFIG_CRASH_DUMP=y
 CONFIG_HIBERNATION=y
 CONFIG_PM_DEBUG=y
 CONFIG_PM_TRACE_RTC=y
-CONFIG_ACPI_PROCFS=y
 CONFIG_ACPI_DOCK=y
 CONFIG_CPU_FREQ=y
 # CONFIG_CPU_FREQ_STAT is not set
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index c1119d4..6181c69 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -58,7 +58,6 @@ CONFIG_CRASH_DUMP=y
 CONFIG_HIBERNATION=y
 CONFIG_PM_DEBUG=y
 CONFIG_PM_TRACE_RTC=y
-CONFIG_ACPI_PROCFS=y
 CONFIG_ACPI_DOCK=y
 CONFIG_CPU_FREQ=y
 # CONFIG_CPU_FREQ_STAT is not set
diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 4770de5..436111b 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -43,19 +43,6 @@ config ACPI_SLEEP
 	depends on SUSPEND || HIBERNATION
 	default y
 
-config ACPI_PROCFS
-	bool "Deprecated /proc/acpi files"
-	depends on PROC_FS
-	help
-	  For backwards compatibility, this option allows
-	  deprecated /proc/acpi/ files to exist, even when
-	  they have been replaced by functions in /sys.
-
-	  This option has no effect on /proc/acpi/ files
-	  and functions which do not yet exist in /sys.
-
-	  Say N to delete /proc/acpi/ files that have moved to /sys/
-
 config ACPI_EC_DEBUGFS
 	tristate "EC read/write access through /sys/kernel/debug/ec"
 	default n
-- 
1.8.5.3


