Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935751Ab3DPObR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 10:31:17 -0400
Received: from vint.altlinux.org ([194.107.17.35]:52003 "EHLO
	vint.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934716Ab3DPObP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 10:31:15 -0400
From: Sergey Vlasov <vsu@altlinux.ru>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: matt.fleming@intel.com, linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Sergey Vlasov <vsu@altlinux.ru>
Subject: [PATCH 1/2] x86/Kconfig: Make EFI select UCS2_STRING
Date: Tue, 16 Apr 2013 18:31:08 +0400
Message-Id: <1366122669-20898-1-git-send-email-vsu@altlinux.ru>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1366056587-24414-4-git-send-email-matthew.garrett@nebula.com>
References: <1366056587-24414-4-git-send-email-matthew.garrett@nebula.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit "efi: Distinguish between "remaining space" and actually used
space" added usage of ucs2_*() functions to arch/x86/platform/efi/efi.c,
but the only thing which selected UCS2_STRING was EFI_VARS, which is
technically optional and can be built as a module.

Signed-off-by: Sergey Vlasov <vsu@altlinux.ru>
---
 arch/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a4f24f5..01af853 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1549,6 +1549,7 @@ config X86_SMAP
 config EFI
 	bool "EFI runtime service support"
 	depends on ACPI
+	select UCS2_STRING
 	---help---
 	  This enables the kernel to use EFI runtime services that are
 	  available (such as the EFI variable services).
-- 
1.8.1.1

