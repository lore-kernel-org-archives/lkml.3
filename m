Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbbAPMRv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 07:17:51 -0500
Received: from swarm.cs.pub.ro ([141.85.227.118]:56760 "EHLO swarm.cs.pub.ro"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353AbbAPMRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 07:17:50 -0500
X-Greylist: delayed 379 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Jan 2015 07:17:50 EST
From: Valentin Ilie <valentin.ilie@gmail.com>
To: iamjoonsoo.kim@lge.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Valentin Ilie <valentin.ilie@gmail.com>
Subject: [PATCH] mm/page_owner: Fix memory leak
Date: Fri, 16 Jan 2015 14:11:24 +0200
Message-Id: <1421410284-23776-1-git-send-email-valentin.ilie@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call kfree on list2 after using it.

Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>
---
 tools/vm/page_owner_sort.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/vm/page_owner_sort.c b/tools/vm/page_owner_sort.c
index 77147b4..92292d5 100644
--- a/tools/vm/page_owner_sort.c
+++ b/tools/vm/page_owner_sort.c
@@ -139,6 +139,8 @@ int main(int argc, char **argv)
 
 	for (i = 0; i < count; i++)
 		fprintf(fout, "%d times:\n%s\n", list2[i].num, list2[i].txt);
+	
+	kfree(list2);
 
 	return 0;
 }
-- 
2.1.0

