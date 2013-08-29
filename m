Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab3H2VtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 17:49:19 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:37201 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756157Ab3H2VtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 17:49:15 -0400
Date: Fri, 30 Aug 2013 00:45:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 1/2] staging: rtl8188eu: off by one in
 rtw_set_802_11_add_wep()
Message-ID: <20130829214542.GB23197@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"keyid" is used as an offset into the ->dot11DefKey[] array.  The array
has 4 elements.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c b/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c
index 9e12774..5fab477 100644
--- a/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c
+++ b/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c
@@ -566,7 +566,7 @@ _func_enter_;
 
 	keyid = wep->KeyIndex & 0x3fffffff;
 
-	if (keyid > 4) {
+	if (keyid >= 4) {
 		RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_, ("MgntActrtw_set_802_11_add_wep:keyid>4 =>fail\n"));
 		ret = false;
 		goto exit;
