Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843Ab3KLCQm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 21:16:42 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:22181 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab3KLCQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 21:16:09 -0500
From: Jerry Hoemann <jerry.hoemann@hp.com>
To: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, matt.fleming@intel.com, yinghai@kernel.org,
        penberg@kernel.org, akpm@linux-foundation.org,
        linux-doc@vger.kernel.org, linux-efi@vger.kernel.org,
        vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, jerry.hoemann@hp.com
Subject: [PATCH 1/3] efi: Early use of boot service memory
Date: Mon, 11 Nov 2013 19:15:56 -0700
Message-Id: <1384222558-38527-2-git-send-email-jerry.hoemann@hp.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1384222558-38527-1-git-send-email-jerry.hoemann@hp.com>
References: <1384222558-38527-1-git-send-email-jerry.hoemann@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add #define to allow for specifying that firmware doesn't reuse
boot service code or data after Exit Boot Service.

Signed-off-by: Jerry Hoemann <jerry.hoemann@hp.com>
---
 include/linux/efi.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 5f8f176..1e3a8d2 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -634,6 +634,7 @@ extern int __init efi_setup_pcdp_console(char *);
 #define EFI_RUNTIME_SERVICES	3	/* Can we use runtime services? */
 #define EFI_MEMMAP		4	/* Can we use EFI memory map? */
 #define EFI_64BIT		5	/* Is the firmware 64-bit? */
+#define EFI_MEMMAP_CORRECT	6	/* We believe the EFI_MEMMAP */
 
 #ifdef CONFIG_EFI
 # ifdef CONFIG_X86
-- 
1.7.11.3

