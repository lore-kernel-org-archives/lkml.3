Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760565AbaCUB5y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:57:54 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:42682 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760419AbaCUB5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 21:57:35 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>
Cc: Stefani Seibold <stefani@seibold.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kbuild-all@01.org, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 2/2] x86: Finish removing VDSO32_PRELINK
Date: Thu, 20 Mar 2014 18:57:19 -0700
Message-Id: <2ce2ce18447d8a0b78d44a278a066b6c0af06b32.1395366931.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <cover.1395366931.git.luto@amacapital.net>
References: <532b9195.3C8GzQgSVEquG2Tq%fengguang.wu@intel.com>
 <cover.1395366931.git.luto@amacapital.net>
In-Reply-To: <cover.1395366931.git.luto@amacapital.net>
References: <cover.1395366931.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's a declaration of a nonexistent symbol.  We can get rid of the
64-bit versions, too, but that's more intrusive.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/include/asm/vdso.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
index 7622a65..d1dc554 100644
--- a/arch/x86/include/asm/vdso.h
+++ b/arch/x86/include/asm/vdso.h
@@ -41,8 +41,6 @@ DECLARE_VDSO_IMAGE(vdso32_syscall);
 #endif
 DECLARE_VDSO_IMAGE(vdso32_sysenter);
 
-extern const char VDSO32_PRELINK[];
-
 /*
  * Given a pointer to the vDSO image, find the pointer to VDSO32_name
  * as that symbol is defined in the vDSO sources or linker script.
-- 
1.8.5.3

