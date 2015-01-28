Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760914AbbA2JPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:15:31 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44919 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932659AbbA2JIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:08:06 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 025/176] kvm: x86: drop severity of "generation wraparound" message
Date: Wed, 28 Jan 2015 15:27:35 +0100
Message-Id: <33309bc127c6068759d60552a85cb28497e25fcc.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a629df7eadffb03e6ce4a8616e62ea29fdf69b6b upstream.

Since most virtual machines raise this message once, it is a bit annoying.
Make it KERN_DEBUG severity.

Fixes: 7a2e8aaf0f6873b47bc2347f216ea5b0e4c258ab
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/kvm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 073b39d13696..8ad01b4e60cc 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4429,7 +4429,7 @@ void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm)
 	 * zap all shadow pages.
 	 */
 	if (unlikely(kvm_current_mmio_generation(kvm) == 0)) {
-		printk_ratelimited(KERN_INFO "kvm: zapping shadow pages for mmio generation wraparound\n");
+		printk_ratelimited(KERN_DEBUG "kvm: zapping shadow pages for mmio generation wraparound\n");
 		kvm_mmu_invalidate_zap_all_pages(kvm);
 	}
 }
-- 
2.2.2

