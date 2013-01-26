Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab3AZBd3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 20:33:29 -0500
Received: from mail-da0-f41.google.com ([209.85.210.41]:44384 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab3AZBbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 20:31:40 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, John McCutchan <john@johnmccutchan.com>,
        Robert Love <rlove@rlove.org>, Eric Paris <eparis@parisplace.org>
Subject: [PATCH 12/14] inotify: don't use idr_remove_all()
Date: Fri, 25 Jan 2013 17:31:10 -0800
Message-Id: <1359163872-1949-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359163872-1949-1-git-send-email-tj@kernel.org>
References: <1359163872-1949-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

idr_destroy() can destroy idr by itself and idr_remove_all() is being
deprecated.  Drop its usage.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: John McCutchan <john@johnmccutchan.com>
Cc: Robert Love <rlove@rlove.org>
Cc: Eric Paris <eparis@parisplace.org>
---
This patch depends on an earlier idr patch and given the trivial
nature of the patch, I think it would be best to route these together
through -mm.  Please holler if there's any objection.

Thanks.

 fs/notify/inotify/inotify_fsnotify.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
index 871569c..4216308 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -197,7 +197,6 @@ static void inotify_free_group_priv(struct fsnotify_group *group)
 {
 	/* ideally the idr is empty and we won't hit the BUG in the callback */
 	idr_for_each(&group->inotify_data.idr, idr_callback, group);
-	idr_remove_all(&group->inotify_data.idr);
 	idr_destroy(&group->inotify_data.idr);
 	atomic_dec(&group->inotify_data.user->inotify_devs);
 	free_uid(group->inotify_data.user);
-- 
1.8.1

