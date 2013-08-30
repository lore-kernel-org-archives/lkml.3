Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab3H3B37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 21:29:59 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:35355 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab3H3B36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 21:29:58 -0400
Message-ID: <521FF57A.8080702@huawei.com>
Date: Fri, 30 Aug 2013 09:29:30 +0800
From: Jianguo Wu <wujianguo@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, <tglx@linutronix.de>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        David Rientjes <rientjes@google.com>, <mingo@redhat.com>
Subject: [PATCH 3/4] x86/srat: use NUMA_NO_NODE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.216]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

setup_node() return NUMA_NO_NODE or valid node id(>=0), So use more appropriate
"if (node == NUMA_NO_NODE)" instead of "if (node < 0)"

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
---
 arch/x86/mm/srat.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index cdd0da9..97fea4e 100644
--- a/arch/x86/mm/srat.c
+++ b/arch/x86/mm/srat.c
@@ -76,7 +76,7 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
 		return;
 	}
 	node = setup_node(pxm);
-	if (node < 0) {
+	if (node == NUMA_NO_NODE) {
 		printk(KERN_ERR "SRAT: Too many proximity domains %x\n", pxm);
 		bad_srat();
 		return;
@@ -112,7 +112,7 @@ acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
 	if (acpi_srat_revision >= 2)
 		pxm |= *((unsigned int*)pa->proximity_domain_hi) << 8;
 	node = setup_node(pxm);
-	if (node < 0) {
+	if (node == NUMA_NO_NODE) {
 		printk(KERN_ERR "SRAT: Too many proximity domains %x\n", pxm);
 		bad_srat();
 		return;
@@ -164,7 +164,7 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 		pxm &= 0xff;
 
 	node = setup_node(pxm);
-	if (node < 0) {
+	if (node == NUMA_NO_NODE) {
 		printk(KERN_ERR "SRAT: Too many proximity domains.\n");
 		goto out_err_bad_srat;
 	}
-- 
1.7.1


