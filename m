Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008AbaESRup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 13:50:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:23092 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589AbaESRun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 13:50:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,868,1392192000"; 
   d="scan'208";a="542992479"
From: Ross Zwisler <ross.zwisler@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH] x86: remove obsolete comment in uapi/e820.h
Date: Mon, 19 May 2014 11:50:24 -0600
Message-Id: <1400521824-21040-1-git-send-email-ross.zwisler@linux.intel.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A comment introduced by this commit:

028b785888c5 x86 boot: extend some internal memory map arrays to handle
	larger EFI input

had to do with some nested preprocessor directives.  The directives were
split into separate files by this commit:

af170c5061dd  UAPI: (Scripted) Disintegrate arch/x86/include/asm

The comment explaining their interaction was retained and is now present
in arch/x86/include/uapi/asm/e820.h.  This comment is no longer correct,
so delete it.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
---
 arch/x86/include/uapi/asm/e820.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/x86/include/uapi/asm/e820.h b/arch/x86/include/uapi/asm/e820.h
index bbae024..d993e33 100644
--- a/arch/x86/include/uapi/asm/e820.h
+++ b/arch/x86/include/uapi/asm/e820.h
@@ -21,11 +21,6 @@
  * this size.
  */
 
-/*
- * Odd: 'make headers_check' complains about numa.h if I try
- * to collapse the next two #ifdef lines to a single line:
- *	#if defined(__KERNEL__) && defined(CONFIG_EFI)
- */
 #ifndef __KERNEL__
 #define E820_X_MAX E820MAX
 #endif
-- 
1.9.0

