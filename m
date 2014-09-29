Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbaI2SNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 14:13:20 -0400
Received: from pegasus3.altlinux.org ([194.107.17.103]:52963 "EHLO
	pegasus3.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991AbaI2SNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 14:13:16 -0400
X-Greylist: delayed 510 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Sep 2014 14:13:16 EDT
Date: Mon, 29 Sep 2014 22:04:45 +0400
From: "Dmitry V. Levin" <ldv@altlinux.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Rob Landley <rob@landley.net>, Andrew Morton <akpm@linux-foundation.org>,
        Fabian Frederick <fabf@skynet.be>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Rob Jones <rob.jones@codethink.co.uk>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RESEND v3 PATCH 1/3] Documentation: update seq_file
Message-ID: <20140929180445.GA15829@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Wed, 17 Oct 2012 20:29:22 +0400

Starting with commit v3.2-rc4-1-g02125a8, seq_path_root() no longer
changes the value of root.
Starting with commit v3.2-rc7-104-g8c9379e, some arguments of seq_path()
and seq_path_root() are const.

Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
Acked-by: Rob Landley <rob@landley.net>
---
 Documentation/filesystems/seq_file.txt | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/filesystems/seq_file.txt b/Documentation/filesystems/seq_file.txt
index 8ea3e90..a193c1d 100644
--- a/Documentation/filesystems/seq_file.txt
+++ b/Documentation/filesystems/seq_file.txt
@@ -198,16 +198,16 @@ which is in the string esc will be represented in octal form in the output.
 
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

