Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab3C0OBK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 10:01:10 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:42630 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab3C0OBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 10:01:08 -0400
MIME-Version: 1.0
Date: Wed, 27 Mar 2013 22:01:07 +0800
Message-ID: <CAPgLHd_JduxWJtpcvFsYJD+39neJf5xQOZfNO0qS+zAX4GTzug@mail.gmail.com>
Subject: [PATCH -next] ocfs2: fix error return code in ocfs2_info_handle_freefrag()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: mfasheh@suse.com, jlbec@evilplan.org
Cc: yongjun_wei@trendmicro.com.cn, ocfs2-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as returned elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 fs/ocfs2/ioctl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index 6cab301..0c60ef2 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -706,8 +706,10 @@ int ocfs2_info_handle_freefrag(struct inode *inode,
 
 	o2info_set_request_filled(&oiff->iff_req);
 
-	if (o2info_to_user(*oiff, req))
+	if (o2info_to_user(*oiff, req)) {
+		status = -EFAULT;
 		goto bail;
+	}
 
 	status = 0;
 bail:

