Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab3LNOAV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 09:00:21 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42970 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab3LNOAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 09:00:19 -0500
Date: Sat, 14 Dec 2013 19:30:11 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org,
        josh@joshtriplett.org
Subject: [PATCH 2/3] drivers: edac: Mark the function
 edac_create_debug_nodes() as static in edac_mc_sysfs.c
Message-ID: <a1c863b08c0d6f67d03280cf908c771bf26a3239.1387029387.git.rashika.kheria@gmail.com>
References: <7cddbd4c69ed493f183383e98853181aaf75b26b.1387029387.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7cddbd4c69ed493f183383e98853181aaf75b26b.1387029387.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch marks the function edac_create_debug_nodes() as static in
edac_mc_sysfs.c because it is not used outside this file.

Thus, it also eliminates the following warning in edac_mc_sysfs.c:
drivers/edac/edac_mc_sysfs.c:917:5: warning: no previous prototype for ‘edac_create_debug_nodes’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/edac/edac_mc_sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 9f7e0e60..51c0362 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -914,7 +914,7 @@ void __exit edac_debugfs_exit(void)
 	debugfs_remove(edac_debugfs);
 }
 
-int edac_create_debug_nodes(struct mem_ctl_info *mci)
+static int edac_create_debug_nodes(struct mem_ctl_info *mci)
 {
 	struct dentry *d, *parent;
 	char name[80];
-- 
1.7.9.5

