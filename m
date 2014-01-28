Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbaA1U1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 15:27:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754636AbaA1U1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 15:27:12 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH] afs: proc cells and rootcell are writeable [ver #2]
From: David Howells <dhowells@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-afs@lists.infradead.org,
        Pali =?utf-8?b?Um9ow6Fy?= <pali.rohar@gmail.com>
Date: Tue, 28 Jan 2014 20:26:44 +0000
Message-ID: <20140128202644.26927.58516.stgit@warthog.procyon.org.uk>
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
index 526e4bbbde59..2d9279fcf25e 100644
--- a/fs/afs/proc.c
+++ b/fs/afs/proc.c
@@ -147,11 +147,11 @@ int afs_proc_init(void)
 	if (!proc_afs)
 		goto error_dir;
 
-	p = proc_create("cells", 0, proc_afs, &afs_proc_cells_fops);
+	p = proc_create("cells", 0644, proc_afs, &afs_proc_cells_fops);
 	if (!p)
 		goto error_cells;
 
-	p = proc_create("rootcell", 0, proc_afs, &afs_proc_rootcell_fops);
+	p = proc_create("rootcell", 0644, proc_afs, &afs_proc_rootcell_fops);
 	if (!p)
 		goto error_rootcell;
 

