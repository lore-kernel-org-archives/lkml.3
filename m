Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbaEDPnm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:43:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36929 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164AbaEDPnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:43:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Theodore Tso" <tytso@mit.edu>
Subject: [PATCH 3.4 42/43] ext4: use i_size_read in ext4_unaligned_aio()
Date: Sun,  4 May 2014 11:42:36 -0400
Message-Id: <20140504154229.959608799@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154224.211508175@linuxfoundation.org>
References: <20140504154224.211508175@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 6e6358fc3c3c862bfe9a5bc029d3f8ce43dc9765 upstream.

We haven't taken i_mutex yet, so we need to use i_size_read().

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -80,7 +80,7 @@ ext4_unaligned_aio(struct inode *inode,
 	size_t count = iov_length(iov, nr_segs);
 	loff_t final_size = pos + count;
 
-	if (pos >= inode->i_size)
+	if (pos >= i_size_read(inode))
 		return 0;
 
 	if ((pos & blockmask) || (final_size & blockmask))


