Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbaFCTSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 15:18:13 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:58517 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751541AbaFCTSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 15:18:12 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnAOAJ8ejlNbsmtf/2dsb2JhbABZgwerXgQDAQEBBQGYHIEOF3SCUy8jgRo3iEYB0RcXhVWIfR2EKgSPS4o/ix2IFoM6Ow
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, "Theodore Ts'o" <tytso@mit.edu>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/ext4/super.c: use UINT_MAX instead of ~0U
Date: Tue,  3 Jun 2014 21:16:47 +0200
Message-Id: <1401823007-3475-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kernel.h definition

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ext4/super.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6f9e6fa..441f65f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3573,9 +3573,9 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		(test_opt(sb, POSIX_ACL) ? MS_POSIXACL : 0);
 
 	if (le32_to_cpu(es->s_rev_level) == EXT4_GOOD_OLD_REV &&
-	    (EXT4_HAS_COMPAT_FEATURE(sb, ~0U) ||
-	     EXT4_HAS_RO_COMPAT_FEATURE(sb, ~0U) ||
-	     EXT4_HAS_INCOMPAT_FEATURE(sb, ~0U)))
+	    (EXT4_HAS_COMPAT_FEATURE(sb, UINT_MAX) ||
+	     EXT4_HAS_RO_COMPAT_FEATURE(sb, UINT_MAX) ||
+	     EXT4_HAS_INCOMPAT_FEATURE(sb, UINT_MAX)))
 		ext4_msg(sb, KERN_WARNING,
 		       "feature flags set on rev 0 fs, "
 		       "running e2fsck is recommended");
-- 
1.8.4.5

