Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970AbaEGTxB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 15:53:01 -0400
Received: from mout.gmx.net ([212.227.17.20]:50879 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918AbaEGTw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 15:52:57 -0400
Date: Wed, 7 May 2014 21:21:58 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: devel@driverdev.osuosl.org
Cc: Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging: rtl8723au: Remove unused pointer in
 rtw_wdev_free()
Message-ID: <20140507212158.5f5f2708@spike>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:hBYBI0/Vm+Rj9s+ixCprfUrdEKBf/rhCNKdfWeLftqvmi+y5f3N
 fscsqejgyHxltis/RJWHy1QvYejvec95c7aF5adRMplyFCwq+X2LluRkmwowHvOfIhZr7Mu
 0ljyah+pb2UlEbWy4u2WdKT4WxEiENaosJSgVjDEG9vD14CTtt2ACtwuOGGZs90pbfBgMV9
 qYAuKraWPTFiLOPXrgFyA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pointer 'pwdev_priv' in function rtw_wdev_free() is unused - thus remove it.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
v2: Resend after v1 failed to apply

   * rebased against staging-next - commit 09c3fbba (staging: rtl8188eu:
     Remove 'u8 *pbuf' from struct recv_buf)
   * fixed mua: no multipart, 7bit text/plain us-ascii

Compile tested and applies against branch staging-next of tree
git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
---
 drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
index ca100dc..be89741 100644
--- a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
@@ -3576,15 +3576,11 @@ exit:
 
 void rtw_wdev_free(struct wireless_dev *wdev)
 {
-	struct rtw_wdev_priv *pwdev_priv;
-
 	DBG_8723A("%s(wdev =%p)\n", __func__, wdev);
 
 	if (!wdev)
 		return;
 
-	pwdev_priv = wdev_to_priv(wdev);
-
 	kfree(wdev->wiphy->bands[IEEE80211_BAND_2GHZ]);
 	kfree(wdev->wiphy->bands[IEEE80211_BAND_5GHZ]);
 
-- 
1.9.1

