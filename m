Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbaIYSux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 14:50:53 -0400
Received: from mail-yh0-f54.google.com ([209.85.213.54]:37449 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbaIYSuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 14:50:52 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        dm-devel@redhat.com (maintainer:DEVICE-MAPPER (LVM)),
        Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org (open list)
Cc: paulmck@linux.vnet.ibm.com, josh@joshtriplett.org
Subject: [PATCH] dm: sparse: Annotate field with __rcu for checking
Date: Thu, 25 Sep 2014 14:50:43 -0400
Message-Id: <1411671049-20441-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Annotate the map field with __rcu since this is a rcu pointer which is checked
by sparse.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 drivers/md/dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 32b958d..746411b 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -140,7 +140,7 @@ struct mapped_device {
 	 * Use dm_get_live_table{_fast} or take suspend_lock for
 	 * dereference.
 	 */
-	struct dm_table *map;
+	struct dm_table __rcu *map;
 
 	unsigned long flags;
 
-- 
2.1.0

