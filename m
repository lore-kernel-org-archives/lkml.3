Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbaBINL2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 08:11:28 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:44852 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbaBINL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 08:11:26 -0500
Date: Sun, 9 Feb 2014 18:41:21 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        josh@joshtriplett.org
Subject: [PATCH 11/21] fs: Mark functions as static in jbd2/journal.c
Message-ID: <b13f571ff87a2ee1942578a97b00823373e9bd79.1391949868.git.rashika.kheria@gmail.com>
References: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark functions as static in jbd2/journal.c because they are not used
outside this file.

This eliminates the following warning in jbd2/journal.c:
fs/jbd2/journal.c:125:5: warning: no previous prototype for ‘jbd2_verify_csum_type’ [-Wmissing-prototypes]
fs/jbd2/journal.c:146:5: warning: no previous prototype for ‘jbd2_superblock_csum_verify’ [-Wmissing-prototypes]
fs/jbd2/journal.c:154:6: warning: no previous prototype for ‘jbd2_superblock_csum_set’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 fs/jbd2/journal.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 5fa344a..244b6f6 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -122,7 +122,7 @@ EXPORT_SYMBOL(__jbd2_debug);
 #endif
 
 /* Checksumming functions */
-int jbd2_verify_csum_type(journal_t *j, journal_superblock_t *sb)
+static int jbd2_verify_csum_type(journal_t *j, journal_superblock_t *sb)
 {
 	if (!JBD2_HAS_INCOMPAT_FEATURE(j, JBD2_FEATURE_INCOMPAT_CSUM_V2))
 		return 1;
@@ -143,7 +143,7 @@ static __be32 jbd2_superblock_csum(journal_t *j, journal_superblock_t *sb)
 	return cpu_to_be32(csum);
 }
 
-int jbd2_superblock_csum_verify(journal_t *j, journal_superblock_t *sb)
+static int jbd2_superblock_csum_verify(journal_t *j, journal_superblock_t *sb)
 {
 	if (!JBD2_HAS_INCOMPAT_FEATURE(j, JBD2_FEATURE_INCOMPAT_CSUM_V2))
 		return 1;
@@ -151,7 +151,7 @@ int jbd2_superblock_csum_verify(journal_t *j, journal_superblock_t *sb)
 	return sb->s_checksum == jbd2_superblock_csum(j, sb);
 }
 
-void jbd2_superblock_csum_set(journal_t *j, journal_superblock_t *sb)
+static void jbd2_superblock_csum_set(journal_t *j, journal_superblock_t *sb)
 {
 	if (!JBD2_HAS_INCOMPAT_FEATURE(j, JBD2_FEATURE_INCOMPAT_CSUM_V2))
 		return;
-- 
1.7.9.5

