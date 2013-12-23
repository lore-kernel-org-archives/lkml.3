Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500Ab3LWOH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 09:07:59 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:50772 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757347Ab3LWOGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 09:06:45 -0500
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux@arm.linux.org.uk, catalin.marinas@arm.com, viro@zeniv.linux.org.uk,
        nico@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 2/5] binfmt_elf: add ELF_HWCAP2 to compat auxv entries
Date: Mon, 23 Dec 2013 15:06:29 +0100
Message-Id: <1387807592-26375-3-git-send-email-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387807592-26375-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1387807592-26375-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ELF_HWCAP2 to the set of auxv entries that is passed to
a 32-bit ELF program running in 32-bit compat mode under a
64-bit kernel.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 fs/compat_binfmt_elf.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/compat_binfmt_elf.c b/fs/compat_binfmt_elf.c
index a81147e..4d24d17 100644
--- a/fs/compat_binfmt_elf.c
+++ b/fs/compat_binfmt_elf.c
@@ -88,6 +88,11 @@ static void cputime_to_compat_timeval(const cputime_t cputime,
 #define	ELF_HWCAP		COMPAT_ELF_HWCAP
 #endif
 
+#ifdef	COMPAT_ELF_HWCAP2
+#undef	ELF_HWCAP2
+#define	ELF_HWCAP2		COMPAT_ELF_HWCAP2
+#endif
+
 #ifdef	COMPAT_ARCH_DLINFO
 #undef	ARCH_DLINFO
 #define	ARCH_DLINFO		COMPAT_ARCH_DLINFO
-- 
1.8.3.2

