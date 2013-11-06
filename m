Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab3KFHzv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 02:55:51 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54550 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750803Ab3KFHzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 02:55:50 -0500
X-IronPort-AV: E=Sophos;i="4.93,644,1378828800"; 
   d="scan'208";a="8960210"
From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
To: kernel@pengutronix.de, linux@arm.linux.org.uk, a.zummo@towertech.it
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Duan Jiong <duanj.fnst@cn.fujitsu.com>
Subject: [PATCH] drivers/rtc/rtc-pcf2127.c: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO
Date: Wed, 6 Nov 2013 15:53:38 +0800
Message-Id: <1383724418-15335-1-git-send-email-duanj.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/06 15:53:55,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/06 15:53:56,
	Serialize complete at 2013/11/06 15:53:56
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes coccinelle error regarding usage of IS_ERR and
PTR_ERR instead of PTR_ERR_OR_ZERO.

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
---
 drivers/rtc/rtc-pcf2127.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-pcf2127.c b/drivers/rtc/rtc-pcf2127.c
index 1ee514a..9bd842e 100644
--- a/drivers/rtc/rtc-pcf2127.c
+++ b/drivers/rtc/rtc-pcf2127.c
@@ -197,10 +197,7 @@ static int pcf2127_probe(struct i2c_client *client,
 				pcf2127_driver.driver.name,
 				&pcf2127_rtc_ops, THIS_MODULE);
 
-	if (IS_ERR(pcf2127->rtc))
-		return PTR_ERR(pcf2127->rtc);
-
-	return 0;
+	return PTR_ERR_OR_ZERO(pcf2127->rtc);
 }
 
 static const struct i2c_device_id pcf2127_id[] = {
-- 
1.8.3.1

