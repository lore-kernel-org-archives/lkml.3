Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011Ab3EGLjd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 07:39:33 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:56834 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757760Ab3EGLjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 07:39:22 -0400
MIME-Version: 1.0
Date: Tue, 7 May 2013 19:39:20 +0800
Message-ID: <CAPgLHd9w_PpotgpN+KZKs79W4xZrLsBNxRsh+DjspeMxc+vxpA@mail.gmail.com>
Subject: [PATCH] pstore/ram: fix error return code in ramoops_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: cbouatmailru@gmail.com, ccross@android.com, keescook@chromium.org,
        tony.luck@intel.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 fs/pstore/ram.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 32cbd7c..1376e5a 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -438,6 +438,7 @@ static int ramoops_probe(struct platform_device *pdev)
 		pr_err("memory size too small, minimum is %zu\n",
 			cxt->console_size + cxt->record_size +
 			cxt->ftrace_size);
+		err = -EINVAL;
 		goto fail_cnt;
 	}
 
@@ -455,6 +456,7 @@ static int ramoops_probe(struct platform_device *pdev)
 	spin_lock_init(&cxt->pstore.buf_lock);
 	if (!cxt->pstore.buf) {
 		pr_err("cannot allocate pstore buffer\n");
+		err = -ENOMEM;
 		goto fail_clear;
 	}
 

