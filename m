Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123AbbALSgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:36:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58429 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261AbbALSay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:30:54 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 198/216] kvm: x86: drop severity of "generation wraparound" message
Date: Mon, 12 Jan 2015 18:29:36 +0000
Message-Id: <1421087394-2712-86-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit a629df7eadffb03e6ce4a8616e62ea29fdf69b6b upstream.

Since most virtual machines raise this message once, it is a bit annoying.
Make it KERN_DEBUG severity.

Fixes: 7a2e8aaf0f6873b47bc2347f216ea5b0e4c258ab
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kvm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 1cd2a5fbde07..1bbf6861507e 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4433,7 +4433,7 @@ void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm)
 	 * zap all shadow pages.
 	 */
 	if (unlikely(kvm_current_mmio_generation(kvm) == 0)) {
-		printk_ratelimited(KERN_INFO "kvm: zapping shadow pages for mmio generation wraparound\n");
+		printk_ratelimited(KERN_DEBUG "kvm: zapping shadow pages for mmio generation wraparound\n");
 		kvm_mmu_invalidate_zap_all_pages(kvm);
 	}
 }
-- 
2.1.4

