Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbaFGLar (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 07:30:47 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:28686 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752538AbaFGLaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 07:30:46 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmIOAGj2klNXQ3Uj/2dsb2JhbABZgw2sGggBAQUBmRCBBBd1hGAjgRo3iEYBtBqZCReFXYkPHYQrBI9aikeLKIgdgz47
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Christoph Lameter <cl@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] mm/slab.c: add __init to init_lock_keys
Date: Sat,  7 Jun 2014 13:30:26 +0200
Message-Id: <1402140626-20914-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_lock_keys is only called by __init kmem_cache_init_late

Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 mm/slab.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 19d9218..4ff5298 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -536,7 +536,7 @@ static inline void on_slab_lock_classes(struct kmem_cache *cachep)
 		on_slab_lock_classes_node(cachep, node);
 }
 
-static inline void init_lock_keys(void)
+static inline void __init init_lock_keys(void)
 {
 	int node;
 
@@ -544,7 +544,7 @@ static inline void init_lock_keys(void)
 		init_node_lock_keys(node);
 }
 #else
-static void init_node_lock_keys(int q)
+static void __init init_node_lock_keys(int q)
 {
 }
 
-- 
1.9.1

