Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966021Ab3E2M3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 08:29:18 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:45737 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965855Ab3E2M3R convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Wed, 29 May 2013 08:29:17 -0400
Message-Id: <51A610B802000078000D99A0@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Wed, 29 May 2013 13:29:12 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: __force_order doesn't need to be an actual
 variable
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It being static causes over a dozen instances to be scattered across
the kernel image, with non of them ever being referenced in any way.
Making the variable extern without ever defining it works as well - all
we need is to have the compiler think the variable is being accessed.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/include/asm/special_insns.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 3.10-rc3/arch/x86/include/asm/special_insns.h
+++ 3.10-rc3-x86-force-order/arch/x86/include/asm/special_insns.h
@@ -16,7 +16,7 @@ static inline void native_clts(void)
  * all loads stores around it, which can hurt performance. Solution is to
  * use a variable and mimic reads and writes to it to enforce serialization
  */
-static unsigned long __force_order;
+extern unsigned long __force_order;
 
 static inline unsigned long native_read_cr0(void)
 {



