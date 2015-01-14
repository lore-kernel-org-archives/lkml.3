Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360AbbANH1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:27:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57876 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339AbbANH1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:27:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3.18 067/150] kvm: x86: drop severity of "generation wraparound" message
Date: Tue, 13 Jan 2015 23:22:18 -0800
Message-Id: <20150114072058.875372717@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit a629df7eadffb03e6ce4a8616e62ea29fdf69b6b upstream.

Since most virtual machines raise this message once, it is a bit annoying.
Make it KERN_DEBUG severity.

Fixes: 7a2e8aaf0f6873b47bc2347f216ea5b0e4c258ab
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4449,7 +4449,7 @@ void kvm_mmu_invalidate_mmio_sptes(struc
 	 * zap all shadow pages.
 	 */
 	if (unlikely(kvm_current_mmio_generation(kvm) == 0)) {
-		printk_ratelimited(KERN_INFO "kvm: zapping shadow pages for mmio generation wraparound\n");
+		printk_ratelimited(KERN_DEBUG "kvm: zapping shadow pages for mmio generation wraparound\n");
 		kvm_mmu_invalidate_zap_all_pages(kvm);
 	}
 }


