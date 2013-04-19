Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246Ab3DSJjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 05:39:51 -0400
Received: from intranet.asianux.com ([58.214.24.6]:30904 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757677Ab3DSJju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 05:39:50 -0400
X-Spam-Score: -100.8
Message-ID: <517110BA.5070806@asianux.com>
Date: Fri, 19 Apr 2013 17:39:06 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel/audit_tree.c: tree will memory leak when failure occurs
 for audit_trim_trees()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


in audit_trim_trees(), has called get_tree() before failure occurs,
so need also call put_tree after go to skip_it:

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/audit_tree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index 642a89c..de46ec0 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -617,10 +617,10 @@ void audit_trim_trees(void)
 		}
 		spin_unlock(&hash_lock);
 		trim_marked(tree);
-		put_tree(tree);
 		drop_collected_mounts(root_mnt);
 skip_it:
 		mutex_lock(&audit_filter_mutex);
+		put_tree(tree);
 	}
 	list_del(&cursor);
 	mutex_unlock(&audit_filter_mutex);
-- 
1.7.7.6
