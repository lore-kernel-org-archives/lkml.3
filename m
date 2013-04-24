Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431Ab3DXCkE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 22:40:04 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:63139 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757333Ab3DXCkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 22:40:01 -0400
MIME-Version: 1.0
Date: Wed, 24 Apr 2013 10:40:00 +0800
Message-ID: <CAPgLHd-97vfDLNXgKM0OYZAo4cyxwqLoDqWqnMhZTWSZ5-Xq7Q@mail.gmail.com>
Subject: [PATCH -next] staging: cptm1217: don't call input_free_device() after input_unregister_device()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org, lars@metafoo.de, dan.carpenter@oracle.com,
        devendra.aaru@gmail.com, adnan.ali@codethink.co.uk
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

input_free_device() should only be used if input_register_device()
was not called yet or if it failed. Once device was unregistered
use input_unregister_device() and memory will be freed once last
reference to the device is dropped.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/cptm1217/clearpad_tm1217.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/cptm1217/clearpad_tm1217.c b/drivers/staging/cptm1217/clearpad_tm1217.c
index e96eee3..42a5f5c 100644
--- a/drivers/staging/cptm1217/clearpad_tm1217.c
+++ b/drivers/staging/cptm1217/clearpad_tm1217.c
@@ -547,10 +547,8 @@ fail_gpio:
 fail:
 	/* Clean up before returning failure */
 	for (i = 0; i < TOUCH_SUPPORTED; i++) {
-		if (ts->cp_input_info[i].input) {
+		if (ts->cp_input_info[i].input)
 			input_unregister_device(ts->cp_input_info[i].input);
-			input_free_device(ts->cp_input_info[i].input);
-		}
 	}
 	kfree(ts);
 	return retval;

