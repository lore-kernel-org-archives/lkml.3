Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751014AbaETVC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 17:02:59 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:61930 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750699AbaETVC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 17:02:58 -0400
Message-ID: <1400619776.4912.71.camel@x220>
Subject: [PATCH] powerpc: remove check for CONFIG_SERIAL_TEXT_DEBUG
From: Paul Bolle <pebolle@tiscali.nl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Tue, 20 May 2014 23:02:56 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 May 2014 21:02:57.0169 (UTC) FILETIME=[E0146010:01CF746E]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol SERIAL_TEXT_DEBUG was removed from
arch/powerpc/Kconfig.debug in v2.6.22. (In v2.6.27 it was also removed
from arch/ppc/Kconfig.debug.) So the check for its macro has evaluated
to false for over five years now. Remove that check and the few lines
of code hidden behind it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 arch/powerpc/kernel/head_40x.S | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/arch/powerpc/kernel/head_40x.S b/arch/powerpc/kernel/head_40x.S
index 67ee0d6c1070..7d7d8635227a 100644
--- a/arch/powerpc/kernel/head_40x.S
+++ b/arch/powerpc/kernel/head_40x.S
@@ -930,25 +930,6 @@ initial_mmu:
 	tlbwe	r4,r0,TLB_DATA		/* Load the data portion of the entry */
 	tlbwe	r3,r0,TLB_TAG		/* Load the tag portion of the entry */
 
-#if defined(CONFIG_SERIAL_TEXT_DEBUG) && defined(SERIAL_DEBUG_IO_BASE)
-
-	/* Load a TLB entry for the UART, so that ppc4xx_progress() can use
-	 * the UARTs nice and early.  We use a 4k real==virtual mapping. */
-
-	lis	r3,SERIAL_DEBUG_IO_BASE@h
-	ori	r3,r3,SERIAL_DEBUG_IO_BASE@l
-	mr	r4,r3
-	clrrwi	r4,r4,12
-	ori	r4,r4,(TLB_WR|TLB_I|TLB_M|TLB_G)
-
-	clrrwi	r3,r3,12
-	ori	r3,r3,(TLB_VALID | TLB_PAGESZ(PAGESZ_4K))
-
-	li	r0,0			/* TLB slot 0 */
-	tlbwe	r4,r0,TLB_DATA
-	tlbwe	r3,r0,TLB_TAG
-#endif /* CONFIG_SERIAL_DEBUG_TEXT && SERIAL_DEBUG_IO_BASE */
-
 	isync
 
 	/* Establish the exception vector base
-- 
1.9.0

