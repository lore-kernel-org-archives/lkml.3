Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab3IKLUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 07:20:54 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:58443 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab3IKLTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 07:19:50 -0400
MIME-Version: 1.0
Date: Wed, 11 Sep 2013 19:19:49 +0800
Message-ID: <CAPgLHd-5dt70Tn+3SXXu9QudpwpHaO1FNf-LZWQmDq413KLbQg@mail.gmail.com>
Subject: [PATCH] Drivers: hv: vmbus: fix error return code in vmbus_connect()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: kys@microsoft.com, haiyangz@microsoft.com
Cc: yongjun_wei@trendmicro.com.cn, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return -EINVAL in the version check error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/hv/connection.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 8f4743a..b3eb50f 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -204,8 +204,10 @@ int vmbus_connect(void)
 		version = vmbus_get_next_version(version);
 	} while (version != VERSION_INVAL);
 
-	if (version == VERSION_INVAL)
+	if (version == VERSION_INVAL) {
+		ret = -EINVAL;
 		goto cleanup;
+	}
 
 	vmbus_proto_version = version;
 	pr_info("Hyper-V Host Build:%d-%d.%d-%d-%d.%d; Vmbus version:%d.%d\n",

