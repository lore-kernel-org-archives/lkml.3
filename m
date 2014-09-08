Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126AbaIHWHE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 18:07:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35717 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754832AbaIHWG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 18:06:58 -0400
Date: Mon, 8 Sep 2014 23:06:54 +0100
From: Mel Gorman <mgorman@suse.de>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] percpu: Resolve ambiguities in __get_cpu_var/cpumask_var_t
 -fix
Message-ID: <20140908220654.GO17501@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A commit in linux-next was causing boot to fail and bisection identified
the patch "percpu: Resolve ambiguities in __get_cpu_var/cpumask_var_".
The commit ID is worthless as it's a linux-next commit. One of the changes
in that patch looks very suspicious. Reverting the full patch fixes boot
as does this fixlet.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 arch/x86/kernel/apic/x2apic_cluster.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 1f5d5f2..e658f21 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -43,6 +43,7 @@ __x2apic_send_IPI_mask(const struct cpumask *mask, int vector, int apic_dest)
 	 * and be sure it's manipulated with irq off.
 	 */
 	ipi_mask_ptr = this_cpu_cpumask_var_ptr(ipi_mask);
+	cpumask_copy(ipi_mask_ptr, mask);
 
 	/*
 	 * The idea is to send one IPI per cluster.
