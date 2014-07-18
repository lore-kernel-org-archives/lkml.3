Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762430AbaGRPfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 11:35:00 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:63834 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762241AbaGRPe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 11:34:58 -0400
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net
Cc: dcb314@hotmail.com, jason.wessel@windriver.com,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>
Subject: [PATCH 4/5] kernel/debug/kdb/kdb_bp.c: drop negativity check on unsigned value
Date: Fri, 18 Jul 2014 18:34:52 +0300
Message-Id: <1405697692-23816-1-git-send-email-andrey.krieger.utkin@gmail.com>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=80591
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
---
 kernel/debug/kdb/kdb_bp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/debug/kdb/kdb_bp.c b/kernel/debug/kdb/kdb_bp.c
index 70a5046..f27dfb8 100644
--- a/kernel/debug/kdb/kdb_bp.c
+++ b/kernel/debug/kdb/kdb_bp.c
@@ -39,7 +39,7 @@ static char *kdb_rwtypes[] = {
 
 static char *kdb_bptype(kdb_bp_t *bp)
 {
-	if (bp->bp_type < 0 || bp->bp_type > 4)
+	if (bp->bp_type > 4)
 		return "";
 
 	return kdb_rwtypes[bp->bp_type];
-- 
1.8.5.5

