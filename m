Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbaDYQSU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:18:20 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:63063 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbaDYQK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:10:29 -0400
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: matt.fleming@intel.com, catalin.marinas@arm.com, msalter@redhat.com,
        grant.likely@linaro.org, roy.franz@linaro.org,
        ard.biesheuvel@linaro.org, mark.rutland@arm.com,
        linux-doc@vger.kernel.org
Subject: [PATCH v2 07/10] doc: arm: add UEFI support documentation
Date: Fri, 25 Apr 2014 17:09:11 +0100
Message-Id: <1398442154-19974-8-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1398442154-19974-1-git-send-email-leif.lindholm@linaro.org>
References: <1398442154-19974-1-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides documentation of the [U]EFI runtime service and
configuration features for the arm architecture.

Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
Acked-by: Grant Likely <grant.likely@linaro.org>
---
 Documentation/arm/00-INDEX |    2 ++
 Documentation/arm/uefi.txt |   64 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+)
 create mode 100644 Documentation/arm/uefi.txt

diff --git a/Documentation/arm/00-INDEX b/Documentation/arm/00-INDEX
index a94090c..3b08bc2 100644
--- a/Documentation/arm/00-INDEX
+++ b/Documentation/arm/00-INDEX
@@ -46,5 +46,7 @@ swp_emulation
 	- SWP/SWPB emulation handler/logging description
 tcm.txt
 	- ARM Tightly Coupled Memory
+uefi.txt
+	- [U]EFI configuration and runtime services documentation
 vlocks.txt
 	- Voting locks, low-level mechanism relying on memory system atomic writes.
diff --git a/Documentation/arm/uefi.txt b/Documentation/arm/uefi.txt
new file mode 100644
index 0000000..d60030a
--- /dev/null
+++ b/Documentation/arm/uefi.txt
@@ -0,0 +1,64 @@
+UEFI, the Unified Extensible Firmware Interface, is a specification
+governing the behaviours of compatible firmware interfaces. It is
+maintained by the UEFI Forum - http://www.uefi.org/.
+
+UEFI is an evolution of its predecessor 'EFI', so the terms EFI and
+UEFI are used somewhat interchangeably in this document and associated
+source code. As a rule, anything new uses 'UEFI', whereas 'EFI' refers
+to legacy code or specifications.
+
+UEFI support in Linux
+=====================
+Booting on a platform with firmware compliant with the UEFI specification
+makes it possible for the kernel to support additional features:
+- UEFI Runtime Services
+- Retrieving various configuration information through the standardised
+  interface of UEFI configuration tables. (ACPI, SMBIOS, ...)
+
+For actually enabling [U]EFI support, enable:
+- CONFIG_EFI=y
+- CONFIG_EFI_VARS=y or m
+
+The implementation depends on receiving information about the UEFI environment
+in a Flattened Device Tree (FDT) - so is only available with CONFIG_OF.
+
+UEFI stub
+=========
+The "stub" is a feature that extends the Image/zImage into a valid UEFI
+PE/COFF executable, including a loader application that makes it possible to
+load the kernel directly from the UEFI shell, boot menu, or one of the
+lightweight bootloaders like Gummiboot or rEFInd.
+
+The kernel image built with stub support remains a valid kernel image for
+booting in non-UEFI environments.
+
+UEFI kernel support on ARM
+==========================
+UEFI kernel support on the ARM architectures (arm and arm64) is only available
+when boot is performed through the stub.
+
+When booting in UEFI mode, the stub deletes any memory nodes from a provided DT.
+Instead, the kernel reads the UEFI memory map.
+
+The stub populates the FDT /chosen node with (and the kernel scans for) the
+following parameters:
+________________________________________________________________________________
+Name                      | Size   | Description
+================================================================================
+linux,uefi-system-table   | 64-bit | Physical address of the UEFI System Table.
+--------------------------------------------------------------------------------
+linux,uefi-mmap-start     | 64-bit | Physical address of the UEFI memory map,
+                          |        | populated by the UEFI GetMemoryMap() call.
+--------------------------------------------------------------------------------
+linux,uefi-mmap-size      | 32-bit | Size in bytes of the UEFI memory map
+                          |        | pointed to in previous entry.
+--------------------------------------------------------------------------------
+linux,uefi-mmap-desc-size | 32-bit | Size in bytes of each entry in the UEFI
+                          |        | memory map.
+--------------------------------------------------------------------------------
+linux,uefi-mmap-desc-ver  | 32-bit | Version of the mmap descriptor format.
+--------------------------------------------------------------------------------
+linux,uefi-stub-kern-ver  | string | Copy of linux_banner from build.
+--------------------------------------------------------------------------------
+
+For verbose debug messages, specify 'uefi_debug' on the kernel command line.
-- 
1.7.10.4

