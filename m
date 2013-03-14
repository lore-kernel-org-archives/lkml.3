Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290Ab3CNLyp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 07:54:45 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:61487 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757236Ab3CNLym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 07:54:42 -0400
Message-ID: <1363262077.1335.71.camel@x61.thuisdomein>
Subject: [PATCH] x84: reenable DEBUG_TLBFLUSH for X86_32
From: Paul Bolle <pebolle@tiscali.nl>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 14 Mar 2013 12:54:37 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Mar 2013 11:54:37.0716 (UTC) FILETIME=[B4063D40:01CE20AA]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_INVLPG got removed in commit
094ab1db7cb7833cd4c820acd868fc26acf3f08e ("x86, 386 removal: Remove
CONFIG_INVLPG"). That commit left one instance of CONFIG_INVLPG
untouched, effectively disabling DEBUG_TLBFLUSH for X86_32. Since all
currently supported X86 CPU's should now be able to support that option,
just drop the entire sub-dependency.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Untested! This needs testing by the subsection of people running
DEBUG_TLBFLUSH on X86_32. I'm not in that subsection.

1) I actually wonder whether this check was needed in the first place.
It seems that the code depending on CONFIG_DEBUG_TLBFLUSH in
arch/x86/mm/tlb.c was actually safe to be called on any X86 CPU, since
it used to test for cpu_has_invlpg. But none of that matters anymore.

 arch/x86/Kconfig.debug | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index b322f12..16f7383 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -131,7 +131,7 @@ config DOUBLEFAULT
 
 config DEBUG_TLBFLUSH
 	bool "Set upper limit of TLB entries to flush one-by-one"
-	depends on DEBUG_KERNEL && (X86_64 || X86_INVLPG)
+	depends on DEBUG_KERNEL
 	---help---
 
 	X86-only for now.
-- 
1.7.11.7

