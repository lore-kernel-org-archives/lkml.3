Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407Ab3CZWwx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:52:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53125 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756334Ab3CZWwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:52:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>, Jan Kara <jack@suse.cz>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 67/72] udf: avoid info leak on export
Date: Tue, 26 Mar 2013 15:51:50 -0700
Message-Id: <20130326224926.564849559@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224919.675227837@linuxfoundation.org>
References: <20130326224919.675227837@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

commit 0143fc5e9f6f5aad4764801015bc8d4b4a278200 upstream.

For type 0x51 the udf.parent_partref member in struct fid gets copied
uninitialized to userland. Fix this by initializing it to 0.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/udf/namei.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -1280,6 +1280,7 @@ static int udf_encode_fh(struct dentry *
 	*lenp = 3;
 	fid->udf.block = location.logicalBlockNum;
 	fid->udf.partref = location.partitionReferenceNum;
+	fid->udf.parent_partref = 0;
 	fid->udf.generation = inode->i_generation;
 
 	if (connectable && !S_ISDIR(inode->i_mode)) {


