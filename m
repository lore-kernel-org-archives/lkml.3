Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab3HFIgY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 04:36:24 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:57177 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab3HFIgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 04:36:21 -0400
Message-ID: <5200B534.7000202@huawei.com>
Date: Tue, 6 Aug 2013 16:35:00 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: <zhangyanfei@cn.fujitsu.com>, <ebiederm@xmission.com>
CC: <kexec@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Xishi Qiu <qiuxishi@huawei.com>
Subject: [PATCH V2] kexec: remove unnecessary return
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code can not run here forever, so remove the unnecessary return.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Suggested-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 kernel/kexec.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

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
1.7.1

