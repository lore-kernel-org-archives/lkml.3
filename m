Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667AbaIETtE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 15:49:04 -0400
Received: from amersmtp1.software.dell.com ([12.106.87.226]:34119 "EHLO
	amersmtp1.software.dell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750776AbaIETtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 15:49:02 -0400
X-Greylist: delayed 910 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Sep 2014 15:49:02 EDT
From: Ted Percival <ted@tedp.id.au>
To: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, Ted Percival <ted@tedp.id.au>
Subject: [PATCH] x86: Restore missing cpumask_copy() in __x2apic_send_IPI_mask
Date: Fri, 5 Sep 2014 13:34:31 -0600
Message-ID: <1409945671-4541-1-git-send-email-ted@tedp.id.au>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Mlf-Version: 7.4.4.8437
X-Mlf-UniqueId: o201409051933520163302
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a hang when initializing SMP CPUs at this point in the boot:

x86: Booting SMP configuration
.... node  #0, CPUs:      #1_

Fixes: 4ba2968420fa ("percpu: Resolve ambiguities in __get_cpu_var/cpumask_var_t")
Signed-off-by: Ted Percival <ted@tedp.id.au>
---
 arch/x86/kernel/apic/x2apic_cluster.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 1f5d5f2ffae6..e658f21681c8 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -43,6 +43,7 @@ __x2apic_send_IPI_mask(const struct cpumask *mask, int vector, int apic_dest)
 	 * and be sure it's manipulated with irq off.
 	 */
 	ipi_mask_ptr = this_cpu_cpumask_var_ptr(ipi_mask);
+	cpumask_copy(ipi_mask_ptr, mask);
 
 	/*
 	 * The idea is to send one IPI per cluster.
-- 
1.9.1

