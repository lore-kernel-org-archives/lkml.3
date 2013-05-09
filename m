Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab3EIW1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:27:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45922 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756492Ab3EIW06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:26:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chen Gang <gang.chen@asianux.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Paris <eparis@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [ 73/73] kernel/audit_tree.c: tree will leak memory when failure occurs in audit_trim_trees()
Date: Thu,  9 May 2013 15:26:03 -0700
Message-Id: <20130509222533.798064892@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222526.480204972@linuxfoundation.org>
References: <20130509222526.480204972@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Gang <gang.chen@asianux.com>

commit 12b2f117f3bf738c1a00a6f64393f1953a740bd4 upstream.

audit_trim_trees() calls get_tree().  If a failure occurs we must call
put_tree().

[akpm@linux-foundation.org: run put_tree() before mutex_lock() for small scalability improvement]
Signed-off-by: Chen Gang <gang.chen@asianux.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/audit_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -617,9 +617,9 @@ void audit_trim_trees(void)
 		}
 		spin_unlock(&hash_lock);
 		trim_marked(tree);
-		put_tree(tree);
 		drop_collected_mounts(root_mnt);
 skip_it:
+		put_tree(tree);
 		mutex_lock(&audit_filter_mutex);
 	}
 	list_del(&cursor);


