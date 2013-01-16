Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab3APQm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:42:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36239 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236Ab3APQFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:05:04 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "J. Bruce Fields" <bfields@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 119/222] nfsd: fix v4 reply caching
Date: Wed, 16 Jan 2013 13:55:19 -0200
Message-Id: <1358351822-7675-120-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 57d276d71aef7d8305ff002a070cb98deb2edced upstream.

Very embarassing: 1091006c5eb15cba56785bd5b498a8d0b9546903 "nfsd: turn
on reply cache for NFSv4" missed a line, effectively leaving the reply
cache off in the v4 case.  I thought I'd tested that, but I guess not.

This time, wrote a pynfs test to confirm it works.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/nfsd/nfssvc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 240473c..0d5e021 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -650,7 +650,7 @@ nfsd_dispatch(struct svc_rqst *rqstp, __be32 *statp)
 	}
 
 	/* Store reply in cache. */
-	nfsd_cache_update(rqstp, proc->pc_cachetype, statp + 1);
+	nfsd_cache_update(rqstp, rqstp->rq_cachetype, statp + 1);
 	return 1;
 }
 
-- 
1.7.9.5

