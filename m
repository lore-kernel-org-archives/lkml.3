Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab3FATSz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 15:18:55 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:49339 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211Ab3FATSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 15:18:44 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: <gleb@redhat.com>, <mingo@redhat.com>, <jeremy@goop.org>, <x86@kernel.org>,
        <konrad.wilk@oracle.com>, <hpa@zytor.com>, <pbonzini@redhat.com>
Cc: linux-doc@vger.kernel.org, <habanero@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        <xen-devel@lists.xensource.com>, <peterz@infradead.org>,
        <mtosatti@redhat.com>, <stefano.stabellini@eu.citrix.com>,
        <andi@firstfloor.org>, <attilio.rao@citrix.com>, <ouyang@cs.pitt.edu>,
        <gregkh@suse.de>, <agraf@suse.de>, <chegu_vinod@hp.com>,
        <torvalds@linux-foundation.org>, <avi.kivity@gmail.com>,
        <tglx@linutronix.de>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stephan.diestelhorst@amd.com>,
        <riel@redhat.com>, <drjones@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        <srivatsa.vaddagiri@gmail.com>
Date: Sun, 02 Jun 2013 00:52:43 +0530
Message-Id: <20130601192243.5966.80786.sendpatchset@codeblue>
In-Reply-To: <20130601192125.5966.35563.sendpatchset@codeblue>
References: <20130601192125.5966.35563.sendpatchset@codeblue>
Subject: [PATCH RFC V9 4/19]  xen: Defer spinlock setup until boot CPU setup
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060119-9264-0000-0000-000003DB40E1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xen: Defer spinlock setup until boot CPU setup

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

There's no need to do it at very early init, and doing it there
makes it impossible to use the jump_label machinery.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
 arch/x86/xen/smp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 8ff3799..dcdc91c 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -246,6 +246,7 @@ static void __init xen_smp_prepare_boot_cpu(void)
 
 	xen_filter_cpu_maps();
 	xen_setup_vcpu_info_placement();
+	xen_init_spinlocks();
 }
 
 static void __init xen_smp_prepare_cpus(unsigned int max_cpus)
@@ -647,7 +648,6 @@ void __init xen_smp_init(void)
 {
 	smp_ops = xen_smp_ops;
 	xen_fill_possible_map();
-	xen_init_spinlocks();
 }
 
 static void __init xen_hvm_smp_prepare_cpus(unsigned int max_cpus)

