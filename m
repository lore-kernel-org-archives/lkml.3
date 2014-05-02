Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359AbaEBP7f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:59:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44180 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821AbaEBPpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:45:13 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "J. Bruce Fields" <bfields@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 095/151] nfsd4: leave reply buffer space for failed setattr
Date: Fri,  2 May 2014 08:38:03 -0700
Message-Id: <1399045139-4531-96-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 04819bf6449094e62cebaf5199d85d68d711e667 upstream.

This fixes an ommission from 18032ca062e621e15683cb61c066ef3dc5414a7b
"NFSD: Server implementation of MAC Labeling", which increased the size
of the setattr error reply without increasing COMPOUND_ERR_SLACK_SPACE.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/nfsd/nfsd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfsd.h b/fs/nfsd/nfsd.h
index 30f34ab..479eb68 100644
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
1.9.1

