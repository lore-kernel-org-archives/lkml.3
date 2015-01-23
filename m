Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbbAWIfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 03:35:18 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:51993 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbbAWIfO convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Fri, 23 Jan 2015 03:35:14 -0500
Message-Id: <54C215D10200007800058912@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Fri, 23 Jan 2015 08:35:13 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: also clear _PAGE_GLOBAL from
 __supported_pte_mask if !cpu_has_pge
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not just setting it when the feature is available is for consistency,
and may allow Xen to drop its custom clearing of the flag (unless it
needs it cleared earlier than this code executes). Note that the change
is benign to ix86, as the flag starts out clear there.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
---
 arch/x86/mm/init.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- 3.19-rc5/arch/x86/mm/init.c
+++ 3.19-rc5-x86_64-clear-PAGE_GLOBAL/arch/x86/mm/init.c
@@ -179,7 +179,8 @@ static void __init probe_page_size_mask(
 	if (cpu_has_pge) {
 		set_in_cr4(X86_CR4_PGE);
 		__supported_pte_mask |= _PAGE_GLOBAL;
-	}
+	} else
+		__supported_pte_mask &= ~_PAGE_GLOBAL;
 }
 
 #ifdef CONFIG_X86_32



