Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbaAZM15 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 07:27:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245AbaAZM14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 07:27:56 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH] afs: proc cells and rootcell are writeable
From: David Howells <dhowells@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-afs@lists.infradead.org,
        Pali =?utf-8?b?Um9ow6Fy?= <pali.rohar@gmail.com>
Date: Sun, 26 Jan 2014 12:27:29 +0000
Message-ID: <20140126122729.32113.19659.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pali Rohár <pali.rohar@gmail.com>

Both proc files are writeable and used for configuring cells. But
there is missing correct mode flag for writeable files. Without
this patch both proc files are read only.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/proc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/afs/proc.c b/fs/afs/proc.c
index 526e4bbbde59..276cb6ed0b93 100644
--- a/fs/afs/proc.c
+++ b/fs/afs/proc.c
@@ -147,11 +147,11 @@ int afs_proc_init(void)
 	if (!proc_afs)
 		goto error_dir;
 
-	p = proc_create("cells", 0, proc_afs, &afs_proc_cells_fops);
+	p = proc_create("cells", S_IFREG | S_IRUGO | S_IWUSR, proc_afs, &afs_proc_cells_fops);
 	if (!p)
 		goto error_cells;
 
-	p = proc_create("rootcell", 0, proc_afs, &afs_proc_rootcell_fops);
+	p = proc_create("rootcell", S_IFREG | S_IRUGO | S_IWUSR, proc_afs, &afs_proc_rootcell_fops);
 	if (!p)
 		goto error_rootcell;
 

