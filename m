Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab3H3BZ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 21:25:58 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:33876 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab3H3BZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 21:25:57 -0400
Message-ID: <521FF494.6000504@huawei.com>
Date: Fri, 30 Aug 2013 09:25:40 +0800
From: Jianguo Wu <wujianguo@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Rafael J . Wysocki" <rjw@sisk.pl>, <lenb@kernel.org>,
        <linux-acpi@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] mm/acpi: use NUMA_NO_NODE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.216]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use more appropriate NUMA_NO_NODE instead of -1

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
---
 drivers/acpi/acpi_memhotplug.c |    2 +-
 drivers/acpi/numa.c            |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index 999adb5..c00a3a7 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -281,7 +281,7 @@ static void acpi_memory_remove_memory(struct acpi_memory_device *mem_device)
 		if (!info->enabled)
 			continue;
 
-		if (nid < 0)
+		if (nid == NUMA_NO_NODE)
 			nid = memory_add_physaddr_to_nid(info->start_addr);
 
 		acpi_unbind_memory_blocks(info, handle);
diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
index 33e609f..09f79a2 100644
--- a/drivers/acpi/numa.c
+++ b/drivers/acpi/numa.c
@@ -73,7 +73,7 @@ int acpi_map_pxm_to_node(int pxm)
 {
 	int node = pxm_to_node_map[pxm];
 
-	if (node < 0) {
+	if (node == NUMA_NO_NODE) {
 		if (nodes_weight(nodes_found_map) >= MAX_NUMNODES)
 			return NUMA_NO_NODE;
 		node = first_unset_node(nodes_found_map);
@@ -334,7 +334,7 @@ int acpi_get_pxm(acpi_handle h)
 
 int acpi_get_node(acpi_handle *handle)
 {
-	int pxm, node = -1;
+	int pxm, node = NUMA_NO_NODE;
 
 	pxm = acpi_get_pxm(handle);
 	if (pxm >= 0 && pxm < MAX_PXM_DOMAINS)
-- 
1.7.1


