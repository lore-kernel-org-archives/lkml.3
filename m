Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433AbaIOUSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:18:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55576 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755999AbaIOTq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:46:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steve French <smfrench@gmail.com>,
        Raphael Geissert <geissert@debian.org>
Subject: [PATCH 3.14 100/114] CIFS: Possible null ptr deref in SMB2_tcon
Date: Mon, 15 Sep 2014 12:26:40 -0700
Message-Id: <20140915192644.546825097@linuxfoundation.org>
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

From: Steve French <smfrench@gmail.com>

commit 18f39e7be0121317550d03e267e3ebd4dbfbb3ce upstream.

As Raphael Geissert pointed out, tcon_error_exit can dereference tcon
and there is one path in which tcon can be null.

Signed-off-by: Steve French <smfrench@gmail.com>
Reported-by: Raphael Geissert <geissert@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb2pdu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

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


