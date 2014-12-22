Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbaLVM27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 07:28:59 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:55739 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbaLVM25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 07:28:57 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH] kvm: x86: drop severity of "generation wraparound" message
Date: Mon, 22 Dec 2014 13:28:48 +0100
Message-Id: <1419251328-7524-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since most virtual machines raise this message once, it is a bit annoying.
Make it KERN_DEBUG severity.

Cc: stable@vger.kernel.org
Fixes: 7a2e8aaf0f6873b47bc2347f216ea5b0e4c258ab
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 10fbed126b11..f83fc6c5e0ba 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4448,7 +4448,7 @@ void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm)
 	 * zap all shadow pages.
 	 */
 	if (unlikely(kvm_current_mmio_generation(kvm) == 0)) {
-		printk_ratelimited(KERN_INFO "kvm: zapping shadow pages for mmio generation wraparound\n");
+		printk_ratelimited(KERN_DEBUG "kvm: zapping shadow pages for mmio generation wraparound\n");
 		kvm_mmu_invalidate_zap_all_pages(kvm);
 	}
 }
-- 
1.8.3.1

