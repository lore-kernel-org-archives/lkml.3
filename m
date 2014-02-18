Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752AbaBRSJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 13:09:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864AbaBRSJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 13:09:38 -0500
Date: Tue, 18 Feb 2014 13:09:34 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Jens Axboe <axboe@kernel.dk>
cc: Zdenek Kabelac <zkabelac@redhat.com>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] bio: don't write "bio: create slab" messages to syslog
Message-ID: <alpine.LRH.2.02.1402181307200.30436@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using device mapper, there are many "bio: create slab" messages in
the log. Device mapper targets have different front_pad, so each time when
we load a target that wasn't loaded before, we allocate a slab with the
appropriate front_pad and there is associated "bio: create slab" message.

This patch removes these messages, there is no need for them.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 fs/bio.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-3.14-rc3/fs/bio.c
===================================================================
--- linux-3.14-rc3.orig/fs/bio.c	2014-02-18 18:53:30.000000000 +0100
+++ linux-3.14-rc3/fs/bio.c	2014-02-18 18:53:38.000000000 +0100
@@ -116,7 +116,6 @@ static struct kmem_cache *bio_find_or_cr
 	if (!slab)
 		goto out_unlock;
 
-	printk(KERN_INFO "bio: create slab <%s> at %d\n", bslab->name, entry);
 	bslab->slab = slab;
 	bslab->slab_ref = 1;
 	bslab->slab_size = sz;
