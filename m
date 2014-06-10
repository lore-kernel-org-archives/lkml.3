Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbaFJKLA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 06:11:00 -0400
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.183]:43874 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbaFJKK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 06:10:58 -0400
X-Greylist: delayed 357 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Jun 2014 06:10:57 EDT
X-RZG-AUTH: :IXQkeEW8Yfo/5haL0ckzWIsAZQXx/f53Kb0ypQqQa88tSf17MIsp+0aXNcE=
X-RZG-CLASS-ID: mo05
From: =?UTF-8?q?Bj=C3=B6rn=20Baumbach?= <bb@sernet.de>
To: Steve French <sfrench@samba.org>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Shilovsky <piastry@etersoft.ru>, stable@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B6rn=20Baumbach?= <bb@sernet.de>,
        Stefan Metzmacher <metze@samba.org>
Subject: [PATCH] fs/cifs: fix regression in cifs_create_mf_symlink()
Date: Tue, 10 Jun 2014 12:03:26 +0200
Message-Id: <1402394606-7910-1-git-send-email-bb@sernet.de>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit d81b8a40e2ece0a9ab57b1fe1798e291e75bf8fc
("CIFS: Cleanup cifs open codepath")
changed disposition to FILE_OPEN.

Signed-off-by: Björn Baumbach <bb@sernet.de>
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Reviewed-by: Stefan Metzmacher <metze@samba.org>
Cc: <stable@vger.kernel.org> # v3.14+
Cc: Pavel Shilovsky <piastry@etersoft.ru>
Cc: Steve French <sfrench@samba.org>
---
 fs/cifs/link.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 264ece7..68559fd 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -374,7 +374,7 @@ cifs_create_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	oparms.cifs_sb = cifs_sb;
 	oparms.desired_access = GENERIC_WRITE;
 	oparms.create_options = create_options;
-	oparms.disposition = FILE_OPEN;
+	oparms.disposition = FILE_CREATE;
 	oparms.path = path;
 	oparms.fid = &fid;
 	oparms.reconnect = false;
-- 
1.7.9.5

