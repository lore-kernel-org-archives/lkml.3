Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab3HFLsi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 07:48:38 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:44895 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756174Ab3HFLsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 07:48:31 -0400
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
        <linux-kernel@vger.kernel.org>, <riel@redhat.com>,
        <drjones@redhat.com>, <virtualization@lists.linux-foundation.org>,
        <srivatsa.vaddagiri@gmail.com>
Date: Tue, 06 Aug 2013 17:11:45 +0530
Message-Id: <20130806114145.20643.7527.sendpatchset@codeblue.in.ibm.com>
In-Reply-To: <20130806114020.20643.57235.sendpatchset@codeblue.in.ibm.com>
References: <20130806114020.20643.57235.sendpatchset@codeblue.in.ibm.com>
Subject: [PATCH  V12 4/14] xen: Defer spinlock setup until boot CPU setup
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080611-5806-0000-0000-000022508E9B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xen: Defer spinlock setup until boot CPU setup

From: Jeremy Fitzhardinge <jeremy@goop.org>

There's no need to do it at very early init, and doing it there
makes it impossible to use the jump_label machinery.

Signed-off-by: Jeremy Fitzhardinge <jeremy@goop.org>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/xen/smp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index ca92754..3b52d80 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -279,6 +279,7 @@ static void __init xen_smp_prepare_boot_cpu(void)
 
 	xen_filter_cpu_maps();
 	xen_setup_vcpu_info_placement();
+	xen_init_spinlocks();
 }
 
 static void __init xen_smp_prepare_cpus(unsigned int max_cpus)
@@ -680,7 +681,6 @@ void __init xen_smp_init(void)
 {
 	smp_ops = xen_smp_ops;
 	xen_fill_possible_map();
-	xen_init_spinlocks();
 }
 
 static void __init xen_hvm_smp_prepare_cpus(unsigned int max_cpus)

