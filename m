Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab3FDWnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:43:25 -0400
Received: from 1wt.eu ([62.212.114.60]:35685 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087Ab3FDWnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:43:13 -0400
Message-Id: <20130604172135.861667303@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:23:44 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mathias Krause <minipli@googlemail.com>, Jan Kara <jack@suse.cz>,
        Ben Hutchings <ben@decadent.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 134/184] udf: avoid info leak on export
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

commit 0143fc5e9f6f5aad4764801015bc8d4b4a278200 upstream.

For type 0x51 the udf.parent_partref member in struct fid gets copied
uninitialized to userland. Fix this by initializing it to 0.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/udf/namei.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 21dad8c..b754151 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -1331,6 +1331,7 @@ static int udf_encode_fh(struct dentry *de, __u32 *fh, int *lenp,
 	*lenp = 3;
 	fid->udf.block = location.logicalBlockNum;
 	fid->udf.partref = location.partitionReferenceNum;
+	fid->udf.parent_partref = 0;
 	fid->udf.generation = inode->i_generation;
 
 	if (connectable && !S_ISDIR(inode->i_mode)) {
-- 
1.7.12.2.21.g234cd45.dirty



