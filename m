Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbaDKR7X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 13:59:23 -0400
Received: from gerolde.archlinux.org ([66.211.214.132]:36812 "EHLO
	gerolde.archlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225AbaDKR7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 13:59:22 -0400
From: =?UTF-8?q?Thomas=20B=C3=A4chler?= <thomas@archlinux.org>
To: Matt Fleming <matt.fleming@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Thomas=20B=C3=A4chler?= <thomas@archlinux.org>
Subject: [PATCH] efi: Clarify Kconfig help for EFI_MIXED
Date: Fri, 11 Apr 2014 19:59:14 +0200
Message-Id: <1397239154-30121-1-git-send-email-thomas@archlinux.org>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EFI stub support is only missing for a 64 bit kernel on 32-bit firmware,
on 64-bit kernels, EFI stub works as usual.
---

Matt, I don't know if this help was intentionally discouraging,
however, out of curiosity, I tested this with ovmf, and the
kernel boots fine on 64-bit firmware bit with EFI stub, and on
32-bit firmware using efilinux.

Documenting this properly is important for distribution kernels.
We would want to support this on Arch, but not if it means
introducing a regression for EFI stub users.

 arch/x86/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5b8ec0f..2bbbbb9 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1529,8 +1529,8 @@ config EFI_MIXED
 	   mode.
 
 	   Note that it is not possible to boot a mixed-mode enabled
-	   kernel via the EFI boot stub - a bootloader that supports
-	   the EFI handover protocol must be used.
+	   kernel via the EFI boot stub on 32-bit firmware - a bootloader
+	   that supports the EFI handover protocol must be used.
 
 	   If unsure, say N.
 
-- 
1.9.2

