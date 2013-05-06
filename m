Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab3EFHmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 03:42:00 -0400
Received: from intranet.asianux.com ([58.214.24.6]:9157 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab3EFHl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 03:41:58 -0400
X-Spam-Score: -100.8
Message-ID: <51875E96.30205@asianux.com>
Date: Mon, 06 May 2013 15:41:10 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH kernel-next] kernel/audit_tree.c: fix the original version
 merging issue for put_tree().
References: <517110BA.5070806@asianux.com> <20130422160409.471f6208099a972d26c29fb9@linux-foundation.org>
In-Reply-To: <20130422160409.471f6208099a972d26c29fb9@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


During version merging, added another redundant put_tree().

The related original patch: 1b4f5c2 kernel/audit_tree.c: tree will leak
memory when failure occurs in audit_trim_trees().

So need delete it, or it will cause issue.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/audit_tree.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index 9fd17f0..a291aa2 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -621,7 +621,6 @@ void audit_trim_trees(void)
 skip_it:
 		put_tree(tree);
 		mutex_lock(&audit_filter_mutex);
-		put_tree(tree);
 	}
 	list_del(&cursor);
 	mutex_unlock(&audit_filter_mutex);
-- 
1.7.7.6
