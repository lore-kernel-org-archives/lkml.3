Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab3HRUex (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:34:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43604 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756224Ab3HRUeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:34:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [ 10/45] ARM: KVM: add missing dsb before invalidating Stage-2 TLBs
Date: Sun, 18 Aug 2013 13:35:59 -0700
Message-Id: <20130818203621.708004822@linuxfoundation.org>
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

commit 479c5ae2f8a55509b691494cd13691d3dc31d102 upstream.

When performing a Stage-2 TLB invalidation, it is necessary to
make sure the write to the page tables is observable by all CPUs.

For this purpose, add a dsb instruction to __kvm_tlb_flush_vmid_ipa
before doing the TLB invalidation itself.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kvm/interrupts.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/kvm/interrupts.S
+++ b/arch/arm/kvm/interrupts.S
@@ -49,6 +49,7 @@ __kvm_hyp_code_start:
 ENTRY(__kvm_tlb_flush_vmid_ipa)
 	push	{r2, r3}
 
+	dsb	ishst
 	add	r0, r0, #KVM_VTTBR
 	ldrd	r2, r3, [r0]
 	mcrr	p15, 6, r2, r3, c2	@ Write VTTBR


