Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028Ab3CZXD6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:03:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53480 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756898Ab3CZXCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 19:02:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Jim Trigg <jtrigg@spamcop.net>
Subject: [ 39/49] udf: Fix bitmap overflow on large filesystems with small block size
Date: Tue, 26 Mar 2013 16:01:36 -0700
Message-Id: <20130326225843.631536053@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326225839.554028294@linuxfoundation.org>
References: <20130326225839.554028294@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 89b1f39eb4189de745fae554b0d614d87c8d5c63 upstream.

For large UDF filesystems with 512-byte blocks the number of necessary
bitmap blocks is larger than 2^16 so s_nr_groups in udf_bitmap overflows
(the number will overflow for filesystems larger than 128 GB with
512-byte blocks). That results in ENOSPC errors despite the filesystem
has plenty of free space.

Fix the problem by changing s_nr_groups' type to 'int'. That is enough
even for filesystems 2^32 blocks (UDF maximum) and 512-byte blocksize.

Reported-and-tested-by: v10lator@myway.de
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Jim Trigg <jtrigg@spamcop.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/udf/udf_sb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -79,7 +79,7 @@ struct udf_virtual_data {
 struct udf_bitmap {
 	__u32			s_extLength;
 	__u32			s_extPosition;
-	__u16			s_nr_groups;
+	int			s_nr_groups;
 	struct buffer_head 	**s_block_bitmap;
 };
 


