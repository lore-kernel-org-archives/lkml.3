Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab3A3Bh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 20:37:59 -0500
Received: from vint.altlinux.org ([194.107.17.35]:56188 "EHLO
	vint.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424Ab3A3Bh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 20:37:57 -0500
Date: Wed, 30 Jan 2013 05:29:47 +0400
From: "Dmitry V. Levin" <ldv@altlinux.org>
To: Rob Landley <rob@landley.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] Documentation: update seq_file
Message-ID: <20130130012946.GB20174@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Starting with commit v3.2-rc4-1-g02125a8, seq_path_root() no longer
changes the value of root.
Starting with commit v3.2-rc7-104-g8c9379e, some arguments of seq_path()
and seq_path_root() are const.

Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
---
 Documentation/filesystems/seq_file.txt | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/filesystems/seq_file.txt b/Documentation/filesystems/seq_file.txt
index a1e2e0d..5367f08 100644
--- a/Documentation/filesystems/seq_file.txt
+++ b/Documentation/filesystems/seq_file.txt
@@ -189,16 +189,16 @@ which is in the string esc will be represented in octal form in the output.
 
 There is also a pair of functions for printing filenames:
 
-	int seq_path(struct seq_file *m, struct path *path, char *esc);
-	int seq_path_root(struct seq_file *m, struct path *path,
-			  struct path *root, char *esc)
+	int seq_path(struct seq_file *m, const struct path *path,
+		     const char *esc);
+	int seq_path_root(struct seq_file *m, const struct path *path,
+			  const struct path *root, const char *esc)
 
 Here, path indicates the file of interest, and esc is a set of characters
 which should be escaped in the output.  A call to seq_path() will output
 the path relative to the current process's filesystem root.  If a different
-root is desired, it can be used with seq_path_root().  Note that, if it
-turns out that path cannot be reached from root, the value of root will be
-changed in seq_file_root() to a root which *does* work.
+root is desired, it can be used with seq_path_root().  If it turns out that
+path cannot be reached from root, seq_path_root() returns SEQ_SKIP.
 
 
 Making it all work

-- 
ldv
