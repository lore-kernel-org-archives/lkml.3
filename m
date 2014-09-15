Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465AbaIOWMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:12:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50652 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932436AbaIOWMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:12:35 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pavel Shilovsky <pshilovsky@samba.org>, Steve French <smfrench@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 138/187] CIFS: Fix STATUS_CANNOT_DELETE error mapping for SMB2
Date: Mon, 15 Sep 2014 15:09:08 -0700
Message-Id: <1410818997-9432-139-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Shilovsky <pshilovsky@samba.org>

commit 21496687a79424572f46a84c690d331055f4866f upstream.

The existing mapping causes unlink() call to return error after delete
operation. Changing the mapping to -EACCES makes the client process
the call like CIFS protocol does - reset dos attributes with ATTR_READONLY
flag masked off and retry the operation.

Signed-off-by: Pavel Shilovsky <pshilovsky@samba.org>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/cifs/smb2maperror.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2maperror.c b/fs/cifs/smb2maperror.c
index 94bd4fb..e31a9df 100644
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
1.9.1

