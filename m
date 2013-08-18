Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153Ab3HRUrk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:47:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43611 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756236Ab3HRUeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:34:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [ 11/45] ARM: KVM: clear exclusive monitor on all exception returns
Date: Sun, 18 Aug 2013 13:36:00 -0700
Message-Id: <20130818203621.775512750@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203620.996166594@linuxfoundation.org>
References: <20130818203620.996166594@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <marc.zyngier@arm.com>

commit 22cfbb6d730ca2fda236b507d9fba17bf002736c upstream.

Make sure we clear the exclusive monitor on all exception returns,
which otherwise could lead to lock corruptions.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kvm/interrupts.S |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm/kvm/interrupts.S
+++ b/arch/arm/kvm/interrupts.S
@@ -292,6 +292,7 @@ THUMB(	orr	r2, r2, #PSR_T_BIT	)
 	ldr	r2, =BSYM(panic)
 	msr	ELR_hyp, r2
 	ldr	r0, =\panic_str
+	clrex				@ Clear exclusive monitor
 	eret
 .endm
 
@@ -441,6 +442,7 @@ guest_trap:
 
 4:	pop	{r0, r1}		@ Failed translation, return to guest
 	mcrr	p15, 0, r0, r1, c7	@ PAR
+	clrex
 	pop	{r0, r1, r2}
 	eret
 
@@ -467,6 +469,7 @@ switch_to_guest_vfp:
 
 	pop	{r3-r7}
 	pop	{r0-r2}
+	clrex
 	eret
 #endif
 


