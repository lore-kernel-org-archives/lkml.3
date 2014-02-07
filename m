Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbaBGLaG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:30:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41189 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbaBGLZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:25:13 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 77/88] KVM: s390: fix diagnose code extraction
Date: Fri,  7 Feb 2014 11:23:14 +0000
Message-Id: <1391772205-22239-78-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
References: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.30 -stable review patch.  If anyone has any objections, please let me know.

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
index b23d9ac..e071600 100644
--- a/arch/s390/kvm/diag.c
+++ b/arch/s390/kvm/diag.c
@@ -103,7 +103,7 @@ static int __diag_ipl_functions(struct kvm_vcpu *vcpu)
 
 int kvm_s390_handle_diag(struct kvm_vcpu *vcpu)
 {
-	int code = (vcpu->arch.sie_block->ipb & 0xfff0000) >> 16;
+	int code = kvm_s390_get_base_disp_rs(vcpu) & 0xffff;
 
 	switch (code) {
 	case 0x10:
-- 
1.8.3.2

