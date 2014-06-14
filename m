Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbaFNLtW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 07:49:22 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:63888 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080AbaFNLtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 07:49:21 -0400
Date: Sat, 14 Jun 2014 21:48:13 +1000
From: Vitaly Osipov <vitaly.osipov@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] staging: rtl8712: use kcalloc instead of kmalloc(x*y,...)
Message-ID: <20140614114813.GA8466@witts-MacBook-Pro.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced kmalloc(x*y, ...) with kcalloc(x,y,...)

Signed-off-by: Vitaly Osipov <vitaly.osipov@gmail.com>
---
 drivers/staging/rtl8712/rtl871x_mlme.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl871x_mlme.c b/drivers/staging/rtl8712/rtl871x_mlme.c
index 26b8f37..8561841 100644
--- a/drivers/staging/rtl8712/rtl871x_mlme.c
+++ b/drivers/staging/rtl8712/rtl871x_mlme.c
@@ -62,8 +62,7 @@ static sint _init_mlme_priv(struct _adapter *padapter)
 	_init_queue(&(pmlmepriv->scanned_queue));
 	set_scanned_network_val(pmlmepriv, 0);
 	memset(&pmlmepriv->assoc_ssid, 0, sizeof(struct ndis_802_11_ssid));
-	pbuf = kmalloc(MAX_BSS_CNT * (sizeof(struct wlan_network)),
-		       GFP_ATOMIC);
+	pbuf = kcalloc(MAX_BSS_CNT, sizeof(struct wlan_network), GFP_ATOMIC);
 	if (pbuf == NULL)
 		return _FAIL;
 	pmlmepriv->free_bss_buf = pbuf;
-- 
1.9.1

