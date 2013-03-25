Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433Ab3CYBQl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:16:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34120 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756331Ab3CYBQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:16:34 -0400
Message-Id: <20130325010527.079369256@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:05:52 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Mathias Krause <minipli@googlemail.com>,
        Jan Kara <jack@suse.cz>
Subject: [ 028/104] udf: avoid info leak on export
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

commit 0143fc5e9f6f5aad4764801015bc8d4b4a278200 upstream.

For type 0x51 the udf.parent_partref member in struct fid gets copied
uninitialized to userland. Fix this by initializing it to 0.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/udf/namei.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -1293,6 +1293,7 @@ static int udf_encode_fh(struct dentry *
 	*lenp = 3;
 	fid->udf.block = location.logicalBlockNum;
 	fid->udf.partref = location.partitionReferenceNum;
+	fid->udf.parent_partref = 0;
 	fid->udf.generation = inode->i_generation;
 
 	if (connectable && !S_ISDIR(inode->i_mode)) {


