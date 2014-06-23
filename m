Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbaFWQvG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 12:51:06 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:64767 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755137AbaFWQvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 12:51:03 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApkHAExaqFNbskjJ/2dsb2JhbABZgw2rZwUBAQEBAQEFAZk1gQ8XdYQxLyOBGjeIRgHEKReFY4kZHYQtBJpMk2ODRDs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>
Subject: [PATCH 1/1] FS/DLM:  replace count*size kzalloc by kcalloc
Date: Mon, 23 Jun 2014 18:49:43 +0200
Message-Id: <1403542183-11601-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kcalloc manages count*sizeof overflow.

Cc: Christine Caulfield <ccaulfie@redhat.com>
Cc: David Teigland <teigland@redhat.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/dlm/lock.c   | 2 +-
 fs/dlm/member.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 83f3d55..3653dbe 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -1427,7 +1427,7 @@ void dlm_scan_waiters(struct dlm_ls *ls)
 
 		if (!num_nodes) {
 			num_nodes = ls->ls_num_nodes;
-			warned = kzalloc(num_nodes * sizeof(int), GFP_KERNEL);
+			warned = kcalloc(num_nodes, sizeof(int), GFP_KERNEL);
 		}
 		if (!warned)
 			continue;
diff --git a/fs/dlm/member.c b/fs/dlm/member.c
index 9c47f1c..aa57ac3 100644
--- a/fs/dlm/member.c
+++ b/fs/dlm/member.c
@@ -218,7 +218,7 @@ int dlm_slots_assign(struct dlm_ls *ls, int *num_slots, int *slots_size,
 
 	array_size = max + need;
 
-	array = kzalloc(array_size * sizeof(struct dlm_slot), GFP_NOFS);
+	array = kcalloc(array_size, sizeof(struct dlm_slot), GFP_NOFS);
 	if (!array)
 		return -ENOMEM;
 
@@ -493,7 +493,7 @@ void dlm_lsop_recover_done(struct dlm_ls *ls)
 
 	num = ls->ls_num_nodes;
 
-	slots = kzalloc(num * sizeof(struct dlm_slot), GFP_KERNEL);
+	slots = kcalloc(num, sizeof(struct dlm_slot), GFP_KERNEL);
 	if (!slots)
 		return;
 
-- 
1.8.4.5

