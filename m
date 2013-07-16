Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429Ab3GPOTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 10:19:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36783 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932183Ab3GPOT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 10:19:29 -0400
Message-ID: <51E5566E.7030607@suse.com>
Date: Tue, 16 Jul 2013 10:19:26 -0400
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Documentation: Fix bad merge with tmpfile documentation
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 48bde8d3 (Document ->tmpfile()) had a bad merge in vfs.txt,
where it put the new tmpfile prototype in the middle of the atomic_open
prototype.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 Documentation/filesystems/vfs.txt |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/Documentation/filesystems/vfs.txt	2013-07-16 00:53:43.791018403 -0400
+++ b/Documentation/filesystems/vfs.txt	2013-07-16 00:59:16.008721223 -0400
@@ -360,11 +360,10 @@ struct inode_operations {
 	int (*removexattr) (struct dentry *, const char *);
 	void (*update_time)(struct inode *, struct timespec *, int);
 	int (*atomic_open)(struct inode *, struct dentry *,
-	int (*tmpfile) (struct inode *, struct dentry *, umode_t);
-} ____cacheline_aligned;
 				struct file *, unsigned open_flag,
 				umode_t create_mode, int *opened);
-};
+	int (*tmpfile) (struct inode *, struct dentry *, umode_t);
+} ____cacheline_aligned;

 Again, all methods are called without any locks being held, unless
 otherwise noted.

-- 
Jeff Mahoney
SUSE Labs
