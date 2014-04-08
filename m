Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895AbaDHUIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 16:08:09 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:35355 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756894AbaDHUIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 16:08:06 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmMOALlWRFNXQwqv/2dsb2JhbABZgwaCSYECE8FrAgKBIRd0glMTHCMYgQIkE4gAAcpnjmyEPwEDmFwBimGHX4MyOw
Date: Tue, 8 Apr 2014 22:09:34 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, ocfs2-devel@oss.oracle.com
Subject: [PATCH 1/1] fs/ocfs2/super.c: Use OCFS2_MAX_VOL_LABEL_LEN and
 strlcpy
Message-Id: <20140408220934.0db1da0682cdeff131c3b2d8@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace strncpy(size 63) by defined value.

Cc: Andrew Morton <akpm@linuxfoundation.org>
Cc: ocfs2-devel@oss.oracle.com
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ocfs2/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index a7cdd56..5dee292c 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2292,8 +2292,8 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		goto bail;
 	}
 
-	strncpy(osb->vol_label, di->id2.i_super.s_label, 63);
-	osb->vol_label[63] = '\0';
+	strlcpy(osb->vol_label, di->id2.i_super.s_label,
+		OCFS2_MAX_VOL_LABEL_LEN);
 	osb->root_blkno = le64_to_cpu(di->id2.i_super.s_root_blkno);
 	osb->system_dir_blkno = le64_to_cpu(di->id2.i_super.s_system_dir_blkno);
 	osb->first_cluster_group_blkno =
-- 
1.8.4.5

