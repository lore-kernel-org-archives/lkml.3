Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936728Ab3DIBr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 21:47:58 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:13928 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936057Ab3DIBr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 21:47:56 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Wolfram Sang <wsa@the-dreams.de>
CC: <linux-kernel@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>, <jiang.liu@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: [PATCH] i2c: remove CONFIG_HOTPLUG ifdefs
Date: Tue, 9 Apr 2013 09:46:39 +0800
Message-ID: <1365471999-2396-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_HOTPLUG is going away as an option, cleanup CONFIG_HOTPLUG
ifdefs in i2c files.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bill Pemberton <wfp5p@virginia.edu>
---
 drivers/i2c/i2c-core.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 991d38d..d1db97e 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -91,7 +91,6 @@ static int i2c_device_match(struct device *dev, struct device_driver *drv)
 	return 0;
 }
 
-#ifdef	CONFIG_HOTPLUG
 
 /* uevent helps with hotplug: modprobe -q $(MODALIAS) */
 static int i2c_device_uevent(struct device *dev, struct kobj_uevent_env *env)
@@ -105,10 +104,6 @@ static int i2c_device_uevent(struct device *dev, struct kobj_uevent_env *env)
 	return 0;
 }
 
-#else
-#define i2c_device_uevent	NULL
-#endif	/* CONFIG_HOTPLUG */
-
 static int i2c_device_probe(struct device *dev)
 {
 	struct i2c_client	*client = i2c_verify_client(dev);
-- 
1.7.1


