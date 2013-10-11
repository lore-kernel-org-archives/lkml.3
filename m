Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab3JKUu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:50:57 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:42671 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064Ab3JKUuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 16:50:54 -0400
Date: Fri, 11 Oct 2013 22:50:50 +0200 (CEST)
From: Roel Kluin <roel.kluin@gmail.com>
To: Andrew Jones <drjones@redhat.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] jump_label: unlikely(x) > 0
Message-ID: <alpine.DEB.2.02.1310112241220.11060@Z>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

untested, but wasn't this intended instead?
--------------
if (unlikely(x) > 0) doesn't seem to help branch prediction

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index a507907..cf08540 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -132,14 +132,14 @@ static __always_inline void jump_label_init(void)
 
 static __always_inline bool static_key_false(struct static_key *key)
 {
-	if (unlikely(atomic_read(&key->enabled)) > 0)
+	if (unlikely(atomic_read(&key->enabled) > 0))
 		return true;
 	return false;
 }
 
 static __always_inline bool static_key_true(struct static_key *key)
 {
-	if (likely(atomic_read(&key->enabled)) > 0)
+	if (likely(atomic_read(&key->enabled) > 0))
 		return true;
 	return false;
 }

