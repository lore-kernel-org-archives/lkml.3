Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487AbaEQKkz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 06:40:55 -0400
Received: from mout.gmx.net ([212.227.15.19]:53192 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932415AbaEQKkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 06:40:53 -0400
From: Christian Engelmayer <cengelma@gmx.at>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        navin.patidar@gmail.com, Jes.Sorensen@redhat.com,
        linux-kernel@vger.kernel.org, Christian Engelmayer <cengelma@gmx.at>
Subject: [PATCH 2/2] staging: rtl8188eu: remove dead code in rtw_drv_init()
Date: Sat, 17 May 2014 12:38:58 +0200
Message-Id: <1400323138-32243-3-git-send-email-cengelma@gmx.at>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400323138-32243-1-git-send-email-cengelma@gmx.at>
References: <1400323138-32243-1-git-send-email-cengelma@gmx.at>
X-Provags-ID: V03:K0:C4Vy6y2bdJtXsWKHJxlKpECji7KMQgAr6v0doA4lk9SSlegof1u
 z95ISSNxpzFPCvqJ+D7dobkdnm5JhWTj98cGWuakfPUzCG/FhNoxE9xiGqnegQIFJAvnaWl
 oofoaeE96n0E1AS5v66VclQ+xEI4NK3gitnvkW0QDS7CEECQTZqViYWFu22CS5uHpI/L7r3
 gjA4hkbeERRcEYy23/ZRw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(status != _SUCCESS) immediately after 'status = _SUCCESS' will never evaluate
true. Thus remove the logically dead code. Detected by Coverity - CID 1077553.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
 drivers/staging/rtl8188eu/os_dep/usb_intf.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index 632a5b0a..2a96add 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -713,8 +713,6 @@ static int rtw_drv_init(struct usb_interface *pusb_intf, const struct usb_device
 
 	status = _SUCCESS;
 
-	if (status != _SUCCESS && if1)
-		rtw_usb_if1_deinit(if1);
 free_dvobj:
 	if (status != _SUCCESS)
 		usb_dvobj_deinit(pusb_intf);
-- 
1.9.1

