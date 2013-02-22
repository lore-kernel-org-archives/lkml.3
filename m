Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759344Ab3BVSOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:14:23 -0500
Received: from [89.21.227.133] ([89.21.227.133]:18360 "EHLO
	mail.kdh.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759063Ab3BVSIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:08:34 -0500
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 14/40] Input: atmel_mxt_ts - add shutdown function
Date: Fri, 22 Feb 2013 17:58:01 +0000
Message-Id: <1361555907-19840-15-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index bbe9aff..3994564 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -226,7 +226,7 @@ struct mxt_message {
 	u8 message[7];
 };
 
-enum mxt_device_state { INIT, APPMODE, BOOTLOADER, FAILED };
+enum mxt_device_state { INIT, APPMODE, BOOTLOADER, FAILED, SHUTDOWN };
 
 /* Each client has this additional data */
 struct mxt_data {
@@ -1842,6 +1842,14 @@ static int mxt_resume(struct device *dev)
 
 static SIMPLE_DEV_PM_OPS(mxt_pm_ops, mxt_suspend, mxt_resume);
 
+static void mxt_shutdown(struct i2c_client *client)
+{
+	struct mxt_data *data = i2c_get_clientdata(client);
+
+	disable_irq(data->irq);
+	data->state = SHUTDOWN;
+}
+
 static const struct i2c_device_id mxt_id[] = {
 	{ "qt602240_ts", 0 },
 	{ "atmel_mxt_ts", 0 },
@@ -1858,6 +1866,7 @@ static struct i2c_driver mxt_driver = {
 	},
 	.probe		= mxt_probe,
 	.remove		= mxt_remove,
+	.shutdown	= mxt_shutdown,
 	.id_table	= mxt_id,
 };
 
-- 
1.7.10.4

