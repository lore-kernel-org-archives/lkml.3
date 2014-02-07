Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbaBGLsk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:48:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41586 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079AbaBGLsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:48:35 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 043/233] KVM: s390: fix diagnose code extraction
Date: Fri,  7 Feb 2014 11:44:22 +0000
Message-Id: <1391773652-25214-44-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 743db27c526e0f31cc507959d662e97e2048a86f upstream.

The diagnose code to be used is the contents of the base register (if not
zero), plus the displacement. The current code ignores the base register
contents. So let's fix that...

Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/s390/kvm/diag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
index 3074475..0ae0ea6 100644
--- a/arch/s390/kvm/diag.c
+++ b/arch/s390/kvm/diag.c
@@ -130,7 +130,7 @@ static int __diag_virtio_hypercall(struct kvm_vcpu *vcpu)
 
 int kvm_s390_handle_diag(struct kvm_vcpu *vcpu)
 {
-	int code = (vcpu->arch.sie_block->ipb & 0xfff0000) >> 16;
+	int code = kvm_s390_get_base_disp_rs(vcpu) & 0xffff;
 
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
-- 
1.8.3.2

