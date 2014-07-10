Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284AbaGJFWk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 01:22:40 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:53025 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaGJFWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 01:22:37 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-b9-53be231b3e11
From: Joonyoung Shim <jy0922.shim@samsung.com>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, m.szyprowski@samsung.com, broonie@linaro.org,
        tobetter@gmail.com, jy0922.shim@samsung.com
Subject: [PATCH 1/2] usb: usb3503: add PM functions
Date: Thu, 10 Jul 2014 14:22:34 +0900
Message-id: <1404969755-30555-1-git-send-email-jy0922.shim@samsung.com>
X-Mailer: git-send-email 1.8.1.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsWyRsSkRFdaeV+wweJ9khabrl9ntWhevJ7N
	4sW9iywWl3fNYbNYtKyV2WLtkbvsFvser2F2YPfYOesuu8eda3vYPPbPXcPu0bdlFaPH501y
	AaxRXDYpqTmZZalF+nYJXBkf705mKljDX3Hi5AvWBsZ7PF2MnBwSAiYSG29sZ4OwxSQu3FsP
	ZHNxCAksZZS4evwqE0xR07kfjBCJ6YwSF7fuY4FwWpkken+8YwapYhPQk7iz7ThQBweHiIC1
	RN/BIJAws0C1xP/198AGCQsYS9zqmsIOYrMIqEosaPvMDFLOK+AucfGiLcQuBYmfl0+AHSEh
	8J9N4lXzJ2aIegGJb5MPsYDUSwjISmw6wAxRLylxcMUNlgmMggsYGVYxiqYWJBcUJ6UXmeoV
	J+YWl+al6yXn525iBAbt6X/PJu5gvH/A+hBjMtC4icxSosn5wKDPK4k3NDYzsjA1MTU2Mrc0
	I01YSZw3/VFSkJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbG455HFD8//qxrubFS/3noa840
	U/uuxSIrb1452nhsjfhuR+Oylzo7BWdwPP49bZLpr/RTR9t3y/ZV/I7zCJ5Ut1P0lPRizoDq
	2HVv8t+L1l94unP7I832NIZ3m4MqlzwpOv3pr+bKvZMWTT0Y8nbFjFfrnvg9OP5V7uj3uzx/
	Nsz8s73l5bPfp7OVWIozEg21mIuKEwGjREIYcAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42I5/e+xoK608r5ggw/dQhabrl9ntWhevJ7N
	4sW9iywWl3fNYbNYtKyV2WLtkbvsFvser2F2YPfYOesuu8eda3vYPPbPXcPu0bdlFaPH501y
	AaxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUB3
	KCmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgzPt6dzFSwhr/ixMkXrA2M
	93i6GDk5JARMJJrO/WCEsMUkLtxbz9bFyMUhJDCdUeLi1n0sEE4rk0Tvj3fMIFVsAnoSd7Yd
	Z+pi5OAQEbCW6DsYBBJmFqiW+L/+HhOILSxgLHGrawo7iM0ioCqxoO0zM0g5r4C7xMWLthC7
	FCR+Xj7BNoGRewEjwypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4Jh4JrWDcWWDxSFGAQ5G
	JR7ehp69wUKsiWXFlbmHGCU4mJVEeD3+A4V4UxIrq1KL8uOLSnNSiw8xmgItn8gsJZqcD4zX
	vJJ4Q2MTMyNLI3NDCyNjcyVx3gOt1oFCAumJJanZqakFqUUwfUwcnFINjBW5N7b/e/Zf1+Ts
	gT8JZmsufbmwRPbUvoidr9d4+UoH1qR2PzkjkvEwrWayQPAs/98cl+5qHv1raXaZkXlHopGu
	9KMoszhnFp0Jn60msq3aEuCo/T+lSCi74rpuaax//2r+yd//O7NaH/T4KVN/0noaX+m9z0ek
	fjaV3a+8IcHsecrzUM/LvUosxRmJhlrMRcWJAHVxjOufAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usb3503 needs to switch to standby mode while suspending and should
switch to hub mode when resumed. Also we can control clock on PM
function.

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 drivers/usb/misc/usb3503.c | 34 ++++++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/misc/usb3503.c b/drivers/usb/misc/usb3503.c
index 652855b..47cb143 100644
--- a/drivers/usb/misc/usb3503.c
+++ b/drivers/usb/misc/usb3503.c
@@ -149,8 +149,6 @@ static int usb3503_switch_mode(struct usb3503 *hub, enum usb3503_mode mode)
 
 	case USB3503_MODE_STANDBY:
 		usb3503_reset(hub, 0);
-
-		hub->mode = mode;
 		dev_info(dev, "switched to STANDBY mode\n");
 		break;
 
@@ -347,6 +345,37 @@ static int usb3503_platform_probe(struct platform_device *pdev)
 	return usb3503_probe(hub);
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int usb3503_i2c_suspend(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct usb3503 *hub = i2c_get_clientdata(client);
+
+	usb3503_switch_mode(hub, USB3503_MODE_STANDBY);
+
+	if (hub->clk)
+		clk_disable_unprepare(hub->clk);
+
+	return 0;
+}
+
+static int usb3503_i2c_resume(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct usb3503 *hub = i2c_get_clientdata(client);
+
+	if (hub->clk)
+		clk_prepare_enable(hub->clk);
+
+	usb3503_switch_mode(hub, hub->mode);
+
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(usb3503_i2c_pm_ops, usb3503_i2c_suspend,
+		usb3503_i2c_resume);
+
 static const struct i2c_device_id usb3503_id[] = {
 	{ USB3503_I2C_NAME, 0 },
 	{ }
@@ -365,6 +394,7 @@ MODULE_DEVICE_TABLE(of, usb3503_of_match);
 static struct i2c_driver usb3503_i2c_driver = {
 	.driver = {
 		.name = USB3503_I2C_NAME,
+		.pm = &usb3503_i2c_pm_ops,
 		.of_match_table = of_match_ptr(usb3503_of_match),
 	},
 	.probe		= usb3503_i2c_probe,
-- 
1.8.1.2

