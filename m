Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab3I2Tlk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:41:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59728 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982Ab3I2T3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:29:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Miklos Szeredi <mszeredi@suse.cz>, Steve French <sfrench@samba.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [ 04/71] cifs: fix filp leak in cifs_atomic_open()
Date: Sun, 29 Sep 2013 12:27:16 -0700
Message-Id: <20130929192643.844649722@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929192643.539596256@linuxfoundation.org>
References: <20130929192643.539596256@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -499,6 +499,7 @@ cifs_atomic_open(struct inode *inode, st
 		if (server->ops->close)
 			server->ops->close(xid, tcon, &fid);
 		cifs_del_pending_open(&open);
+		fput(file);
 		rc = -ENOMEM;
 	}
 


