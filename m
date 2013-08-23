Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453Ab3HWCrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 22:47:52 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:60641 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013Ab3HWCrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 22:47:51 -0400
MIME-Version: 1.0
Date: Fri, 23 Aug 2013 10:47:50 +0800
Message-ID: <CAPgLHd8HnGX_Sq2U4vh1H1E1tL1XFjwLS7=90xRobYuFkti7kw@mail.gmail.com>
Subject: [PATCH -next] block: fix error return code in parse_parts()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: axboe@kernel.dk, akpm@linux-foundation.org, caizhiyong@huawei.com,
        kzak@redhat.com, mag@sysgo.de, dwmw2@infradead.org,
        computersforpeace@gmail.com, dedekind@infradead.org
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return -EINVAL in the parts parse error handling case instead
of 0(may overwrite to 0 by parse_subpart()), as done elsewhere in this
function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 block/cmdline-parser.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/cmdline-parser.c b/block/cmdline-parser.c
index 18fb435..cc2637f 100644
--- a/block/cmdline-parser.c
+++ b/block/cmdline-parser.c
@@ -135,6 +135,7 @@ static int parse_parts(struct cmdline_parts **parts, const char *bdevdef)
 
 	if (!newparts->subpart) {
 		pr_warn("cmdline partition has no valid partition.");
+		ret = -EINVAL;
 		goto fail;
 	}
 

