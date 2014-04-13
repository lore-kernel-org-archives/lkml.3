Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbaDMMw6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 08:52:58 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:18399 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754190AbaDMMw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 08:52:57 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar0GAEGISlNXQ5wQ/2dsb2JhbABZgwaCS4EYwFyBGBd0glMTHCMYgQIkE4gAAco3jm6EPwEDjl+KAQGSQ4MzOw
Date: Sun, 13 Apr 2014 14:52:54 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Tytso <tytso@mit.edu>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/ext4/extents.c: fix bool assignments
Message-Id: <20140413145254.461c0e2e060fb31e48c91973@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing coccinelle warnings.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ext4/extents.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 82df3ce..c44f42c 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5209,7 +5209,7 @@ ext4_ext_shift_path_extents(struct ext4_ext_path *path, ext4_lblk_t shift,
 {
 	int depth, err = 0;
 	struct ext4_extent *ex_start, *ex_last;
-	bool update = 0;
+	bool update = false;
 	depth = path->p_depth;
 
 	while (depth >= 0) {
@@ -5227,7 +5227,7 @@ ext4_ext_shift_path_extents(struct ext4_ext_path *path, ext4_lblk_t shift,
 				goto out;
 
 			if (ex_start == EXT_FIRST_EXTENT(path[depth].p_hdr))
-				update = 1;
+				update = true;
 
 			*start = ex_last->ee_block +
 				ext4_ext_get_actual_len(ex_last);
-- 
1.8.3.2
