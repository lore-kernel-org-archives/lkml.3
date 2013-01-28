Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab3A1DaR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 22:30:17 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:36660 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab3A1DaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 22:30:15 -0500
Date: Mon, 28 Jan 2013 11:30:47 +0800
From: Wang YanQing <udknight@gmail.com>
To: mingo@kernel.org
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-tip-commits@vger.kernel.org, akpm@linux-foundation.org,
        hpa@zytor.com, paulmck@linux.vnet.ibm.com, stable@kernel.org,
        tglx@linutronix.de
Subject: [PATCH] smp:Fix use un-initialized cpumask_ipi
Message-ID: <20130128033047.GA3024@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>, mingo@kernel.org,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-tip-commits@vger.kernel.org, akpm@linux-foundation.org,
	hpa@zytor.com, paulmck@linux.vnet.ibm.com, stable@kernel.org,
	tglx@linutronix.de
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

c7b798525b50256c8084215a139fa40b0114bfcc
[smp: Fix SMP function call empty cpu mask race]
use the un-initialized variable cpumask_ipi when
enable CONFIG_CPUMASK_OFFSTACK.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 I am sorry for miss it, I just think it when I 
 was lying on the bed last night. :)

 kernel/smp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/smp.c b/kernel/smp.c
index 7c56aba..a38aa18 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -57,6 +57,9 @@ hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		if (!zalloc_cpumask_var_node(&cfd->cpumask, GFP_KERNEL,
 				cpu_to_node(cpu)))
 			return notifier_from_errno(-ENOMEM);
+		if (!zalloc_cpumask_var_node(&cfd->cpumask_ipi, GFP_KERNEL,
+				cpu_to_node(cpu)))
+			return notifier_from_errno(-ENOMEM);
 		break;
 
 #ifdef CONFIG_HOTPLUG_CPU
-- 
1.7.11.1.116.g8228a23
