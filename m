Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760455AbbA1ENw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:13:52 -0500
Received: from mail.kernel.org ([198.145.29.136]:36749 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760417AbbA1ENt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:13:49 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 006/177] KVM: s390: unintended fallthrough for external call
Date: Wed, 28 Jan 2015 12:06:19 +0800
Message-Id: <1422418236-12852-12-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit f346026e55f1efd3949a67ddd1dcea7c1b9a615e upstream.

We must not fallthrough if the conditions for external call are not met.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Thomas Huth <thuth@linux.vnet.ibm.com>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 arch/s390/kvm/interrupt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 10e13b3..df69bcb 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -43,6 +43,7 @@ static int __interrupt_is_deliverable(struct kvm_vcpu *vcpu,
 			return 0;
 		if (vcpu->arch.sie_block->gcr[0] & 0x2000ul)
 			return 1;
+		return 0;
 	case KVM_S390_INT_EMERGENCY:
 		if (psw_extint_disabled(vcpu))
 			return 0;
-- 
1.9.1

