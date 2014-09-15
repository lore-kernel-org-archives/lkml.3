Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115AbaIOUjb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:39:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55103 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601AbaIOTgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:36:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pavel Shilovsky <pshilovsky@samba.org>,
        Steve French <smfrench@gmail.com>
Subject: [PATCH 3.16 141/158] CIFS: Fix STATUS_CANNOT_DELETE error mapping for SMB2
Date: Mon, 15 Sep 2014 12:26:20 -0700
Message-Id: <20140915192547.100613627@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Shilovsky <pshilovsky@samba.org>

commit 21496687a79424572f46a84c690d331055f4866f upstream.

The existing mapping causes unlink() call to return error after delete
operation. Changing the mapping to -EACCES makes the client process
the call like CIFS protocol does - reset dos attributes with ATTR_READONLY
flag masked off and retry the operation.

Signed-off-by: Pavel Shilovsky <pshilovsky@samba.org>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb2maperror.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/smb2maperror.c
+++ b/fs/cifs/smb2maperror.c
@@ -605,7 +605,7 @@ static const struct status_to_posix_erro
 	{STATUS_MAPPED_FILE_SIZE_ZERO, -EIO, "STATUS_MAPPED_FILE_SIZE_ZERO"},
 	{STATUS_TOO_MANY_OPENED_FILES, -EMFILE, "STATUS_TOO_MANY_OPENED_FILES"},
 	{STATUS_CANCELLED, -EIO, "STATUS_CANCELLED"},
-	{STATUS_CANNOT_DELETE, -EIO, "STATUS_CANNOT_DELETE"},
+	{STATUS_CANNOT_DELETE, -EACCES, "STATUS_CANNOT_DELETE"},
 	{STATUS_INVALID_COMPUTER_NAME, -EIO, "STATUS_INVALID_COMPUTER_NAME"},
 	{STATUS_FILE_DELETED, -EIO, "STATUS_FILE_DELETED"},
 	{STATUS_SPECIAL_ACCOUNT, -EIO, "STATUS_SPECIAL_ACCOUNT"},


