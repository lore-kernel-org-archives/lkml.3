Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966901Ab3HHXUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 19:20:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41045 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966455Ab3HHXUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 19:20:52 -0400
Date: Thu, 8 Aug 2013 16:19:38 -0700
From: tip-bot for Jeremy Fitzhardinge <tipbot@zytor.com>
Message-ID: <tip-26dca1a3262c451846537d8c1f3f56290718b7d4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, jeremy@goop.org,
        raghavendra.kt@linux.vnet.ibm.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jeremy@goop.org,
        raghavendra.kt@linux.vnet.ibm.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <20130806114145.20643.7527.sendpatchset@codeblue.in.ibm.com>
References: <20130806114145.20643.7527.sendpatchset@codeblue.in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/spinlocks] xen:
  Defer spinlock setup until boot CPU setup
Git-Commit-ID: 26dca1a3262c451846537d8c1f3f56290718b7d4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 08 Aug 2013 16:19:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  26dca1a3262c451846537d8c1f3f56290718b7d4
Gitweb:     http://git.kernel.org/tip/26dca1a3262c451846537d8c1f3f56290718b7d4
Author:     Jeremy Fitzhardinge <jeremy@goop.org>
AuthorDate: Tue, 6 Aug 2013 17:11:45 +0530
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 8 Aug 2013 16:06:34 -0700

xen: Defer spinlock setup until boot CPU setup

There's no need to do it at very early init, and doing it there
makes it impossible to use the jump_label machinery.

Signed-off-by: Jeremy Fitzhardinge <jeremy@goop.org>
Link: http://lkml.kernel.org/r/20130806114145.20643.7527.sendpatchset@codeblue.in.ibm.com
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/xen/smp.c | 2 +-
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
