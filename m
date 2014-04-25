Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbaDYQKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:10:11 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:64459 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbaDYQKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:10:03 -0400
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: matt.fleming@intel.com, catalin.marinas@arm.com, msalter@redhat.com,
        grant.likely@linaro.org, roy.franz@linaro.org,
        ard.biesheuvel@linaro.org, mark.rutland@arm.com,
        linux-doc@vger.kernel.org
Subject: [PATCH v2 02/10] doc: efi-stub.txt updates for ARM
Date: Fri, 25 Apr 2014 17:09:06 +0100
Message-Id: <1398442154-19974-3-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1398442154-19974-1-git-send-email-leif.lindholm@linaro.org>
References: <1398442154-19974-1-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roy Franz <roy.franz@linaro.org>

Update efi-stub.txt documentation to be more general
and not x86 specific.  Add ARM only "dtb=" command
line option description.

Signed-off-by: Roy Franz <roy.franz@linaro.org>
Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
Acked-by: Grant Likely <grant.likely@linaro.org>
---
 Documentation/efi-stub.txt |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/Documentation/efi-stub.txt b/Documentation/efi-stub.txt
index c628788..26be7b0 100644
--- a/Documentation/efi-stub.txt
+++ b/Documentation/efi-stub.txt
@@ -1,13 +1,16 @@
 			  The EFI Boot Stub
 		     ---------------------------
 
-On the x86 platform, a bzImage can masquerade as a PE/COFF image,
-thereby convincing EFI firmware loaders to load it as an EFI
-executable. The code that modifies the bzImage header, along with the
-EFI-specific entry point that the firmware loader jumps to are
-collectively known as the "EFI boot stub", and live in
+On the x86 and ARM platforms, a kernel zImage/bzImage can masquerade
+as a PE/COFF image, thereby convincing EFI firmware loaders to load
+it as an EFI executable. The code that modifies the bzImage header,
+along with the EFI-specific entry point that the firmware loader
+jumps to are collectively known as the "EFI boot stub", and live in
 arch/x86/boot/header.S and arch/x86/boot/compressed/eboot.c,
-respectively.
+respectively. For ARM the EFI stub is implemented in
+arch/arm/boot/compressed/efi-header.S and
+arch/arm/boot/compressed/efi-stub.c. EFI stub code that is shared
+between architectures is in drivers/firmware/efi/efi-stub-helper.c.
 
 By using the EFI boot stub it's possible to boot a Linux kernel
 without the use of a conventional EFI boot loader, such as grub or
@@ -23,7 +26,9 @@ The bzImage located in arch/x86/boot/bzImage must be copied to the EFI
 System Partition (ESP) and renamed with the extension ".efi". Without
 the extension the EFI firmware loader will refuse to execute it. It's
 not possible to execute bzImage.efi from the usual Linux file systems
-because EFI firmware doesn't have support for them.
+because EFI firmware doesn't have support for them. For ARM the
+arch/arm/boot/zImage should be copied to the system partition, and it
+may not need to be renamed.
 
 
 **** Passing kernel parameters from the EFI shell
@@ -63,3 +68,11 @@ Notice how bzImage.efi can be specified with a relative path. That's
 because the image we're executing is interpreted by the EFI shell,
 which understands relative paths, whereas the rest of the command line
 is passed to bzImage.efi.
+
+
+**** The "dtb=" option
+
+For the ARM architecture, we also need to be able to provide a device
+tree to the kernel. This is done with the "dtb=" command line option,
+and is processed in the same manner as the "initrd=" option that is
+described above.
-- 
1.7.10.4

