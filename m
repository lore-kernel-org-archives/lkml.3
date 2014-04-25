Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbaDYQNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:13:42 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51982 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379AbaDYQKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:10:38 -0400
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: matt.fleming@intel.com, catalin.marinas@arm.com, msalter@redhat.com,
        grant.likely@linaro.org, roy.franz@linaro.org,
        ard.biesheuvel@linaro.org, mark.rutland@arm.com,
        linux-doc@vger.kernel.org
Subject: [PATCH v2 09/10] doc: arm64: add description of EFI stub support
Date: Fri, 25 Apr 2014 17:09:13 +0100
Message-Id: <1398442154-19974-10-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1398442154-19974-1-git-send-email-leif.lindholm@linaro.org>
References: <1398442154-19974-1-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Salter <msalter@redhat.com>

Add explanation of arm64 EFI stub and kernel image header changes
needed to masquerade as a PE/COFF application.

Signed-off-by: Mark Salter <msalter@redhat.com>
Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
Acked-by: Grant Likely <grant.likely@linaro.org>
CC: linux-doc@vger.kernel.org
CC: Rob Landley <rob@landley.net>
---
 Documentation/arm64/booting.txt |    4 ++++
 Documentation/efi-stub.txt      |   12 +++++++++---
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/Documentation/arm64/booting.txt b/Documentation/arm64/booting.txt
index beb754e..37fc4f6 100644
--- a/Documentation/arm64/booting.txt
+++ b/Documentation/arm64/booting.txt
@@ -85,6 +85,10 @@ The decompressed kernel image contains a 64-byte header as follows:
 Header notes:
 
 - code0/code1 are responsible for branching to stext.
+- when booting through EFI, code0/code1 are initially skipped.
+  res5 is an offset to the PE header and the PE header has the EFI
+  entry point (efi_stub_entry). When the stub has done its work, it
+  jumps to code0 to resume the normal boot process.
 
 The image must be placed at the specified offset (currently 0x80000)
 from the start of the system RAM and called there. The start of the
diff --git a/Documentation/efi-stub.txt b/Documentation/efi-stub.txt
index 26be7b0..7747024 100644
--- a/Documentation/efi-stub.txt
+++ b/Documentation/efi-stub.txt
@@ -12,6 +12,11 @@ arch/arm/boot/compressed/efi-header.S and
 arch/arm/boot/compressed/efi-stub.c. EFI stub code that is shared
 between architectures is in drivers/firmware/efi/efi-stub-helper.c.
 
+For arm64, there is no compressed kernel support, so the Image itself
+masquerades as a PE/COFF image and the EFI stub is linked into the
+kernel. The arm64 EFI stub lives in arch/arm64/kernel/efi-entry.S
+and arch/arm64/kernel/efi-stub.c.
+
 By using the EFI boot stub it's possible to boot a Linux kernel
 without the use of a conventional EFI boot loader, such as grub or
 elilo. Since the EFI boot stub performs the jobs of a boot loader, in
@@ -28,7 +33,8 @@ the extension the EFI firmware loader will refuse to execute it. It's
 not possible to execute bzImage.efi from the usual Linux file systems
 because EFI firmware doesn't have support for them. For ARM the
 arch/arm/boot/zImage should be copied to the system partition, and it
-may not need to be renamed.
+may not need to be renamed. Similarly for arm64, arch/arm64/boot/Image
+should be copied but not necessarily renamed.
 
 
 **** Passing kernel parameters from the EFI shell
@@ -72,7 +78,7 @@ is passed to bzImage.efi.
 
 **** The "dtb=" option
 
-For the ARM architecture, we also need to be able to provide a device
-tree to the kernel. This is done with the "dtb=" command line option,
+For the ARM and arm64 architectures, we also need to be able to provide a
+device tree to the kernel. This is done with the "dtb=" command line option,
 and is processed in the same manner as the "initrd=" option that is
 described above.
-- 
1.7.10.4

