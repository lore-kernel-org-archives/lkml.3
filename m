Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbaAJSss (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 13:48:48 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:46755 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397AbaAJSso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 13:48:44 -0500
From: Davidlohr Bueso <davidlohr@hp.com>
To: akpm@linux-foundation.org, manfred@colorfullife.com
Cc: riel@redhat.com, aswin@hp.com, davidlohr@hp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] ipc: remove useless return statement
Date: Fri, 10 Jan 2014 10:48:23 -0800
Message-Id: <1389379707-20298-4-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389379707-20298-1-git-send-email-davidlohr@hp.com>
References: <1389379707-20298-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only found in ipc_rmid().

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 ipc/util.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/ipc/util.c b/ipc/util.c
index cfbd8fa..7afe7de 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -439,12 +439,8 @@ void ipc_rmid(struct ipc_ids *ids, struct kern_ipc_perm *ipcp)
 	int lid = ipcid_to_idx(ipcp->id);
 
 	idr_remove(&ids->ipcs_idr, lid);
-
 	ids->in_use--;
-
 	ipcp->deleted = true;
-
-	return;
 }
 
 /**
-- 
1.8.1.4

