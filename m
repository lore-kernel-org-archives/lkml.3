Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab3C0R4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 13:56:35 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:43123 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906Ab3C0R4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 13:56:33 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH -next 1/3] bcache: Add missing #include <linux/prefetch.h>
Date: Wed, 27 Mar 2013 18:56:28 +0100
Message-Id: <1364406990-20541-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

m68k/allmodconfig:

drivers/md/bcache/bset.c: In function ‘bset_search_tree’:
drivers/md/bcache/bset.c:727: error: implicit declaration of function ‘prefetch’

drivers/md/bcache/btree.c: In function ‘bch_btree_node_get’:
drivers/md/bcache/btree.c:933: error: implicit declaration of function ‘prefetch’

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/md/bcache/bset.c  |    1 +
 drivers/md/bcache/btree.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
index 4dc9cb4..ea06946 100644
--- a/drivers/md/bcache/bset.c
+++ b/drivers/md/bcache/bset.c
@@ -10,6 +10,7 @@
 #include "debug.h"
 
 #include <linux/random.h>
+#include <linux/prefetch.h>
 
 /* Keylists */
 
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 4005991..1d5f5f4 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -28,6 +28,7 @@
 #include <linux/slab.h>
 #include <linux/bitops.h>
 #include <linux/hash.h>
+#include <linux/prefetch.h>
 #include <linux/random.h>
 #include <linux/rcupdate.h>
 #include <trace/events/bcache.h>
-- 
1.7.0.4

