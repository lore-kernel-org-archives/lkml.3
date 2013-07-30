Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322Ab3G3J7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:59:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52967 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243Ab3G3Jc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:32:28 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 015/106] ext4: don't show usrquota/grpquota twice in /proc/mounts
Date: Tue, 30 Jul 2013 10:30:34 +0100
Message-Id: <1375176725-5825-16-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/super.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 89abdd7..0689c5d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1749,12 +1749,6 @@ static inline void ext4_show_quota_options(struct seq_file *seq,
 
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
1.8.3.2

