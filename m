Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab3IKE7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:59:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389Ab3IKE5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:07 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=u0Gbx5z5aSQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=9NsWZYRSLi4A:10 a=hD80L64hAAAA:8 a=VwQbUJbxAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042922.496084037@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Piotr Sarna <p.sarna@partner.samsung.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [182/251] ext4: allow the mount options nodelalloc and data=journal
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0182-ext4-allow-the-mount-options-nodelalloc-and-data-jou.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

[ Upstream commit 59d9fa5c2e9086db11aa287bb4030151d0095a17 ]

Commit 26092bf ("ext4: use a table-driven handler for mount options")
wrongly disallows the specifying the mount options nodelalloc and
data=journal simultaneously.  This is incorrect; it should have only
disallowed the combination of delalloc and data=journal
simultaneously.

Reported-by: Piotr Sarna <p.sarna@partner.samsung.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/ext4/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index f9b129c..ec3f293 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1422,7 +1422,7 @@ static const struct mount_opts {
 	{Opt_discard, EXT4_MOUNT_DISCARD, MOPT_SET},
 	{Opt_nodiscard, EXT4_MOUNT_DISCARD, MOPT_CLEAR},
 	{Opt_delalloc, EXT4_MOUNT_DELALLOC, MOPT_SET | MOPT_EXPLICIT},
-	{Opt_nodelalloc, EXT4_MOUNT_DELALLOC, MOPT_CLEAR | MOPT_EXPLICIT},
+	{Opt_nodelalloc, EXT4_MOUNT_DELALLOC, MOPT_CLEAR},
 	{Opt_journal_checksum, EXT4_MOUNT_JOURNAL_CHECKSUM, MOPT_SET},
 	{Opt_journal_async_commit, (EXT4_MOUNT_JOURNAL_ASYNC_COMMIT |
 				    EXT4_MOUNT_JOURNAL_CHECKSUM), MOPT_SET},
-- 
1.7.10.4


