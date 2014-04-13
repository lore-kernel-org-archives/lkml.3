Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbaDMMzk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 08:55:40 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:63292 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754100AbaDMMzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 08:55:39 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlIGAEGISlNXQ5wQ/2dsb2JhbABZgwbEP4EYF3SCUxMcIxiBAiQTiAAByjeOboQ/AQOOX4oBAZJDgzM7
Date: Sun, 13 Apr 2014 14:55:37 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/befs/btree.c: Replace strncpy by strlcpy + coding
 style fixing
Message-Id: <20140413145537.318888ad8aa263e69120c11a@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-strncpy + end of string assignement replaced by strlcpy
-Fix endif };
-Fix typo

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/befs/btree.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/befs/btree.c b/fs/befs/btree.c
index a2cd305..9d7d00e 100644
--- a/fs/befs/btree.c
+++ b/fs/befs/btree.c
@@ -405,7 +405,7 @@ befs_find_key(struct super_block *sb, befs_btree_node * node,
  * Heres how it works: Key_no is the index of the key/value pair to 
  * return in keybuf/value.
  * Bufsize is the size of keybuf (BEFS_NAME_LEN+1 is a good size). Keysize is 
- * the number of charecters in the key (just a convenience).
+ * the number of characters in the key (just a convenience).
  *
  * Algorithm:
  *   Get the first leafnode of the tree. See if the requested key is in that
@@ -502,12 +502,11 @@ befs_btree_read(struct super_block *sb, befs_data_stream * ds,
 			   "for key of size %d", __func__, bufsize, keylen);
 		brelse(this_node->bh);
 		goto error_alloc;
-	};
+	}
 
-	strncpy(keybuf, keystart, keylen);
+	strlcpy(keybuf, keystart, keylen + 1);
 	*value = fs64_to_cpu(sb, valarray[cur_key]);
 	*keysize = keylen;
-	keybuf[keylen] = '\0';
 
 	befs_debug(sb, "Read [%llu,%d]: Key \"%.*s\", Value %llu", node_off,
 		   cur_key, keylen, keybuf, *value);
-- 
1.8.3.2
