Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbaKXPGR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 10:06:17 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:34399 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbaKXPGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 10:06:14 -0500
MIME-Version: 1.0
Date: Mon, 24 Nov 2014 23:06:14 +0800
Message-ID: <CAHkaATSEn9WMKJNRp5QvzPsno_vddtMXY39yvi=BGtb4M+Hqdw@mail.gmail.com>
Subject: [PATCH] slub: fix confusing error messages in check_slab
From: Min-Hua Chen <orca.chen@gmail.com>
To: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In check_slab, s->name is passed incorrectly to the error
messages. It will cause confusing error messages if the object
check fails. This patch fix this bug by removing s->name.

Signed-off-by: Min-Hua Chen <orca.chen@gmail.com>
---
 mm/slub.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index ae7b9f1..5da9f9f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -849,12 +849,12 @@ static int check_slab(struct kmem_cache *s,
struct page *page)
     maxobj = order_objects(compound_order(page), s->size, s->reserved);
     if (page->objects > maxobj) {
         slab_err(s, page, "objects %u > max %u",
-            s->name, page->objects, maxobj);
+             page->objects, maxobj);
         return 0;
     }
     if (page->inuse > page->objects) {
         slab_err(s, page, "inuse %u > max %u",
-            s->name, page->inuse, page->objects);
+             page->inuse, page->objects);
         return 0;
     }
     /* Slab_pad_check fixes things up after itself */
-- 
1.7.10.4
