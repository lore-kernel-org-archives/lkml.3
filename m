Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760819AbaJ3SMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 14:12:13 -0400
Received: from smtprelay0086.hostedemail.com ([216.40.44.86]:43744 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760687AbaJ3SMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 14:12:09 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1543:1711:1730:1747:1777:1792:2393:2559:2562:2693:3138:3139:3140:3141:3142:3353:3865:3870:3872:4250:4605:5007:6117:6119:6261:7875:7903:8603:8957:10004:10848:11026:11473:11658:11914:12043:12296:12517:12519:12555:12683:14110:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: magic71_69e07a31aa922
X-Filterd-Recvd-Size: 4131
From: Joe Perches <joe@perches.com>
To: Chris Metcalf <cmetcalf@tilera.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] tile: Use pr_warn instead of pr_warning
Date: Thu, 30 Oct 2014 11:11:54 -0700
Message-Id: <92db7e80242fc8e6f751cfc8ca01468d035cd0c6.1414691783.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <cover.1414691783.git.joe@perches.com>
References: <cover.1414691783.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the more common pr_warn.

Coalesce formats, realign arguments.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/tile/kernel/setup.c | 33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index 6471cc5..7f079bb 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -534,11 +534,10 @@ static void __init setup_memory(void)
 			}
 		}
 		physpages -= dropped_pages;
-		pr_warning("Only using %ldMB memory;"
-		       " ignoring %ldMB.\n",
-		       physpages >> (20 - PAGE_SHIFT),
-		       dropped_pages >> (20 - PAGE_SHIFT));
-		pr_warning("Consider using a larger page size.\n");
+		pr_warn("Only using %ldMB memory - ignoring %ldMB\n",
+			physpages >> (20 - PAGE_SHIFT),
+			dropped_pages >> (20 - PAGE_SHIFT));
+		pr_warn("Consider using a larger page size\n");
 	}
 #endif
 
@@ -566,9 +565,8 @@ static void __init setup_memory(void)
 
 #ifndef __tilegx__
 	if (node_end_pfn[0] > MAXMEM_PFN) {
-		pr_warning("Only using %ldMB LOWMEM.\n",
-		       MAXMEM>>20);
-		pr_warning("Use a HIGHMEM enabled kernel.\n");
+		pr_warn("Only using %ldMB LOWMEM\n", MAXMEM >> 20);
+		pr_warn("Use a HIGHMEM enabled kernel\n");
 		max_low_pfn = MAXMEM_PFN;
 		max_pfn = MAXMEM_PFN;
 		node_end_pfn[0] = MAXMEM_PFN;
@@ -1112,8 +1110,8 @@ static void __init load_hv_initrd(void)
 	fd = hv_fs_findfile((HV_VirtAddr) initramfs_file);
 	if (fd == HV_ENOENT) {
 		if (set_initramfs_file) {
-			pr_warning("No such hvfs initramfs file '%s'\n",
-				   initramfs_file);
+			pr_warn("No such hvfs initramfs file '%s'\n",
+				initramfs_file);
 			return;
 		} else {
 			/* Try old backwards-compatible name. */
@@ -1126,8 +1124,8 @@ static void __init load_hv_initrd(void)
 	stat = hv_fs_fstat(fd);
 	BUG_ON(stat.size < 0);
 	if (stat.flags & HV_FS_ISDIR) {
-		pr_warning("Ignoring hvfs file '%s': it's a directory.\n",
-			   initramfs_file);
+		pr_warn("Ignoring hvfs file '%s': it's a directory\n",
+			initramfs_file);
 		return;
 	}
 	initrd = alloc_bootmem_pages(stat.size);
@@ -1185,9 +1183,8 @@ static void __init validate_hv(void)
 	HV_Topology topology = hv_inquire_topology();
 	BUG_ON(topology.coord.x != 0 || topology.coord.y != 0);
 	if (topology.width != 1 || topology.height != 1) {
-		pr_warning("Warning: booting UP kernel on %dx%d grid;"
-			   " will ignore all but first tile.\n",
-			   topology.width, topology.height);
+		pr_warn("Warning: booting UP kernel on %dx%d grid; will ignore all but first tile\n",
+			topology.width, topology.height);
 	}
 #endif
 
@@ -1393,7 +1390,7 @@ static void __init setup_cpu_maps(void)
 
 static int __init dataplane(char *str)
 {
-	pr_warning("WARNING: dataplane support disabled in this kernel\n");
+	pr_warn("WARNING: dataplane support disabled in this kernel\n");
 	return 0;
 }
 
@@ -1411,8 +1408,8 @@ void __init setup_arch(char **cmdline_p)
 	len = hv_get_command_line((HV_VirtAddr) boot_command_line,
 				  COMMAND_LINE_SIZE);
 	if (boot_command_line[0])
-		pr_warning("WARNING: ignoring dynamic command line \"%s\"\n",
-			   boot_command_line);
+		pr_warn("WARNING: ignoring dynamic command line \"%s\"\n",
+			boot_command_line);
 	strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
 #else
 	char *hv_cmdline;
-- 
2.1.2

