Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519Ab3BVSMI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:12:08 -0500
Received: from [89.21.227.133] ([89.21.227.133]:5372 "EHLO
	mail.kdh.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759072Ab3BVSIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:08:36 -0500
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 11/40] Input: atmel_mxt_ts - Bootloader addresses for mXT1664/mXT1188S
Date: Fri, 22 Feb 2013 17:57:58 +0000
Message-Id: <1361555907-19840-12-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mXT1664S family chips use different mappings for bootloader addresses.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 16af68d..903ff54 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -281,12 +281,17 @@ struct mxt_i2c_address_pair {
 };
 
 static const struct mxt_i2c_address_pair mxt_i2c_addresses[] = {
+#ifdef BOOTLOADER_1664_1188
+	{ 0x26, 0x4a },
+	{ 0x27, 0x4b },
+#else
 	{ 0x24, 0x4a },
 	{ 0x25, 0x4b },
 	{ 0x26, 0x4c },
 	{ 0x27, 0x4d },
 	{ 0x34, 0x5a },
 	{ 0x35, 0x5b },
+#endif
 };
 
 static bool mxt_object_readable(unsigned int type)
-- 
1.7.10.4

