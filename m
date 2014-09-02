Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbaIBMwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 08:52:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbaIBMwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 08:52:33 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 4/5] KEYS: Fix use-after-free in assoc_array_gc()
From: David Howells <dhowells@redhat.com>
To: jmorris@namei.org
Cc: Andreea-Cristina Bernat <bernat.ada@gmail.com>, keyrings@linux-nfs.org,
        shemming@brocade.com, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, linux-security-module@vger.kernel.org,
        paulmck@linux.vnet.ibm.com
Date: Tue, 02 Sep 2014 13:52:20 +0100
Message-ID: <20140902125220.9247.32762.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140902125159.9247.11970.stgit@warthog.procyon.org.uk>
References: <20140902125159.9247.11970.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An edit script should be considered inaccessible by a function once it has
called assoc_array_apply_edit() or assoc_array_cancel_edit().

However, assoc_array_gc() is accessing the edit script just after the
gc_complete: label.

Reported-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
cc: shemming@brocade.com
cc: paulmck@linux.vnet.ibm.com
---

 lib/assoc_array.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/assoc_array.c b/lib/assoc_array.c
index c0b1007011e1..ae146f0734eb 100644
--- a/lib/assoc_array.c
+++ b/lib/assoc_array.c
@@ -1735,7 +1735,7 @@ ascend_old_tree:
 gc_complete:
 	edit->set[0].to = new_root;
 	assoc_array_apply_edit(edit);
-	edit->array->nr_leaves_on_tree = nr_leaves_on_tree;
+	array->nr_leaves_on_tree = nr_leaves_on_tree;
 	return 0;
 
 enomem:

