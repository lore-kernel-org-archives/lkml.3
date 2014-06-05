Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbaFEHZ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 03:25:58 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:53831 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbaFEHZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 03:25:53 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Alexander Graf <agraf@suse.de>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Subject: [PATCH 1/3] PPC: KVM: Reserve KVM_CAP_SPAPR_TCE_VFIO capability number
Date: Thu,  5 Jun 2014 17:25:42 +1000
Message-Id: <1401953144-19186-2-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1401953144-19186-1-git-send-email-aik@ozlabs.ru>
References: <1401953144-19186-1-git-send-email-aik@ozlabs.ru>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060507-1396-0000-0000-000004F7B3ED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a capability number for in-kernel support for VFIO on
SPAPR platform.

The capability will tell the user space whether in-kernel handlers of
H_PUT_TCE can handle VFIO-targeted requests or not. If not, the user space
must not attempt allocating a TCE table in the host kernel via
the KVM_CREATE_SPAPR_TCE KVM ioctl because in that case TCE requests
will not be passed to the user space which is desired action in
the situation like that.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 include/uapi/linux/kvm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index a8f4ee5..944cd21 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -743,6 +743,7 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_IOAPIC_POLARITY_IGNORED 97
 #define KVM_CAP_ENABLE_CAP_VM 98
 #define KVM_CAP_S390_IRQCHIP 99
+#define KVM_CAP_SPAPR_TCE_VFIO 100
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.0.0

