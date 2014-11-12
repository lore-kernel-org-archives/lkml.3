Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934491AbaKLBmy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:42:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60406 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933830AbaKLBmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:42:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 3.14 107/203] ext4: enable journal checksum when metadata checksum feature enabled
Date: Wed, 12 Nov 2014 10:16:17 +0900
Message-Id: <20141112011547.594684182@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 98c1a7593fa355fda7f5a5940c8bf5326ca964ba upstream.

If metadata checksumming is turned on for the FS, we need to tell the
journal to use checksumming too.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/super.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3486,6 +3486,10 @@ static int ext4_fill_super(struct super_
 #ifdef CONFIG_EXT4_FS_POSIX_ACL
 	set_opt(sb, POSIX_ACL);
 #endif
+	/* don't forget to enable journal_csum when metadata_csum is enabled. */
+	if (ext4_has_metadata_csum(sb))
+		set_opt(sb, JOURNAL_CHECKSUM);
+
 	if ((def_mount_opts & EXT4_DEFM_JMODE) == EXT4_DEFM_JMODE_DATA)
 		set_opt(sb, JOURNAL_DATA);
 	else if ((def_mount_opts & EXT4_DEFM_JMODE) == EXT4_DEFM_JMODE_ORDERED)


