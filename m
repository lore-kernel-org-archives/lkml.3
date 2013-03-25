Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab3CZXeF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:34:05 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:44707 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab3CZXeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 19:34:01 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Christine Caulfield <ccaulfie@redhat.com>
Cc: David Teigland <teigland@redhat.com>, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] fs: dlm: Use kmemdup
Date: Mon, 25 Mar 2013 23:19:58 +0200
Message-Id: <1364246398-26926-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kmemdup instead of kmalloc followed by memcpy.
Patch found using coccinelle.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 fs/dlm/lowcomms.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 4f5ad24..bfd6fbc 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -1213,10 +1213,9 @@ static void init_local(void)
 		if (dlm_our_addr(&sas, i))
 			break;
 
-		addr = kmalloc(sizeof(*addr), GFP_NOFS);
+		addr = kmemdup(&sas, sizeof(*addr), GFP_NOFS);
 		if (!addr)
 			break;
-		memcpy(addr, &sas, sizeof(*addr));
 		dlm_local_addr[dlm_local_count++] = addr;
 	}
 }
-- 
1.7.9.5

