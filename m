Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbaEUIK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 04:10:27 -0400
Received: from nautica.notk.org ([91.121.71.147]:59326 "EHLO nautica.notk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbaEUIKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 04:10:25 -0400
X-Greylist: delayed 443 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 May 2014 04:10:24 EDT
From: Dominique Martinet <dominique.martinet@cea.fr>
To: v9fs-developer@lists.sourceforge.net,
        Eric Van Hensbergen <ericvh@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alin Dobre <alin.dobre@elastichosts.com>,
        Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <dominique.martinet@cea.fr>
Subject: [PATCH] 9P: fix return value in v9fs_fid_xattr_set
Date: Wed, 21 May 2014 10:02:12 +0200
Message-Id: <1400659332-21498-1-git-send-email-dominique.martinet@cea.fr>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20140521065219.GA15962@u-barrelet>
References: <20140521065219.GA15962@u-barrelet>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v9fs_fid_xattr_set is supposed to return 0 on success.

This corrects the behaviour introduced in commit
bdd5c28dcb8330b9074404cc92a0b83aae5606a
"9p: fix return value in case in v9fs_fid_xattr_set()"

(The function returns a negative error on error, as expected)

Signed-off-by: Dominique Martinet <dominique.martinet@cea.fr>
---
 fs/9p/xattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/9p/xattr.c b/fs/9p/xattr.c
index 04133a1..f95e01e 100644
--- a/fs/9p/xattr.c
+++ b/fs/9p/xattr.c
@@ -156,7 +156,7 @@ int v9fs_fid_xattr_set(struct p9_fid *fid, const char *name,
 		offset += write_count;
 		value_len -= write_count;
 	}
-	retval = offset;
+	retval = 0;
 err:
 	p9_client_clunk(fid);
 	return retval;
-- 
1.9.0

