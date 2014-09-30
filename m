Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbaI3VlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:41:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32977 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405AbaI3VjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:39:20 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Howells <dhowells@redhat.com>, shemming@brocade.com,
        paulmck@linux.vnet.ibm.com, James Morris <james.l.morris@oracle.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 102/103] KEYS: Fix use-after-free in assoc_array_gc()
Date: Tue, 30 Sep 2014 14:31:47 -0700
Message-Id: <1412112708-27356-103-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit 27419604f51a97d497853f14142c1059d46eb597 upstream.

An edit script should be considered inaccessible by a function once it has
called assoc_array_apply_edit() or assoc_array_cancel_edit().

However, assoc_array_gc() is accessing the edit script just after the
gc_complete: label.

Reported-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
cc: shemming@brocade.com
cc: paulmck@linux.vnet.ibm.com
Signed-off-by: James Morris <james.l.morris@oracle.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 lib/assoc_array.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/assoc_array.c b/lib/assoc_array.c
index 76ae279..f9524b8 100644
--- a/lib/assoc_array.c
+++ b/lib/assoc_array.c
@@ -1737,7 +1737,7 @@ ascend_old_tree:
 gc_complete:
 	edit->set[0].to = new_root;
 	assoc_array_apply_edit(edit);
-	edit->array->nr_leaves_on_tree = nr_leaves_on_tree;
+	array->nr_leaves_on_tree = nr_leaves_on_tree;
 	return 0;
 
 enomem:
-- 
1.9.1

