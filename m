Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbaIOUKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:10:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55633 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756182AbaIOTrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:47:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Pavel Shilovsky <pshilovsky@samba.org>,
        Steve French <smfrench@gmail.com>
Subject: [PATCH 3.14 105/114] CIFS: Fix wrong restart readdir for SMB1
Date: Mon, 15 Sep 2014 12:26:45 -0700
Message-Id: <20140915192644.699644105@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192641.428509513@linuxfoundation.org>
References: <20140915192641.428509513@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Shilovsky <pshilovsky@samba.org>

commit f736906a7669a77cf8cabdcbcf1dc8cb694e12ef upstream.

The existing code calls server->ops->close() that is not
right. This causes XFS test generic/310 to fail. Fix this
by using server->ops->closedir() function.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Pavel Shilovsky <pshilovsky@samba.org>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/readdir.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -596,8 +596,8 @@ find_cifs_entry(const unsigned int xid,
 		if (!cfile->srch_inf.endOfSearch && !cfile->invalidHandle) {
 			cfile->invalidHandle = true;
 			spin_unlock(&cifs_file_list_lock);
-			if (server->ops->close)
-				server->ops->close(xid, tcon, &cfile->fid);
+			if (server->ops->close_dir)
+				server->ops->close_dir(xid, tcon, &cfile->fid);
 		} else
 			spin_unlock(&cifs_file_list_lock);
 		if (cfile->srch_inf.ntwrk_buf_start) {


