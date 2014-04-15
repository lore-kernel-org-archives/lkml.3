Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751185AbaDOIHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 04:07:22 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37906 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750885AbaDOIG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 04:06:57 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: sfrench@samba.org, linux-cifs@vger.kernel.org, viro@zeniv.linux.org.uk
Cc: geert@linux-m68k.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] cif: fix dead code
Date: Tue, 15 Apr 2014 10:06:50 +0200
Message-Id: <1397549210-29445-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This issue was found by Coverity (CID 1202536)

This proposes a fix for a statement that creates dead code.
The "rc < 0" statement is within code that is run
with "rc > 0".

It seems like "err < 0" was meant to be used here.
This way, the error code is returned by the function.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 fs/cifs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 8add25538a3b..b6e78632fa97 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2599,7 +2599,7 @@ cifs_writev(struct kiocb *iocb, const struct iovec *iov,
 			ssize_t err;
 
 			err = generic_write_sync(file, iocb->ki_pos - rc, rc);
-			if (rc < 0)
+			if (err < 0)
 				rc = err;
 		}
 	} else {
-- 
1.8.3.2

