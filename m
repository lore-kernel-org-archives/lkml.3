Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474AbaEXNIL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 09:08:11 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:13944 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750882AbaEXNIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 09:08:10 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIJAKOYgFNbtALU/2dsb2JhbABagwerGAUBgzyUToEEF3SCUy8jgRo3iEYB128XhVWIfR2EKgSPP4o0kyeDOjs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Josh Triplett <josh@joshtriplett.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4/4] lib/debugobjects.c: code clean-up
Date: Sat, 24 May 2014 15:08:06 +0200
Message-Id: <1400936886-25055-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some checkpatch warnings.

Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 lib/debugobjects.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index 437a6b4..69f25bf 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -271,7 +271,7 @@ static void debug_print_object(struct debug_obj *obj, char *msg)
  */
 static int
 debug_object_fixup(int (*fixup)(void *addr, enum debug_obj_state state),
-		   void * addr, enum debug_obj_state state)
+		   void *addr, enum debug_obj_state state)
 {
 	int fixed = 0;
 
@@ -415,7 +415,8 @@ int debug_object_activate(void *addr, struct debug_obj_descr *descr)
 			debug_print_object(obj, "activate");
 			state = obj->state;
 			raw_spin_unlock_irqrestore(&db->lock, flags);
-			ret = debug_object_fixup(descr->fixup_activate, addr, state);
+			ret = debug_object_fixup(descr->fixup_activate,
+						 addr, state);
 			return ret ? -EINVAL : 0;
 
 		case ODEBUG_STATE_DESTROYED:
@@ -680,7 +681,7 @@ static void __debug_check_no_obj_freed(const void *address, unsigned long size)
 	chunks = ((eaddr - paddr) + (ODEBUG_CHUNK_SIZE - 1));
 	chunks >>= ODEBUG_CHUNK_SHIFT;
 
-	for (;chunks > 0; chunks--, paddr += ODEBUG_CHUNK_SIZE) {
+	for (; chunks > 0; chunks--, paddr += ODEBUG_CHUNK_SIZE) {
 		db = get_bucket(paddr);
 
 repeat:
@@ -1084,7 +1085,7 @@ void __init debug_objects_mem_init(void)
 		return;
 
 	obj_cache = kmem_cache_create("debug_objects_cache",
-				      sizeof (struct debug_obj), 0,
+				      sizeof(struct debug_obj), 0,
 				      SLAB_DEBUG_OBJECTS, NULL);
 
 	if (!obj_cache || debug_objects_replace_static_objects()) {
-- 
1.8.4.5

