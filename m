Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab3IUWbg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 18:31:36 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:39460 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab3IUW3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 18:29:04 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: a.zummo@towertech.it
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 13/19] rtc: Change variable type to bool
Date: Sun, 22 Sep 2013 00:27:45 +0200
Message-Id: <1379802471-30252-13-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1379802471-30252-1-git-send-email-peter.senna@gmail.com>
References: <1379802471-30252-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable want_irq is only assigned the values true and false.
Change its type to bool.

The simplified semantic patch that find this problem is as
follows (http://coccinelle.lip6.fr/):

@exists@
type T;
identifier b;
@@
- T
+ bool
  b = ...;
  ... when any
  b = \(true\|false\)

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/rtc/rtc-ds1307.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index ca18fd1..c8babcf 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -670,7 +670,7 @@ static int ds1307_probe(struct i2c_client *client,
 	int			tmp;
 	const struct chip_desc	*chip = &chips[id->driver_data];
 	struct i2c_adapter	*adapter = to_i2c_adapter(client->dev.parent);
-	int			want_irq = false;
+	bool			want_irq = false;
 	unsigned char		*buf;
 	struct ds1307_platform_data *pdata = client->dev.platform_data;
 	static const int	bbsqi_bitpos[] = {
-- 
1.8.3.1

