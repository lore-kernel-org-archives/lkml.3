Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab3IWNzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 09:55:47 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:63562 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab3IWNzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 09:55:46 -0400
MIME-Version: 1.0
Date: Mon, 23 Sep 2013 21:55:45 +0800
Message-ID: <CAPgLHd-B_iTMpQS8BKXQrnzs1fLk7SJz9Yfd2U6-ZDo6ZvGKqQ@mail.gmail.com>
Subject: [PATCH -next] staging: r8188eu: remove needless check before usb_free_urb()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

usb_free_urb(NULL) is safe and this check is not required.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/rtl8188eu/os_dep/recv_linux.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/recv_linux.c b/drivers/staging/rtl8188eu/os_dep/recv_linux.c
index e2f4e7d..1b670d8 100644
--- a/drivers/staging/rtl8188eu/os_dep/recv_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/recv_linux.c
@@ -77,8 +77,7 @@ int rtw_os_recvbuf_resource_alloc(struct adapter *padapter,
 int rtw_os_recvbuf_resource_free(struct adapter *padapter,
 				 struct recv_buf *precvbuf)
 {
-	if (precvbuf->purb)
-		usb_free_urb(precvbuf->purb);
+	usb_free_urb(precvbuf->purb);
 	return _SUCCESS;
 }
 

