Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbbALTpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:45:24 -0500
Received: from mail-yk0-f173.google.com ([209.85.160.173]:58513 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbbALTpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 14:45:23 -0500
From: Brian Norris <computersforpeace@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: <linux-kernel@vger.kernel.org>, Brian Norris <computersforpeace@gmail.com>,
        kgdb-bugreport@lists.sourceforge.net,
        Daniel Thompson <daniel.thompson@linaro.org>
Subject: [PATCH] kgdb: fix potential out-of-bounds access
Date: Mon, 12 Jan 2015 11:45:00 -0800
Message-Id: <1421091900-19249-1-git-send-email-computersforpeace@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPU arrays (e.g., kgdb_info[]) are indexed from 0 (inclusive) to NR_CPUS
(exclusive).

Pointed out by Coverity, CID 1262269

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
---
Untested

 kernel/debug/kdb/kdb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index f191bddf64b8..53f051853f14 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -2256,7 +2256,7 @@ static int kdb_cpu(int argc, const char **argv)
 	/*
 	 * Validate cpunum
 	 */
-	if ((cpunum > NR_CPUS) || !kgdb_info[cpunum].enter_kgdb)
+	if ((cpunum >= NR_CPUS) || !kgdb_info[cpunum].enter_kgdb)
 		return KDB_BADCPUNUM;
 
 	dbg_switch_cpu = cpunum;
-- 
1.9.1

