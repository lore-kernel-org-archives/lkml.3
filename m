Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559Ab3CZXGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:06:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53453 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869Ab3CZXCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 19:02:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>, Jan Kara <jack@suse.cz>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 44/49] isofs: avoid info leak on export
Date: Tue, 26 Mar 2013 16:01:41 -0700
Message-Id: <20130326225844.135399972@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326225839.554028294@linuxfoundation.org>
References: <20130326225839.554028294@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

commit fe685aabf7c8c9f138e5ea900954d295bf229175 upstream.

For type 1 the parent_offset member in struct isofs_fid gets copied
uninitialized to userland. Fix this by initializing it to 0.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/isofs/export.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/isofs/export.c
+++ b/fs/isofs/export.c
@@ -135,6 +135,7 @@ isofs_export_encode_fh(struct dentry *de
 	len = 3;
 	fh32[0] = ei->i_iget5_block;
  	fh16[2] = (__u16)ei->i_iget5_offset;  /* fh16 [sic] */
+	fh16[3] = 0;  /* avoid leaking uninitialized data */
 	fh32[2] = inode->i_generation;
 	if (connectable && !S_ISDIR(inode->i_mode)) {
 		struct inode *parent;


