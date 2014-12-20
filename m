Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251AbaLTUlx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 15:41:53 -0500
Received: from mail-qg0-f51.google.com ([209.85.192.51]:48788 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbaLTUlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 15:41:50 -0500
From: Spencer Baugh <sbaugh@andrew.cmu.edu>
To: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Spencer Baugh <sbaugh@andrew.cmu.edu>,
        HPDD-discuss@ml01.01.org (moderated list:STAGING - LUSTRE...),
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] lustre: ptlrpc: add "ptlrpc_internal.h" to sec_gc.c
Date: Sat, 20 Dec 2014 15:48:13 -0500
Message-Id: <1419108495-29739-1-git-send-email-sbaugh@andrew.cmu.edu>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ptlrpc_internal.h contains the prototypes for sptlrpc_gc_init() and
sptlrpc_gc_fini(), which are defined in sec_gc.c.

This removes the following sparse warnings:

drivers/staging/lustre/lustre/ptlrpc/sec_gc.c:217:5: warning: symbol 'sptlrpc_gc_init' was not declared. Should it be static?
drivers/staging/lustre/lustre/ptlrpc/sec_gc.c:241:6: warning: symbol 'sptlrpc_gc_fini' was not declared. Should it be static?

Signed-off-by: Spencer Baugh <sbaugh@andrew.cmu.edu>
---
 drivers/staging/lustre/lustre/ptlrpc/sec_gc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec_gc.c b/drivers/staging/lustre/lustre/ptlrpc/sec_gc.c
index c500aff..81de68e 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec_gc.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec_gc.c
@@ -47,6 +47,8 @@
 #include "../include/lustre_net.h"
 #include "../include/lustre_sec.h"
 
+#include "ptlrpc_internal.h"
+
 #define SEC_GC_INTERVAL (30 * 60)
 
 
-- 
2.1.3

