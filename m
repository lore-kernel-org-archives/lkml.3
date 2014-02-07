Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbaBGMgK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:36:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42021 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858AbaBGLup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:50:45 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 131/233] dm: remove pointless kobject comparison in dm_get_from_kobject
Date: Fri,  7 Feb 2014 11:45:50 +0000
Message-Id: <1391773652-25214-132-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 1ddd641ddcfa46d719189468b6856e9b17381a61 upstream.

The comparison is always true and the compiler optimizes it out anyway.

Milan offered additional context relative to the original commit
784aae735d ("dm: add name and uuid to sysfs") which introduced the code:
"I think it is just relict of some experiments before I committed this
simple embedded sysfs kobj handling".

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Acked-by: Milan Broz <gmazyland@gmail.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
[ luis: 3.11.y prereq for:
  - 2995fa7 "dm sysfs: fix a module unload race" ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/dm.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 0cc1449..267495c 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2768,17 +2768,11 @@ struct kobject *dm_kobject(struct mapped_device *md)
 	return &md->kobj;
 }
 
-/*
- * struct mapped_device should not be exported outside of dm.c
- * so use this check to verify that kobj is part of md structure
- */
 struct mapped_device *dm_get_from_kobject(struct kobject *kobj)
 {
 	struct mapped_device *md;
 
 	md = container_of(kobj, struct mapped_device, kobj);
-	if (&md->kobj != kobj)
-		return NULL;
 
 	if (test_bit(DMF_FREEING, &md->flags) ||
 	    dm_deleting_md(md))
-- 
1.8.3.2

