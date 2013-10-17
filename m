Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab3JQOvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 10:51:19 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:48675 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756506Ab3JQOu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 10:50:58 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gleb@redhat.com, agraf@suse.de, chao.zhou@intel.com, magnus@boden.cx,
        kvm@vger.kernel.org
Subject: [PATCH 2/2] KVM: x86: fix KVM_SET_XCRS loop
Date: Thu, 17 Oct 2013 16:50:47 +0200
Message-Id: <1382021447-20216-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382021447-20216-1-git-send-email-pbonzini@redhat.com>
References: <1382021447-20216-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The loop was always using 0 as the index.  This means that
any rubbish after the first element of the array went undetected.
It seems reasonable to assume that no KVM userspace did that.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f4e1391..f91dff2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3062,9 +3062,9 @@ static int kvm_vcpu_ioctl_x86_set_xcrs(struct kvm_vcpu *vcpu,
 
 	for (i = 0; i < guest_xcrs->nr_xcrs; i++)
 		/* Only support XCR0 currently */
-		if (guest_xcrs->xcrs[0].xcr == XCR_XFEATURE_ENABLED_MASK) {
+		if (guest_xcrs->xcrs[i].xcr == XCR_XFEATURE_ENABLED_MASK) {
 			r = __kvm_set_xcr(vcpu, XCR_XFEATURE_ENABLED_MASK,
-				guest_xcrs->xcrs[0].value);
+				guest_xcrs->xcrs[i].value);
 			break;
 		}
 	if (r)
-- 
1.8.3.1

