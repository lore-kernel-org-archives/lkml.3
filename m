Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760874AbaEMKEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:04:24 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60810 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760067AbaEMJ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:56 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 060/182] nfsd4: leave reply buffer space for failed setattr
Date: Tue, 13 May 2014 11:26:52 +0200
Message-Id: <3158c29527b642c787436eae95936fe3d3b37a20.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "J. Bruce Fields" <bfields@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 04819bf6449094e62cebaf5199d85d68d711e667 upstream.

This fixes an ommission from 18032ca062e621e15683cb61c066ef3dc5414a7b
"NFSD: Server implementation of MAC Labeling", which increased the size
of the setattr error reply without increasing COMPOUND_ERR_SLACK_SPACE.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/nfsd/nfsd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfsd.h b/fs/nfsd/nfsd.h
index 30f34ab02137..479eb681c27c 100644
--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -282,7 +282,7 @@ void		nfsd_lockd_shutdown(void);
  * reason.
  */
 #define	COMPOUND_SLACK_SPACE		140    /* OP_GETFH */
-#define COMPOUND_ERR_SLACK_SPACE	12     /* OP_SETATTR */
+#define COMPOUND_ERR_SLACK_SPACE	16     /* OP_SETATTR */
 
 #define NFSD_LAUNDROMAT_MINTIMEOUT      1   /* seconds */
 
-- 
1.9.3

