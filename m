Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458Ab3BVSSG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:18:06 -0500
Received: from [89.21.227.133] ([89.21.227.133]:26704 "EHLO
	mail.kdh.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758998Ab3BVSIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:08:31 -0500
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 17/40] Input: atmel_mxt_ts - Allow input device name to be configured from platform data
Date: Fri, 22 Feb 2013 17:58:04 +0000
Message-Id: <1361555907-19840-18-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some systems (for example Android IDC files) rely on this name being
a specific string.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |    6 +++++-
 include/linux/i2c/atmel_mxt_ts.h         |    1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index b7e5646..60231bf 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -1694,7 +1694,11 @@ static int mxt_initialize_t9_input_device(struct mxt_data *data)
 		return -ENOMEM;
 	}
 
-	input_dev->name = "Atmel maXTouch Touchscreen";
+	if (data->pdata->input_name)
+		input_dev->name = data->pdata->input_name;
+	else
+		input_dev->name = "Atmel maXTouch Touchscreen";
+
 	snprintf(data->phys, sizeof(data->phys), "i2c-%u-%04x/input0",
 		 client->adapter->nr, client->addr);
 	input_dev->phys = data->phys;
diff --git a/include/linux/i2c/atmel_mxt_ts.h b/include/linux/i2c/atmel_mxt_ts.h
index e7bceee..b96b265 100644
--- a/include/linux/i2c/atmel_mxt_ts.h
+++ b/include/linux/i2c/atmel_mxt_ts.h
@@ -19,6 +19,7 @@
 struct mxt_platform_data {
 	unsigned long irqflags;
 	u8(*read_chg) (void);
+	const char *input_name;
 };
 
 #endif /* __LINUX_ATMEL_MXT_TS_H */
-- 
1.7.10.4

