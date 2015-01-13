Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbbAMQin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:38:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbbAMQil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:38:41 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH] VFS: Convert file->f_dentry->d_inode to file_inode()
From: David Howells <dhowells@redhat.com>
To: jesper.nilsson@axis.com, viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, dhowells@redhat.com,
        linux-kernel@vger.kernel.org, linux-cris-kernel@axis.com
Date: Tue, 13 Jan 2015 16:38:32 +0000
Message-ID: <20150113163832.24625.95960.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert file->f_dentry->d_inode to file_inode() so as to get layered
filesystems right.

Found with: git grep '[.>]f_dentry'

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/cris/arch-v32/drivers/sync_serial.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/cris/arch-v32/drivers/sync_serial.c b/arch/cris/arch-v32/drivers/sync_serial.c
index 08a313fc2241..e9b6de2b46a0 100644
--- a/arch/cris/arch-v32/drivers/sync_serial.c
+++ b/arch/cris/arch-v32/drivers/sync_serial.c
@@ -604,7 +604,7 @@ static ssize_t __sync_serial_read(struct file *file,
 				  struct timespec *ts)
 {
 	unsigned long flags;
-	int dev = MINOR(file->f_dentry->d_inode->i_rdev);
+	int dev = MINOR(file_inode(file_inode)->i_rdev);
 	int avail;
 	struct sync_port *port;
 	unsigned char *start;

