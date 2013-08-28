Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab3H1Ilc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 04:41:32 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:51832 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876Ab3H1Iii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 04:38:38 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Gleb Natapov <gleb@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Alexander Graf <agraf@suse.de>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v9 07/13] KVM: PPC: enable IOMMU_API for KVM_BOOK3S_64 permanently
Date: Wed, 28 Aug 2013 18:37:44 +1000
Message-Id: <1377679070-3515-8-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.8.4.rc4
In-Reply-To: <1377679070-3515-1-git-send-email-aik@ozlabs.ru>
References: <1377679070-3515-1-git-send-email-aik@ozlabs.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It does not make much sense to have KVM in book3s-64bit and
not to have IOMMU bits for PCI pass through support as it costs little
and allows VFIO to function on book3s-kvm.

Having IOMMU_API always enabled makes it unnecessary to have a lot of
"#ifdef IOMMU_API" in arch/powerpc/kvm/book3s_64_vio*. With those
ifdef's we could have only user space emulated devices accelerated
(but not VFIO) which do not seem to be very useful.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/kvm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index c55c538..3b2b761 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -59,6 +59,7 @@ config KVM_BOOK3S_64
 	depends on PPC_BOOK3S_64
 	select KVM_BOOK3S_64_HANDLER
 	select KVM
+	select SPAPR_TCE_IOMMU
 	---help---
 	  Support running unmodified book3s_64 and book3s_32 guest kernels
 	  in virtual machines on book3s_64 host processors.
-- 
1.8.4.rc4

