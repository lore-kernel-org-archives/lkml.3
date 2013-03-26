Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934597Ab3CZOlc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 10:41:32 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:13114 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934527Ab3CZOlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 10:41:25 -0400
X-IronPort-AV: E=Sophos;i="4.84,911,1355097600"; 
   d="scan'208";a="14895951"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <Stefano.Stabellini@eu.citrix.com>, <konrad.wilk@oracle.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v2 4/6] xen/arm: implement HYPERVISOR_vcpu_op
Date: Tue, 26 Mar 2013 14:41:13 +0000
Message-ID: <1364308875-26484-4-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1303261423530.4430@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1303261423530.4430@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/include/asm/xen/hypercall.h |    1 +
 arch/arm/xen/enlighten.c             |    1 +
 arch/arm/xen/hypercall.S             |    1 +
 3 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/xen/hypercall.h b/arch/arm/include/asm/xen/hypercall.h
index 8a82325..799f42e 100644
--- a/arch/arm/include/asm/xen/hypercall.h
+++ b/arch/arm/include/asm/xen/hypercall.h
@@ -46,6 +46,7 @@ int HYPERVISOR_event_channel_op(int cmd, void *arg);
 unsigned long HYPERVISOR_hvm_op(int op, void *arg);
 int HYPERVISOR_memory_op(unsigned int cmd, void *arg);
 int HYPERVISOR_physdev_op(int cmd, void *arg);
+int HYPERVISOR_vcpu_op(int cmd, int vcpuid, void *extra_args);
 
 static inline void
 MULTI_update_va_mapping(struct multicall_entry *mcl, unsigned long va,
diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index 94bbf3b..b002822 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -295,4 +295,5 @@ EXPORT_SYMBOL_GPL(HYPERVISOR_sched_op);
 EXPORT_SYMBOL_GPL(HYPERVISOR_hvm_op);
 EXPORT_SYMBOL_GPL(HYPERVISOR_memory_op);
 EXPORT_SYMBOL_GPL(HYPERVISOR_physdev_op);
+EXPORT_SYMBOL_GPL(HYPERVISOR_vcpu_op);
 EXPORT_SYMBOL_GPL(privcmd_call);
diff --git a/arch/arm/xen/hypercall.S b/arch/arm/xen/hypercall.S
index 71f7239..199cb2d 100644
--- a/arch/arm/xen/hypercall.S
+++ b/arch/arm/xen/hypercall.S
@@ -87,6 +87,7 @@ HYPERCALL2(event_channel_op);
 HYPERCALL2(hvm_op);
 HYPERCALL2(memory_op);
 HYPERCALL2(physdev_op);
+HYPERCALL3(vcpu_op);
 
 ENTRY(privcmd_call)
 	stmdb sp!, {r4}
-- 
1.7.2.5

