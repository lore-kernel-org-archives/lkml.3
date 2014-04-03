Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbaDCWSQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 18:18:16 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:40994 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbaDCWRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 18:17:40 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh@kernel.org>
Subject: [PATCH 11/20] of/fdt: remove unused of_scan_flat_dt_by_path
Date: Thu,  3 Apr 2014 17:16:54 -0500
Message-Id: <1396563423-30893-12-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396563423-30893-1-git-send-email-robherring2@gmail.com>
References: <1396563423-30893-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

of_scan_flat_dt_by_path is unused anywhere in the kernel, so remove it.

Signed-off-by: Rob Herring <robh@kernel.org>
---
 drivers/of/fdt.c       | 67 --------------------------------------------------
 include/linux/of_fdt.h |  3 ---
 2 files changed, 70 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 0139b65..9ba56df 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -672,73 +672,6 @@ struct fdt_scan_status {
 	void *data;
 };
 
-/**
- * fdt_scan_node_by_path - iterator for of_scan_flat_dt_by_path function
- */
-static int __init fdt_scan_node_by_path(unsigned long node, const char *uname,
-					int depth, void *data)
-{
-	struct fdt_scan_status *st = data;
-
-	/*
-	 * if scan at the requested fdt node has been completed,
-	 * return -ENXIO to abort further scanning
-	 */
-	if (depth <= st->depth)
-		return -ENXIO;
-
-	/* requested fdt node has been found, so call iterator function */
-	if (st->found)
-		return st->iterator(node, uname, depth, st->data);
-
-	/* check if scanning automata is entering next level of fdt nodes */
-	if (depth == st->depth + 1 &&
-	    strncmp(st->name, uname, st->namelen) == 0 &&
-	    uname[st->namelen] == 0) {
-		st->depth += 1;
-		if (st->name[st->namelen] == 0) {
-			st->found = 1;
-		} else {
-			const char *next = st->name + st->namelen + 1;
-			st->name = next;
-			st->namelen = strcspn(next, "/");
-		}
-		return 0;
-	}
-
-	/* scan next fdt node */
-	return 0;
-}
-
-/**
- * of_scan_flat_dt_by_path - scan flattened tree blob and call callback on each
- *			     child of the given path.
- * @path: path to start searching for children
- * @it: callback function
- * @data: context data pointer
- *
- * This function is used to scan the flattened device-tree starting from the
- * node given by path. It is used to extract information (like reserved
- * memory), which is required on ealy boot before we can unflatten the tree.
- */
-int __init of_scan_flat_dt_by_path(const char *path,
-	int (*it)(unsigned long node, const char *name, int depth, void *data),
-	void *data)
-{
-	struct fdt_scan_status st = {path, 0, -1, 0, it, data};
-	int ret = 0;
-
-	if (initial_boot_params)
-                ret = of_scan_flat_dt(fdt_scan_node_by_path, &st);
-
-	if (!st.found)
-		return -ENOENT;
-	else if (ret == -ENXIO)	/* scan has been completed */
-		return 0;
-	else
-		return ret;
-}
-
 const char * __init of_flat_dt_get_machine_name(void)
 {
 	const char *name;
diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
index d4d0efe..991ec74 100644
--- a/include/linux/of_fdt.h
+++ b/include/linux/of_fdt.h
@@ -93,9 +93,6 @@ extern void *of_get_flat_dt_prop(unsigned long node, const char *name,
 extern int of_flat_dt_is_compatible(unsigned long node, const char *name);
 extern int of_flat_dt_match(unsigned long node, const char *const *matches);
 extern unsigned long of_get_flat_dt_root(void);
-extern int of_scan_flat_dt_by_path(const char *path,
-	int (*it)(unsigned long node, const char *name, int depth, void *data),
-	void *data);
 
 extern int early_init_dt_scan_chosen(unsigned long node, const char *uname,
 				     int depth, void *data);
-- 
1.8.3.2

