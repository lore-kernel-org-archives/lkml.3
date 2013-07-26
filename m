Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244Ab3GZCP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 22:15:59 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:38600 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756932Ab3GZCP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 22:15:57 -0400
MIME-Version: 1.0
Date: Fri, 26 Jul 2013 10:15:55 +0800
Message-ID: <CAPgLHd-WN2VF7vEjUn0uLd_RQYYF1qvUy1TUz4EmyPbi=8JQ4g@mail.gmail.com>
Subject: [PATCH -next] staging: gdm724x: use GFP_ATOMIC under spin lock
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org, wonkang@gctsemi.com, joe@perches.com
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

A spin lock is taken here so we should use GFP_ATOMIC.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/gdm724x/gdm_mux.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/gdm724x/gdm_mux.c b/drivers/staging/gdm724x/gdm_mux.c
index f570bc0..7becf5c 100644
--- a/drivers/staging/gdm724x/gdm_mux.c
+++ b/drivers/staging/gdm724x/gdm_mux.c
@@ -410,7 +410,7 @@ static int gdm_mux_send(void *priv_dev, void *data, int len, int tty_index,
 			  gdm_mux_send_complete,
 			  t);
 
-	ret = usb_submit_urb(t->urb, GFP_KERNEL);
+	ret = usb_submit_urb(t->urb, GFP_ATOMIC);
 
 	spin_unlock_irqrestore(&mux_dev->write_lock, flags);
 

