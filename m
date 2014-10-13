Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbaJMMDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 08:03:19 -0400
Received: from ozlabs.org ([103.22.144.67]:39605 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753312AbaJMMDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 08:03:18 -0400
Date: Mon, 13 Oct 2014 23:03:16 +1100
From: Anton Blanchard <anton@samba.org>
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] lib/raid6: Add log level to printks
Message-ID: <20141013230316.1cbe1b7e@kryten>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: b/lib/raid6/algos.c
===================================================================
--- a/lib/raid6/algos.c
+++ b/lib/raid6/algos.c
@@ -121,9 +121,9 @@ static inline const struct raid6_recov_c
 		raid6_2data_recov = best->data2;
 		raid6_datap_recov = best->datap;
 
-		printk("raid6: using %s recovery algorithm\n", best->name);
+		pr_info("raid6: using %s recovery algorithm\n", best->name);
 	} else
-		printk("raid6: Yikes! No recovery algorithm found!\n");
+		pr_err("raid6: Yikes! No recovery algorithm found!\n");
 
 	return best;
 }
@@ -157,18 +157,18 @@ static inline const struct raid6_calls *
 				bestperf = perf;
 				best = *algo;
 			}
-			printk("raid6: %-8s %5ld MB/s\n", (*algo)->name,
+			pr_info("raid6: %-8s %5ld MB/s\n", (*algo)->name,
 			       (perf*HZ) >> (20-16+RAID6_TIME_JIFFIES_LG2));
 		}
 	}
 
 	if (best) {
-		printk("raid6: using algorithm %s (%ld MB/s)\n",
+		pr_info("raid6: using algorithm %s (%ld MB/s)\n",
 		       best->name,
 		       (bestperf*HZ) >> (20-16+RAID6_TIME_JIFFIES_LG2));
 		raid6_call = *best;
 	} else
-		printk("raid6: Yikes!  No algorithm found!\n");
+		pr_err("raid6: Yikes!  No algorithm found!\n");
 
 	return best;
 }
@@ -194,7 +194,7 @@ int __init raid6_select_algo(void)
 	syndromes = (void *) __get_free_pages(GFP_KERNEL, 1);
 
 	if (!syndromes) {
-		printk("raid6: Yikes!  No memory available.\n");
+		pr_err("raid6: Yikes!  No memory available.\n");
 		return -ENOMEM;
 	}
 
