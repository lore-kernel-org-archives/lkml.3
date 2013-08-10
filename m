Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030470Ab3HJQPL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 12:15:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33102 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964808Ab3HJQPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 12:15:03 -0400
Date: Sat, 10 Aug 2013 09:13:48 -0700
From: tip-bot for Jeremy Fitzhardinge <tipbot@zytor.com>
Message-ID: <tip-bf7aab3ad4b4364a293421d628a912a2153ee1ee@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, jeremy@goop.org,
        raghavendra.kt@linux.vnet.ibm.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jeremy@goop.org,
        raghavendra.kt@linux.vnet.ibm.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1376058122-8248-5-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
References: <1376058122-8248-5-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/spinlocks] xen:
  Defer spinlock setup until boot CPU setup
Git-Commit-ID: bf7aab3ad4b4364a293421d628a912a2153ee1ee
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 10 Aug 2013 09:13:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bf7aab3ad4b4364a293421d628a912a2153ee1ee
Gitweb:     http://git.kernel.org/tip/bf7aab3ad4b4364a293421d628a912a2153ee1ee
Author:     Jeremy Fitzhardinge <jeremy@goop.org>
AuthorDate: Fri, 9 Aug 2013 19:51:52 +0530
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 9 Aug 2013 07:53:18 -0700

xen: Defer spinlock setup until boot CPU setup

There's no need to do it at very early init, and doing it there
makes it impossible to use the jump_label machinery.

Signed-off-by: Jeremy Fitzhardinge <jeremy@goop.org>
Link: http://lkml.kernel.org/r/1376058122-8248-5-git-send-email-raghavendra.kt@linux.vnet.ibm.com
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
