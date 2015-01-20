Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbbATTzv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 14:55:51 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:38829 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752471AbbATTzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 14:55:49 -0500
X-Sasl-enc: HhlgoVxo/uk/lJ3vfqi0v3bVmccQrkSrBz1Ew8/lv9n5 1421783748
From: Jon Bernard <jbernard@tuxion.com>
To: gregkh@linuxfoundation.org
Cc: oleg.drokin@intel.com, andreas.dilger@intel.com, HPDD-discuss@ml01.01.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jon Bernard <jbernard@tuxion.com>
Subject: [PATCH] staging: lustre: ptlrpc: fix lproc_ptlrpc static declarations
Date: Tue, 20 Jan 2015 14:55:28 -0500
Message-Id: <1421783728-14470-1-git-send-email-jbernard@tuxion.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following sparse warnings:

drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c:51:3:warning:
 symbol 'll_rpc_opcode_table' was not declared. Should it be static?
drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c:142:3: warning:
 symbol 'll_eopcode_table' was not declared. Should it be static?
drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c:178:12: warning:
 symbol 'll_eopcode2str' was not declared. Should it be static?
drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c:731:1: warning:
 symbol 'ptlrpc_lprocfs_svc_req_history_seek' was not declared. Should it be static?

Signed-off-by: Jon Bernard <jbernard@tuxion.com>
---
 drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c b/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
index 90448e9..0e2071b 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
@@ -45,7 +45,7 @@
 #include "ptlrpc_internal.h"
 
 
-struct ll_rpc_opcode {
+static struct ll_rpc_opcode {
 	__u32       opcode;
 	const char *opname;
 } ll_rpc_opcode_table[LUSTRE_MAX_OPCODES] = {
@@ -136,7 +136,7 @@ struct ll_rpc_opcode {
 	{ UPDATE_OBJ,	    "update_obj" },
 };
 
-struct ll_eopcode {
+static struct ll_eopcode {
 	__u32       opcode;
 	const char *opname;
 } ll_eopcode_table[EXTRA_LAST_OPC] = {
@@ -175,11 +175,12 @@ const char *ll_opcode2str(__u32 opcode)
 	return ll_rpc_opcode_table[offset].opname;
 }
 
-const char *ll_eopcode2str(__u32 opcode)
+static const char *ll_eopcode2str(__u32 opcode)
 {
 	LASSERT(ll_eopcode_table[opcode].opcode == opcode);
 	return ll_eopcode_table[opcode].opname;
 }
+
 #if defined (CONFIG_PROC_FS)
 static void ptlrpc_lprocfs_register(struct proc_dir_entry *root, char *dir,
 				    char *name,
@@ -727,7 +728,7 @@ struct ptlrpc_srh_iterator {
 	struct ptlrpc_request	*srhi_req;
 };
 
-int
+static int
 ptlrpc_lprocfs_svc_req_history_seek(struct ptlrpc_service_part *svcpt,
 				    struct ptlrpc_srh_iterator *srhi,
 				    __u64 seq)
-- 
1.9.1

