Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751141AbaLPDpU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 22:45:20 -0500
Received: from pegasus3.altlinux.org ([194.107.17.103]:39077 "EHLO
	pegasus3.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbaLPDpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 22:45:18 -0500
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Dec 2014 22:45:17 EST
Date: Tue, 16 Dec 2014 06:37:57 +0300
From: "Dmitry V. Levin" <ldv@altlinux.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Steven Rostedt <rostedt@goodmis.org>, Joe Perches <joe@perches.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Fabian Frederick <fabf@skynet.be>,
        Rob Jones <rob.jones@codethink.co.uk>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RESEND v4 PATCH] Documentation: update seq_file
Message-ID: <20141216033757.GA2461@altlinux.org>
References: <20140929180445.GA15829@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140929180445.GA15829@altlinux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Wed, 17 Oct 2012 20:29:22 +0400

Update descriptions of seq_path() and seq_path_root():
starting with commit v3.2-rc4-1-g02125a8, seq_path_root() no longer
changes the value of root;
starting with commit v3.2-rc7-104-g8c9379e, some arguments of seq_path()
and seq_path_root() are const.

Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
Acked-by: Rob Landley <rob@landley.net>
---
 Documentation/filesystems/seq_file.txt | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/filesystems/seq_file.txt b/Documentation/filesystems/seq_file.txt
index b797ed3..9de4303 100644
--- a/Documentation/filesystems/seq_file.txt
+++ b/Documentation/filesystems/seq_file.txt
@@ -194,16 +194,16 @@ which is in the string esc will be represented in octal form in the output.
 
 There are also a pair of functions for printing filenames:
 
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
 
 A function producing complicated output may want to check
 	bool seq_has_overflowed(struct seq_file *m);

-- 
ldv
