Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbaFCTOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 15:14:22 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:21342 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753251AbaFCTOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 15:14:21 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnAOAAkejlNbsmtf/2dsb2JhbABZgwerXgQDAQEBBQGYHIEOF3SDAiOBGjeIRgHRExeFVYh9HYQqBI9Lij+LHYgWgzo7
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Jeff Mahoney <jeffm@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/reiserfs/super.c: use UINT_MAX instead of (~0U)
Date: Tue,  3 Jun 2014 21:13:04 +0200
Message-Id: <1401822784-2897-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kernel.h definition

Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/reiserfs/super.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 9fb2042..4d47b83 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -205,9 +205,9 @@ static int finish_unfinished(struct super_block *s)
 
 	/* compose key to look for "save" links */
 	max_cpu_key.version = KEY_FORMAT_3_5;
-	max_cpu_key.on_disk_key.k_dir_id = ~0U;
-	max_cpu_key.on_disk_key.k_objectid = ~0U;
-	set_cpu_key_k_offset(&max_cpu_key, ~0U);
+	max_cpu_key.on_disk_key.k_dir_id = UINT_MAX;
+	max_cpu_key.on_disk_key.k_objectid = UINT_MAX;
+	set_cpu_key_k_offset(&max_cpu_key, UINT_MAX);
 	max_cpu_key.key_length = 3;
 
 	memset(&last_inode_key, 0, sizeof(last_inode_key));
-- 
1.8.4.5

