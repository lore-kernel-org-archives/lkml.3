Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089AbaJCVys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:54:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46022 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932198AbaJCVxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:53:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andrey Vagin <avagin@openvz.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.16 274/357] fsnotify/fdinfo: use named constants instead of hardcoded values
Date: Fri,  3 Oct 2014 14:31:00 -0700
Message-Id: <20141003212941.727469579@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Vagin <avagin@openvz.org>

commit 1fc98d11cac6dd66342e5580cb2687e5b1e9a613 upstream.

MAX_HANDLE_SZ is equal to 128, but currently the size of pad is only 64
bytes, so exportfs_encode_inode_fh can return an error.

Signed-off-by: Andrey Vagin <avagin@openvz.org>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/notify/fdinfo.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/notify/fdinfo.c
+++ b/fs/notify/fdinfo.c
@@ -42,7 +42,7 @@ static int show_mark_fhandle(struct seq_
 {
 	struct {
 		struct file_handle handle;
-		u8 pad[64];
+		u8 pad[MAX_HANDLE_SZ];
 	} f;
 	int size, ret, i;
 
@@ -50,7 +50,7 @@ static int show_mark_fhandle(struct seq_
 	size = f.handle.handle_bytes >> 2;
 
 	ret = exportfs_encode_inode_fh(inode, (struct fid *)f.handle.f_handle, &size, 0);
-	if ((ret == 255) || (ret == -ENOSPC)) {
+	if ((ret == FILEID_INVALID) || (ret == -ENOSPC)) {
 		WARN_ONCE(1, "Can't encode file handler for inotify: %d\n", ret);
 		return 0;
 	}


