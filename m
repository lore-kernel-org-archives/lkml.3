Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbaADHd0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 02:33:26 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:56937 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbaADHdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 02:33:25 -0500
X-Nat-Received: from [202.181.97.72]:61573 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1388820755.15737
To: cl@linux-foundation.org, penberg@kernel.org, mpm@selenic.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] slub: Fix possible format string bug.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201401041632.ACE65688.JSVQtFFMHOOOLF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 4 Jan 2014 16:32:31 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 04012014 #7242800, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found an unapplied patch from https://lkml.org/lkml/2013/9/19/17 .
----------
>From 38f01b48ae371058845274f4d7def4d81dbac4ea Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Sat, 4 Jan 2014 16:26:00 +0900
Subject: [PATCH] slub: Fix possible format string bug.

The "name" is determined at runtime and is parsed as format string.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index 545a170..058381e 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5163,7 +5163,7 @@ static int sysfs_slab_add(struct kmem_cache *s)
 	}
 
 	s->kobj.kset = slab_kset;
-	err = kobject_init_and_add(&s->kobj, &slab_ktype, NULL, name);
+	err = kobject_init_and_add(&s->kobj, &slab_ktype, NULL, "%s", name);
 	if (err) {
 		kobject_put(&s->kobj);
 		return err;
-- 
1.7.9.5
