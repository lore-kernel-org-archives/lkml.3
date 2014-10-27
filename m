Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbaJ0T1z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:27:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52374 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbaJ0S5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:57:41 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 015/105] KVM: s390: unintended fallthrough for external call
Date: Mon, 27 Oct 2014 11:55:50 -0700
Message-Id: <1414436240-13879-16-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Borntraeger <borntraeger@de.ibm.com>

commit f346026e55f1efd3949a67ddd1dcea7c1b9a615e upstream.

We must not fallthrough if the conditions for external call are not met.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Thomas Huth <thuth@linux.vnet.ibm.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/s390/kvm/interrupt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 5f79d2d..f1ba119 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -71,6 +71,7 @@ static int __interrupt_is_deliverable(struct kvm_vcpu *vcpu,
 			return 0;
 		if (vcpu->arch.sie_block->gcr[0] & 0x2000ul)
 			return 1;
+		return 0;
 	case KVM_S390_INT_EMERGENCY:
 		if (psw_extint_disabled(vcpu))
 			return 0;
-- 
1.9.1

