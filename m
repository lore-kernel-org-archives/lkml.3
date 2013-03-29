Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999Ab3C2VCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 17:02:17 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:53483 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756872Ab3C2VCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 17:02:16 -0400
Message-ID: <1364590934.1345.92.camel@x61.thuisdomein>
Subject: [PATCH] powerpc: Fix typo "CONFIG_ICSWX_PID"
From: Paul Bolle <pebolle@tiscali.nl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: Jimi Xenidis <jimix@pobox.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Fri, 29 Mar 2013 22:02:14 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Mar 2013 21:02:15.0598 (UTC) FILETIME=[B10B64E0:01CE2CC0]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested. As this typo was introduced in v3.3, with commit
9d670280908013004f173b2b86414d9b6918511b ("powerpc: Split ICSWX ACOP and
PID processing"), which actually added PPC_ICSWX_PID, this surely needs
testing.

 arch/powerpc/mm/icswx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/icswx.c b/arch/powerpc/mm/icswx.c
index 8cdbd86..915412e 100644
--- a/arch/powerpc/mm/icswx.c
+++ b/arch/powerpc/mm/icswx.c
@@ -67,7 +67,7 @@
 
 void switch_cop(struct mm_struct *next)
 {
-#ifdef CONFIG_ICSWX_PID
+#ifdef CONFIG_PPC_ICSWX_PID
 	mtspr(SPRN_PID, next->context.cop_pid);
 #endif
 	mtspr(SPRN_ACOP, next->context.acop);
-- 
1.7.11.7

