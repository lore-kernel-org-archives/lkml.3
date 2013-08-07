Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267Ab3HGIpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 04:45:50 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:55788 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756301Ab3HGIpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 04:45:45 -0400
From: Simon Horman <horms@verge.net.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Xishi Qiu <qiuxishi@huawei.com>, Simon Horman <horms@verge.net.au>
Subject: [PATCH] kexec: remove unnecessary return
Date: Wed,  7 Aug 2013 17:45:36 +0900
Message-Id: <1375865136-21006-1-git-send-email-horms@verge.net.au>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xishi Qiu <qiuxishi@huawei.com>

Code can not run here forever, so remove the unnecessary return.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Suggested-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Simon Horman <horms@verge.net.au>
---
 kernel/kexec.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Andrew, could you consider picking up this patch?

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 59f7b55..2a74f30 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1474,11 +1474,8 @@ static int __init __parse_crashkernel(char *cmdline,
 	if (first_colon && (!first_space || first_colon < first_space))
 		return parse_crashkernel_mem(ck_cmdline, system_ram,
 				crash_size, crash_base);
-	else
-		return parse_crashkernel_simple(ck_cmdline, crash_size,
-				crash_base);
 
-	return 0;
+	return parse_crashkernel_simple(ck_cmdline, crash_size, crash_base);
 }
 
 /*
-- 
1.8.3.2

