Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbaDPDEs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 23:04:48 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:10889 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbaDPDEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 23:04:47 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 15 Apr 2014 19:57:01 -0700
From: Peter Chiang <pchiang@nvidia.com>
To: <ccross@android.com>, <pchiang@nvidia.com>, <lizefan@huawei.com>,
        <akpm@linux-foundation.org>, <oleg@redhat.com>, <tj@kernel.org>,
        <pavel@ucw.cz>, <ebiederm@xmission.com>, <guillaume@morinfr.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm : Avoid candidate task is equal to current task
Date: Wed, 16 Apr 2014 11:02:59 +0800
Message-ID: <1397617379-26895-1-git-send-email-pchiang@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: pchiang <pchiang@nvidia.com>

Fix kernel panic when finding a new owner for the mm
and the new owner is equal to current onwer

Signed-off-by: pchiang <pchiang@nvidia.com>
---
 kernel/exit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 6ed6a1d..aa98422 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -399,7 +399,7 @@ retry:
 	 * here often
 	 */
 	do_each_thread(g, c) {
-		if (c->mm == mm)
+		if ((c != p) && (c->mm == mm))
 			goto assign_new_owner;
 	} while_each_thread(g, c);
 
-- 
1.8.1.5

