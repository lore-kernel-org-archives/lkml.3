Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbaCHS7L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 13:59:11 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:58969 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbaCHS6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 13:58:32 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Ken Steele <ken@tilera.com>, Nicolas Pitre <nico@linaro.org>
Subject: [PATCH 4/4] raid6: Add severity levels to raid6 initialization messages
Date: Sat,  8 Mar 2014 10:58:15 -0800
Message-Id: <16072d10240583debb7d303136c507c32c4d4b5d.1394304585.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <cover.1394304585.git.luto@amacapital.net>
References: <cover.1394304585.git.luto@amacapital.net>
In-Reply-To: <cover.1394304585.git.luto@amacapital.net>
References: <cover.1394304585.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of them are errors; some are not.  Annotate them accordingly.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 lib/raid6/algos.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index f0b1aa3..6edc821 100644
--- a/lib/raid6/algos.c
+++ b/lib/raid6/algos.c
@@ -121,9 +121,10 @@ static inline const struct raid6_recov_calls *raid6_choose_recov(void)
 		raid6_2data_recov = best->data2;
 		raid6_datap_recov = best->datap;
 
-		printk("raid6: using %s recovery algorithm\n", best->name);
+		printk(KERN_DEBUG "raid6: using %s recovery algorithm\n",
+		       best->name);
 	} else
-		printk("raid6: Yikes! No recovery algorithm found!\n");
+		printk(KERN_ERR "raid6: Yikes! No recovery algorithm found!\n");
 
 	return best;
 }
@@ -157,18 +158,18 @@ static inline const struct raid6_calls *raid6_choose_gen(
 				bestperf = perf;
 				best = *algo;
 			}
-			printk("raid6: %-8s %5ld MB/s\n", (*algo)->name,
+			printk(KERN_DEBUG "raid6: %-8s %5ld MB/s\n", (*algo)->name,
 			       (perf*HZ) >> (20-16+RAID6_TIME_JIFFIES_LG2));
 		}
 	}
 
 	if (best) {
-		printk("raid6: using algorithm %s (%ld MB/s)\n",
+		printk(KERN_DEBUG "raid6: using algorithm %s (%ld MB/s)\n",
 		       best->name,
 		       (bestperf*HZ) >> (20-16+RAID6_TIME_JIFFIES_LG2));
 		raid6_call = *best;
 	} else
-		printk("raid6: Yikes!  No algorithm found!\n");
+		printk(KERN_ERR "raid6: Yikes!  No algorithm found!\n");
 
 	return best;
 }
@@ -194,7 +195,7 @@ int __init raid6_select_algo(void)
 	syndromes = (void *) __get_free_pages(GFP_KERNEL, 1);
 
 	if (!syndromes) {
-		printk("raid6: Yikes!  No memory available.\n");
+		printk(KERN_ERR "raid6: Yikes!  No memory available.\n");
 		return -ENOMEM;
 	}
 
-- 
1.8.5.3

