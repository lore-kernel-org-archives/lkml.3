Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759163Ab3JKUBg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:01:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46290 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932599Ab3JKTlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:41:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 066/135] powerpc/tm: Turn interrupts hard off in tm_reclaim()
Date: Fri, 11 Oct 2013 12:39:07 -0700
Message-Id: <20131011193952.452035387@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Neuling <mikey@neuling.org>

commit c69e63b0f135fa51d6e1c38b5ac8a1def15ea3fa upstream.

We can't take IRQs in tm_reclaim as we might have a bogus r13 and r1.

This turns IRQs hard off in this function.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/tm.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/kernel/tm.S
+++ b/arch/powerpc/kernel/tm.S
@@ -128,6 +128,7 @@ _GLOBAL(tm_reclaim)
 	mr	r15, r14
 	ori	r15, r15, MSR_FP
 	li	r16, MSR_RI
+	ori	r16, r16, MSR_EE /* IRQs hard off */
 	andc	r15, r15, r16
 	oris	r15, r15, MSR_VEC@h
 #ifdef CONFIG_VSX


