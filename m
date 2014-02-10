Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbaBJTlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:41:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34521 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbaBJTlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:41:36 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 003/124] KVM: s390: fix diagnose code extraction
Date: Mon, 10 Feb 2014 11:39:03 -0800
Message-Id: <1392061264-28124-4-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 743db27c526e0f31cc507959d662e97e2048a86f upstream.

The diagnose code to be used is the contents of the base register (if not
zero), plus the displacement. The current code ignores the base register
contents. So let's fix that...

Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/s390/kvm/diag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
index a390687..d3fc59e 100644
--- a/arch/s390/kvm/diag.c
+++ b/arch/s390/kvm/diag.c
@@ -106,7 +106,7 @@ static int __diag_ipl_functions(struct kvm_vcpu *vcpu)
 
 int kvm_s390_handle_diag(struct kvm_vcpu *vcpu)
 {
-	int code = (vcpu->arch.sie_block->ipb & 0xfff0000) >> 16;
+	int code = kvm_s390_get_base_disp_rs(vcpu) & 0xffff;
 
 	trace_kvm_s390_handle_diag(vcpu, code);
 	switch (code) {
-- 
1.8.3.2

