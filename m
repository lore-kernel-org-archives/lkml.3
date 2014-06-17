Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967080AbaFQVwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:52:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54796 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967033AbaFQVwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:52:15 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paul Bolle <pebolle@tiscali.nl>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 089/212] ACPI: Remove Kconfig symbol ACPI_PROCFS
Date: Tue, 17 Jun 2014 14:43:03 -0700
Message-Id: <1403041506-13646-90-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Bolle <pebolle@tiscali.nl>

commit 7919010c4224e07b871f3b5513d245cc029fcd67 upstream.

Nothing cares about ACPI_PROCFS. This has been the case since v2.6.38.
This Kconfig symbol serves no purpose and its help text is now
misleading. It can safely be removed. If this symbol would be needed
again in the future it can be readded in a commit that adds code that
actually uses it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[ kamal: 3.13-stable prereq for
  e2a7c3d ACPI: Revert "ACPI: Remove CONFIG_ACPI_PROCFS_POWER and cm_sbsc.c" ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
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
1.9.1

