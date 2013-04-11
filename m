Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765085Ab3DKUx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:53:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11684 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935870Ab3DKUtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:31 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=IDxCx5_B4TkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=luP0yuToF1IA:10 a=jmWCE8W1go-RpaolMxwA:9 a=JC-1iiS4yFkA:10 a=jeBq3FmKZ4MA:10 a=L_1uadidg9tfwe6F:21 a=5MiOXXnisEZ43MIh:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202557.680957604@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>
Subject: [ 070/171 ] udf: Fix bitmap overflow on large filesystems with small block size
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0070-udf-Fix-bitmap-overflow-on-large-filesystems-with-sm.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 89b1f39eb4189de745fae554b0d614d87c8d5c63 ]

For large UDF filesystems with 512-byte blocks the number of necessary
bitmap blocks is larger than 2^16 so s_nr_groups in udf_bitmap overflows
(the number will overflow for filesystems larger than 128 GB with
512-byte blocks). That results in ENOSPC errors despite the filesystem
has plenty of free space.

Fix the problem by changing s_nr_groups' type to 'int'. That is enough
even for filesystems 2^32 blocks (UDF maximum) and 512-byte blocksize.

Reported-and-tested-by: v10lator@myway.de
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/udf/udf_sb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index 42ad69a..9e8e08e 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -82,7 +82,7 @@ struct udf_virtual_data {
 struct udf_bitmap {
 	__u32			s_extLength;
 	__u32			s_extPosition;
-	__u16			s_nr_groups;
+	int			s_nr_groups;
 	struct buffer_head 	**s_block_bitmap;
 };
 
-- 
1.7.10.4


