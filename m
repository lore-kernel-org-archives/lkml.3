Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbaLHJu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 04:50:27 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:57245 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380AbaLHJuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 04:50:22 -0500
From: Fred Chou <fred.chou.nd@gmail.com>
X-Google-Original-From: Fred Chou
To: oleg.drokin@intel.com, andreas.dilger@intel.com,
        gregkh@linuxfoundation.org, gdonald@gmail.com, uja.ornl@gmail.com,
        askb23@gmail.com, Julia.Lawall@lip6.fr, lixi@ddn.com, joe@perches.com,
        fred.chou.nd@gmail.com, HPDD-discuss@ml01.01.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging:lustre:lustre:ptlrpc: fix sparse warnings in lproc_ptlrpc.c
Date: Mon,  8 Dec 2014 17:52:07 +0800
Message-Id: <1418032327-1719-1-git-send-email-fred.chou.nd@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fred Chou <fred.chou.nd@gmail.com>

Fixed the below warning in sparse:

drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c:184:6: 
warning: symbol 'ptlrpc_lprocfs_register' was not declared. 
Should it be static?

Signed-off-by: Fred Chou <fred.chou.nd@gmail.com>
---
 drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c b/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
index 4011e00..4c0d48e 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
@@ -181,9 +181,10 @@ const char *ll_eopcode2str(__u32 opcode)
 	return ll_eopcode_table[opcode].opname;
 }
 #if defined (CONFIG_PROC_FS)
-void ptlrpc_lprocfs_register(struct proc_dir_entry *root, char *dir,
-			     char *name, struct proc_dir_entry **procroot_ret,
-			     struct lprocfs_stats **stats_ret)
+static void ptlrpc_lprocfs_register(struct proc_dir_entry *root, char *dir,
+				    char *name,
+				    struct proc_dir_entry **procroot_ret,
+				    struct lprocfs_stats **stats_ret)
 {
 	struct proc_dir_entry *svc_procroot;
 	struct lprocfs_stats *svc_stats;
-- 
1.9.1

