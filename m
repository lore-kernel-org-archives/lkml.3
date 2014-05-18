Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751766AbaERPz0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 11:55:26 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:55586 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbaERPzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 11:55:25 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Masood Mehmood <ody.guru@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: tidspbridge: rmgr: node.c:  Fix for possible null pointer dereference
Date: Sun, 18 May 2014 17:56:10 +0200
Message-Id: <1400428570-9904-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removde unnecessary check for null pointer.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/tidspbridge/rmgr/node.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/tidspbridge/rmgr/node.c b/drivers/staging/tidspbridge/rmgr/node.c
index 9d3044a..d918f7f 100644
--- a/drivers/staging/tidspbridge/rmgr/node.c
+++ b/drivers/staging/tidspbridge/rmgr/node.c
@@ -2365,8 +2365,6 @@ static void delete_node(struct node_object *hnode,
 	    (struct proc_object *)hnode->processor;
 #endif
 	int status;
-	if (!hnode)
-		goto func_end;
 	hnode_mgr = hnode->node_mgr;
 	if (!hnode_mgr)
 		goto func_end;
-- 
1.7.10.4

