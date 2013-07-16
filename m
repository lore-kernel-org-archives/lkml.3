Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547Ab3GPAye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 20:54:34 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:59447 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758530Ab3GPAyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 20:54:32 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Alexander Graf <agraf@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org
Subject: [PATCH 02/10] KVM: PPC: reserve a capability and ioctl numbers for realmode VFIO
Date: Tue, 16 Jul 2013 10:53:57 +1000
Message-Id: <1373936045-22653-3-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1373936045-22653-1-git-send-email-aik@ozlabs.ru>
References: <1373936045-22653-1-git-send-email-aik@ozlabs.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to reserve a capablity number for upcoming support
of VFIO-IOMMU DMA operations in real mode.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>

---
Changes:
2013/07/16:
* changed the number

2013/07/11:
* changed order in a file, added comment about a gap in ioctl number

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 include/uapi/linux/kvm.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 99c2533..53c3f1f 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -668,6 +668,7 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_IRQ_XICS 92
 #define KVM_CAP_ARM_EL1_32BIT 93
 #define KVM_CAP_SPAPR_MULTITCE 94
+#define KVM_CAP_SPAPR_TCE_IOMMU 95
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -933,6 +934,9 @@ struct kvm_s390_ucas_mapping {
 #define KVM_ARM_SET_DEVICE_ADDR	  _IOW(KVMIO,  0xab, struct kvm_arm_device_addr)
 /* Available with KVM_CAP_PPC_RTAS */
 #define KVM_PPC_RTAS_DEFINE_TOKEN _IOW(KVMIO,  0xac, struct kvm_rtas_token_args)
+/* 0xad and 0xaf are already taken */
+/* Available with KVM_CAP_SPAPR_TCE_IOMMU */
+#define KVM_CREATE_SPAPR_TCE_IOMMU _IOW(KVMIO,  0xaf, struct kvm_create_spapr_tce_iommu)
 
 /* ioctl for vm fd */
 #define KVM_CREATE_DEVICE	  _IOWR(KVMIO,  0xe0, struct kvm_create_device)
-- 
1.8.3.2

