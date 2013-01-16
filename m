Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932926Ab3APQK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:10:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36900 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933017Ab3APQKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:10:55 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Xi Wang <xi.wang@gmail.com>, Trond Myklebust <Trond.Myklebust@netapp.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 206/222] nfs: fix null checking in nfs_get_option_str()
Date: Wed, 16 Jan 2013 13:56:46 -0200
Message-Id: <1358351822-7675-207-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xi Wang <xi.wang@gmail.com>

commit e25fbe380c4e3c09afa98bcdcd9d3921443adab8 upstream.

The following null pointer check is broken.

	*option = match_strdup(args);
	return !option;

The pointer `option' must be non-null, and thus `!option' is always false.
Use `!*option' instead.

The bug was introduced in commit c5cb09b6f8 ("Cleanup: Factor out some
cut-and-paste code.").

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/nfs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index d09f196..2292f7e 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1148,7 +1148,7 @@ static int nfs_get_option_str(substring_t args[], char **option)
 {
 	kfree(*option);
 	*option = match_strdup(args);
-	return !option;
+	return !*option;
 }
 
 static int nfs_get_option_ul(substring_t args[], unsigned long *option)
-- 
1.7.9.5

