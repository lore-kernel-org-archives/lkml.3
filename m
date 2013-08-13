Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647Ab3HMGpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:45:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60670 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757024Ab3HMGdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:33:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Piotr Sarna <p.sarna@partner.samsung.com>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [ 45/60] ext4: allow the mount options nodelalloc and data=journal
Date: Mon, 12 Aug 2013 23:34:12 -0700
Message-Id: <20130813063337.946377554@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130813063331.950321483@linuxfoundation.org>
References: <20130813063331.950321483@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 59d9fa5c2e9086db11aa287bb4030151d0095a17 upstream.

Commit 26092bf ("ext4: use a table-driven handler for mount options")
wrongly disallows the specifying the mount options nodelalloc and
data=journal simultaneously.  This is incorrect; it should have only
disallowed the combination of delalloc and data=journal
simultaneously.

Reported-by: Piotr Sarna <p.sarna@partner.samsung.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1341,7 +1341,7 @@ static const struct mount_opts {
 	{Opt_delalloc, EXT4_MOUNT_DELALLOC,
 	 MOPT_EXT4_ONLY | MOPT_SET | MOPT_EXPLICIT},
 	{Opt_nodelalloc, EXT4_MOUNT_DELALLOC,
-	 MOPT_EXT4_ONLY | MOPT_CLEAR | MOPT_EXPLICIT},
+	 MOPT_EXT4_ONLY | MOPT_CLEAR},
 	{Opt_journal_checksum, EXT4_MOUNT_JOURNAL_CHECKSUM,
 	 MOPT_EXT4_ONLY | MOPT_SET},
 	{Opt_journal_async_commit, (EXT4_MOUNT_JOURNAL_ASYNC_COMMIT |


