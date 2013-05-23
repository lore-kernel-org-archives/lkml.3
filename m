Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923Ab3EWJ2I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 05:28:08 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:64862 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757582Ab3EWJ2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 05:28:06 -0400
MIME-Version: 1.0
Date: Thu, 23 May 2013 17:28:05 +0800
Message-ID: <CAPgLHd_qqOWWnWFXYbAks3LmhCcH3hGaqCw9KT+bkLwZazSCbA@mail.gmail.com>
Subject: [PATCH -next] Staging: vt6655: add missing free_netdev() on error in hostap_enable_hostapd()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: forest@alittletooquiet.net, gregkh@linuxfoundation.org, joe@perches.com,
        hemaklnce@gmail.com, marcos.souza.org@gmail.com,
        peter.p.waskiewicz.jr@intel.com
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing free_netdev() before return from function
hostap_enable_hostapd() in the error handling case.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/vt6655/hostap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/vt6655/hostap.c b/drivers/staging/vt6655/hostap.c
index 46f097d..57a08c5 100644
--- a/drivers/staging/vt6655/hostap.c
+++ b/drivers/staging/vt6655/hostap.c
@@ -104,6 +104,8 @@ static int hostap_enable_hostapd(PSDevice pDevice, int rtnl_locked)
 	if (ret) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%s: register_netdevice(AP) failed!\n",
 			dev->name);
+		free_netdev(pDevice->apdev);
+		pDevice->apdev = NULL;
 		return -1;
 	}
 

