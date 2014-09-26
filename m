Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256AbaIZKMB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:12:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32950 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754966AbaIZJq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Steve French <smfrench@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 109/142] CIFS: Possible null ptr deref in SMB2_tcon
Date: Fri, 26 Sep 2014 11:45:20 +0200
Message-Id: <897ebdd35fad90a475e34e30b0660809347f511f.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steve French <smfrench@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 18f39e7be0121317550d03e267e3ebd4dbfbb3ce upstream.

As Raphael Geissert pointed out, tcon_error_exit can dereference tcon
and there is one path in which tcon can be null.

Signed-off-by: Steve French <smfrench@gmail.com>
Reported-by: Raphael Geissert <geissert@debian.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/cifs/smb2pdu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 829ad35f98d4..7cf843b976fd 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -912,7 +912,8 @@ tcon_exit:
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
2.1.0

