Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538Ab3I2Txb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:53:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59381 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755644Ab3I2T2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:28:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Miklos Szeredi <mszeredi@suse.cz>, Steve French <sfrench@samba.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [ 03/49] cifs: fix filp leak in cifs_atomic_open()
Date: Sun, 29 Sep 2013 12:26:37 -0700
Message-Id: <20130929191603.244325230@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929191603.008825488@linuxfoundation.org>
References: <20130929191603.008825488@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit dfb1d61b0e9f9e2c542e9adc8d970689f4114ff6 upstream.

If an error occurs after having called finish_open() then fput() needs to
be called on the already opened file.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Steve French <sfrench@samba.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/dir.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -491,6 +491,7 @@ cifs_atomic_open(struct inode *inode, st
 		if (server->ops->close)
 			server->ops->close(xid, tcon, &fid);
 		cifs_del_pending_open(&open);
+		fput(file);
 		rc = -ENOMEM;
 	}
 


