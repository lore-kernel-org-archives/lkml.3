Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbaIOUlH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:41:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55183 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582AbaIOTgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:36:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andreea-Cristina Bernat <bernat.ada@gmail.com>,
        David Howells <dhowells@redhat.com>, shemming@brocade.com,
        paulmck@linux.vnet.ibm.com, James Morris <james.l.morris@oracle.com>
Subject: [PATCH 3.16 157/158] KEYS: Fix use-after-free in assoc_array_gc()
Date: Mon, 15 Sep 2014 12:26:36 -0700
Message-Id: <20140915192547.583527598@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/assoc_array.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


