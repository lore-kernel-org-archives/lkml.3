Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933036AbaFKP7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 11:59:12 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:49826 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932944AbaFKP7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:59:10 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugHAKt7mFNbslCP/2dsb2JhbABagw2sBwUBAQEBAQEFAZkbgQYXdYRgI4EaN4hGAc8EF4VciBlkHYQrBI9kikqTS4M+O4Ew
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/compat.c: remove unnecessary test on unsigned value
Date: Wed, 11 Jun 2014 17:57:50 +0200
Message-Id: <1402502270-8117-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unsigned long value is never < 0

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/compat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/compat.c b/fs/compat.c
index 66d3d3c..6917fdb 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -562,7 +562,7 @@ ssize_t compat_rw_copy_check_uvector(int type,
 		goto out;
 
 	ret = -EINVAL;
-	if (nr_segs > UIO_MAXIOV || nr_segs < 0)
+	if (nr_segs > UIO_MAXIOV)
 		goto out;
 	if (nr_segs > fast_segs) {
 		ret = -ENOMEM;
-- 
1.8.4.5

