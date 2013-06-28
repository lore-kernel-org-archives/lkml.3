Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab3F1TFk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:05:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41883 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab3F1S5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:57:33 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 095/105] ARM: 7762/1: kernel: fix arm_dt_init_cpu_maps() to skip non-cpu nodes
Date: Fri, 28 Jun 2013 11:51:57 -0700
Message-Id: <1372445527-24414-96-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>

commit 1ba9bf0a9ae779c1a2b3eb64951e4161d9bad7a9 upstream.

The introduction of the cpu-map topology node in the cpus node implies
that cpus node might have children that are not cpu nodes. The DT
parsing code needs updating otherwise it would check for cpu nodes
properties in nodes that are not required to contain them, resulting
in warnings that have no bearing on bindings defined in the dts source file.

Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/kernel/devtree.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
index 70f1bde..93fde23 100644
--- a/arch/arm/kernel/devtree.c
+++ b/arch/arm/kernel/devtree.c
@@ -92,6 +92,9 @@ void __init arm_dt_init_cpu_maps(void)
 	for_each_child_of_node(cpus, cpu) {
 		u32 hwid;
 
+		if (of_node_cmp(cpu->type, "cpu"))
+			continue;
+
 		pr_debug(" * %s...\n", cpu->full_name);
 		/*
 		 * A device tree containing CPU nodes with missing "reg"
-- 
1.8.1.2

