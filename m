Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637AbaJMLaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 07:30:25 -0400
Received: from ozlabs.org ([103.22.144.67]:51697 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083AbaJMLaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 07:30:23 -0400
Date: Mon, 13 Oct 2014 22:30:21 +1100
From: Anton Blanchard <anton@samba.org>
To: akpm@linux-foundation.org, mgorman@suse.de, rientjes@google.com,
        hannes@cmpxchg.org, riel@redhat.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mm: page_alloc: Convert boot printks without log level to
 pr_info
Message-ID: <20141013223021.431284a7@kryten>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: b/mm/page_alloc.c
===================================================================
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3894,14 +3894,14 @@ void __ref build_all_zonelists(pg_data_t
 	else
 		page_group_by_mobility_disabled = 0;
 
-	printk("Built %i zonelists in %s order, mobility grouping %s.  "
+	pr_info("Built %i zonelists in %s order, mobility grouping %s.  "
 		"Total pages: %ld\n",
 			nr_online_nodes,
 			zonelist_order_name[current_zonelist_order],
 			page_group_by_mobility_disabled ? "off" : "on",
 			vm_total_pages);
 #ifdef CONFIG_NUMA
-	printk("Policy zone: %s\n", zone_names[policy_zone]);
+	pr_info("Policy zone: %s\n", zone_names[policy_zone]);
 #endif
 }
 
@@ -5333,33 +5333,33 @@ void __init free_area_init_nodes(unsigne
 	find_zone_movable_pfns_for_nodes();
 
 	/* Print out the zone ranges */
-	printk("Zone ranges:\n");
+	pr_info("Zone ranges:\n");
 	for (i = 0; i < MAX_NR_ZONES; i++) {
 		if (i == ZONE_MOVABLE)
 			continue;
-		printk(KERN_CONT "  %-8s ", zone_names[i]);
+		pr_info("  %-8s ", zone_names[i]);
 		if (arch_zone_lowest_possible_pfn[i] ==
 				arch_zone_highest_possible_pfn[i])
-			printk(KERN_CONT "empty\n");
+			pr_cont("empty\n");
 		else
-			printk(KERN_CONT "[mem %0#10lx-%0#10lx]\n",
+			pr_cont("[mem %0#10lx-%0#10lx]\n",
 				arch_zone_lowest_possible_pfn[i] << PAGE_SHIFT,
 				(arch_zone_highest_possible_pfn[i]
 					<< PAGE_SHIFT) - 1);
 	}
 
 	/* Print out the PFNs ZONE_MOVABLE begins at in each node */
-	printk("Movable zone start for each node\n");
+	pr_info("Movable zone start for each node\n");
 	for (i = 0; i < MAX_NUMNODES; i++) {
 		if (zone_movable_pfn[i])
-			printk("  Node %d: %#010lx\n", i,
+			pr_info("  Node %d: %#010lx\n", i,
 			       zone_movable_pfn[i] << PAGE_SHIFT);
 	}
 
 	/* Print out the early node map */
-	printk("Early memory node ranges\n");
+	pr_info("Early memory node ranges\n");
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid)
-		printk("  node %3d: [mem %#010lx-%#010lx]\n", nid,
+		pr_info("  node %3d: [mem %#010lx-%#010lx]\n", nid,
 		       start_pfn << PAGE_SHIFT, (end_pfn << PAGE_SHIFT) - 1);
 
 	/* Initialise every node */
@@ -5495,7 +5495,7 @@ void __init mem_init_print_info(const ch
 
 #undef	adj_init_size
 
-	printk("Memory: %luK/%luK available "
+	pr_info("Memory: %luK/%luK available "
 	       "(%luK kernel code, %luK rwdata, %luK rodata, "
 	       "%luK init, %luK bss, %luK reserved"
 #ifdef	CONFIG_HIGHMEM
