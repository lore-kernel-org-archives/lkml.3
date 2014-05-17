Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447AbaEQKky (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 06:40:54 -0400
Received: from mout.gmx.net ([212.227.17.22]:54858 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932142AbaEQKkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 06:40:52 -0400
From: Christian Engelmayer <cengelma@gmx.at>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        navin.patidar@gmail.com, Jes.Sorensen@redhat.com,
        linux-kernel@vger.kernel.org, Christian Engelmayer <cengelma@gmx.at>
Subject: [PATCH 1/2] staging: rtl8188eu: fix usage of uninit scalar in rtw_drv_init()
Date: Sat, 17 May 2014 12:38:57 +0200
Message-Id: <1400323138-32243-2-git-send-email-cengelma@gmx.at>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400323138-32243-1-git-send-email-cengelma@gmx.at>
References: <1400323138-32243-1-git-send-email-cengelma@gmx.at>
X-Provags-ID: V03:K0:LHyJ8UBdKsUHiUdlZ4KiFBdxpWUiXxPQBH4qYBbaMIDu5aN+vQ+
 IgWcZktL6AG9tqudVPgAxyy6P9lxBcItLKutlD4Xqs05RPBM7NRgMKPbsBUgWsPyXnKgbsN
 09BDiMJLPLIyoN7QSWpw09O3o5y/0Y+SmkhWdjvGqjiJqypIcgxmtzk+X5gd6ifmUg31yBU
 LUaI2s+2e+KnB0nmIY4FQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function rtw_drv_init() is written in a way that assumes 'status' != _SUCCESS
as long as not explicitly set. Thus initialize 'status' to FAIL, in order to
prevent undefined behaviour if going through the exit paths. Detected by
Coverity - CID 1077832.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
 drivers/staging/rtl8188eu/os_dep/usb_intf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index 8ed2ac8..632a5b0a 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -685,7 +685,7 @@ static void rtw_usb_if1_deinit(struct adapter *if1)
 static int rtw_drv_init(struct usb_interface *pusb_intf, const struct usb_device_id *pdid)
 {
 	struct adapter *if1 = NULL;
-	int status;
+	int status = _FAIL;
 	struct dvobj_priv *dvobj;
 
 	RT_TRACE(_module_hci_intfs_c_, _drv_err_, ("+rtw_drv_init\n"));
-- 
1.9.1

