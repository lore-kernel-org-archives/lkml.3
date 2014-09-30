Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbaI3VcJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:32:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60785 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbaI3VcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:32:01 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steve French <smfrench@gmail.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 017/103] [CIFS] Possible null ptr deref in SMB2_tcon
Date: Tue, 30 Sep 2014 14:30:22 -0700
Message-Id: <1412112708-27356-18-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <smfrench@gmail.com>

commit 18f39e7be0121317550d03e267e3ebd4dbfbb3ce upstream.

As Raphael Geissert pointed out, tcon_error_exit can dereference tcon
and there is one path in which tcon can be null.

Signed-off-by: Steve French <smfrench@gmail.com>
Reported-by: Raphael Geissert <geissert@debian.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/cifs/smb2pdu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 63339c5..ec2c0ac 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -916,7 +916,8 @@ tcon_exit:
 tcon_error_exit:
 	if (rsp->hdr.Status == STATUS_BAD_NETWORK_NAME) {
 		cifs_dbg(VFS, "BAD_NETWORK_NAME: %s\n", tree);
-		tcon->bad_network_name = true;
+		if (tcon)
+			tcon->bad_network_name = true;
 	}
 	goto tcon_exit;
 }
-- 
1.9.1

