Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935922Ab3DKQtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 12:49:46 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:64744 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934862Ab3DKQto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 12:49:44 -0400
Message-ID: <1365698982.1427.3.camel@x61.thuisdomein>
Subject: [PATCH] x86: fixmap: remove FIX_CYCLONE_TIMER
From: Paul Bolle <pebolle@tiscali.nl>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 11 Apr 2013 18:49:42 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Apr 2013 16:49:42.0959 (UTC) FILETIME=[90BCEBF0:01CE36D4]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last users of FIX_CYCLONE_TIMER were removed in v2.6.18. We can
remove this unneeded constant.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
See commit 61743fe445213b87fb55a389c8d073785323ca3e ("[...] Time: i386
Conversion - part 4: Remove Old timer_opts Code").

 arch/x86/include/asm/fixmap.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index a09c285..83ea2fb 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -107,9 +107,6 @@ enum fixed_addresses {
 #ifdef CONFIG_X86_F00F_BUG
 	FIX_F00F_IDT,	/* Virtual mapping for IDT */
 #endif
-#ifdef CONFIG_X86_CYCLONE_TIMER
-	FIX_CYCLONE_TIMER, /*cyclone timer register*/
-#endif
 #ifdef CONFIG_X86_32
 	FIX_KMAP_BEGIN,	/* reserved pte's for temporary kernel mappings */
 	FIX_KMAP_END = FIX_KMAP_BEGIN+(KM_TYPE_NR*NR_CPUS)-1,
-- 
1.7.11.7

