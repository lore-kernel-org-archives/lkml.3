Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab3FJWCz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 18:02:55 -0400
Received: from mail-gh0-f179.google.com ([209.85.160.179]:47855 "EHLO
	mail-gh0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab3FJWCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 18:02:54 -0400
From: "Raphael S. Carvalho" <raphael.scarv@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Raphael S.Carvalho" <raphael.scarv@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        "Raphael S. Carvalho" <raphael.scarv@gmail.com>
Subject: [PATCH 1/1] kernel/pid.c: Moving statement.
Date: Mon, 10 Jun 2013 18:52:40 -0300
Message-Id: <1370901160-3156-1-git-send-email-raphael.scarv@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving statement to static initilization of init_pid_ns.

Signed-off-by: Raphael S. Carvalho <raphael.scarv@gmail.com>
---
 kernel/pid.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index 0db3e79..c577d3c 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -75,6 +75,7 @@ struct pid_namespace init_pid_ns = {
 		[ 0 ... PIDMAP_ENTRIES-1] = { ATOMIC_INIT(BITS_PER_PAGE), NULL }
 	},
 	.last_pid = 0,
+	.nr_hashed = PIDNS_HASH_ADDING,
 	.level = 0,
 	.child_reaper = &init_task,
 	.user_ns = &init_user_ns,
@@ -594,7 +595,6 @@ void __init pidmap_init(void)
 	/* Reserve PID 0. We never call free_pidmap(0) */
 	set_bit(0, init_pid_ns.pidmap[0].page);
 	atomic_dec(&init_pid_ns.pidmap[0].nr_free);
-	init_pid_ns.nr_hashed = PIDNS_HASH_ADDING;
 
 	init_pid_ns.pid_cachep = KMEM_CACHE(pid,
 			SLAB_HWCACHE_ALIGN | SLAB_PANIC);
-- 
1.7.2.5

