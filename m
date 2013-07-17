Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822Ab3GQWww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:52:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56359 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757644Ab3GQWwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:52:50 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 143/145] ext4: don't show usrquota/grpquota twice in /proc/mounts
Date: Wed, 17 Jul 2013 15:47:55 -0700
Message-Id: <1374101277-7915-144-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit ad065dd01662ae22138899e6b1c8eeb3a529964f upstream.

We now print mount options in a generic fashion in
ext4_show_options(), so we shouldn't be explicitly printing the
{usr,grp}quota options in ext4_show_quota_options().

Without this patch, /proc/mounts can look like this:

 /dev/vdb /vdb ext4 rw,relatime,quota,usrquota,data=ordered,usrquota 0 0
                                      ^^^^^^^^              ^^^^^^^^

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext4/super.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 5575a45..f036930 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1738,12 +1738,6 @@ static inline void ext4_show_quota_options(struct seq_file *seq,
 
 	if (sbi->s_qf_names[GRPQUOTA])
 		seq_printf(seq, ",grpjquota=%s", sbi->s_qf_names[GRPQUOTA]);
-
-	if (test_opt(sb, USRQUOTA))
-		seq_puts(seq, ",usrquota");
-
-	if (test_opt(sb, GRPQUOTA))
-		seq_puts(seq, ",grpquota");
 #endif
 }
 
-- 
1.8.1.2

