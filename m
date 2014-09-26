Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840AbaIZKMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:12:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33052 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754955AbaIZJq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:27 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Pavel Shilovsky <pshilovsky@samba.org>,
        Steve French <smfrench@gmail.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 107/142] CIFS: Fix STATUS_CANNOT_DELETE error mapping for SMB2
Date: Fri, 26 Sep 2014 11:45:18 +0200
Message-Id: <7aadcce63d6b631f92bb2b8ff5eb8e284be81708.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Shilovsky <pshilovsky@samba.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 21496687a79424572f46a84c690d331055f4866f upstream.

The existing mapping causes unlink() call to return error after delete
operation. Changing the mapping to -EACCES makes the client process
the call like CIFS protocol does - reset dos attributes with ATTR_READONLY
flag masked off and retry the operation.

Signed-off-by: Pavel Shilovsky <pshilovsky@samba.org>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/cifs/smb2maperror.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2maperror.c b/fs/cifs/smb2maperror.c
index 7c2f45c06fc2..824696fb24db 100644
--- a/fs/cifs/smb2maperror.c
+++ b/fs/cifs/smb2maperror.c
@@ -605,7 +605,7 @@ static const struct status_to_posix_error smb2_error_map_table[] = {
 	{STATUS_MAPPED_FILE_SIZE_ZERO, -EIO, "STATUS_MAPPED_FILE_SIZE_ZERO"},
 	{STATUS_TOO_MANY_OPENED_FILES, -EMFILE, "STATUS_TOO_MANY_OPENED_FILES"},
 	{STATUS_CANCELLED, -EIO, "STATUS_CANCELLED"},
-	{STATUS_CANNOT_DELETE, -EIO, "STATUS_CANNOT_DELETE"},
+	{STATUS_CANNOT_DELETE, -EACCES, "STATUS_CANNOT_DELETE"},
 	{STATUS_INVALID_COMPUTER_NAME, -EIO, "STATUS_INVALID_COMPUTER_NAME"},
 	{STATUS_FILE_DELETED, -EIO, "STATUS_FILE_DELETED"},
 	{STATUS_SPECIAL_ACCOUNT, -EIO, "STATUS_SPECIAL_ACCOUNT"},
-- 
2.1.0

