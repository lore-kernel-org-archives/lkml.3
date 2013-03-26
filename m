Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965054Ab3CZPWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:22:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53764 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965032Ab3CZPWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:22:35 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mathias Krause <minipli@googlemail.com>, Jan Kara <jack@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 061/150] udf: avoid info leak on export
Date: Tue, 26 Mar 2013 15:19:20 +0000
Message-Id: <1364311249-14454-62-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

commit 0143fc5e9f6f5aad4764801015bc8d4b4a278200 upstream.

For type 0x51 the udf.parent_partref member in struct fid gets copied
uninitialized to userland. Fix this by initializing it to 0.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/udf/namei.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 1802417..c31deb3 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -1279,6 +1279,7 @@ static int udf_encode_fh(struct inode *inode, __u32 *fh, int *lenp,
 	*lenp = 3;
 	fid->udf.block = location.logicalBlockNum;
 	fid->udf.partref = location.partitionReferenceNum;
+	fid->udf.parent_partref = 0;
 	fid->udf.generation = inode->i_generation;
 
 	if (parent) {
-- 
1.8.1.2

