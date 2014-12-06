Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125AbaLFR5q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 12:57:46 -0500
Received: from 1wt.eu ([62.212.114.60]:40753 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403AbaLFRzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 12:55:14 -0500
Message-Id: <20141206174148.557289165@1wt.eu>
User-Agent: quilt/0.63-1
Date: Sat, 06 Dec 2014 18:41:51 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jan Beulich <jbeulich@novell.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Ingo Molnar <mingo@elte.hu>, Willy Tarreau <w@1wt.eu>
Subject: [ 03/25] x86-64: Adjust frame type at paranoid_exit:
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
In-Reply-To: <2a26e912d2438674771c36169c190830@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Beulich <JBeulich@novell.com>

As this isn't an exception or interrupt entry point, it doesn't
have any of the hardware provide frame layouts active.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>
LKML-Reference: <4C7FBAA80200007800013F67@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
(cherry picked from commit 1f130a783a796f147b080c594488b566c86007d0)
[WT: only merged to minimize changes from mainline in entry_64.S]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/x86/kernel/entry_64.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 4f577eb..fb402d5 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1400,7 +1400,7 @@ paranoidzeroentry machine_check *machine_check_vector(%rip)
 
 	/* ebx:	no swapgs flag */
 ENTRY(paranoid_exit)
-	INTR_FRAME
+	DEFAULT_FRAME
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	testl %ebx,%ebx				/* swapgs needed? */
-- 
1.7.12.2.21.g234cd45.dirty



