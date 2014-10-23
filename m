Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbaJWTU4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 15:20:56 -0400
Received: from mout.web.de ([212.227.17.12]:62860 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbaJWTUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 15:20:54 -0400
Message-ID: <544954FD.8040607@users.sourceforge.net>
Date: Thu, 23 Oct 2014 21:20:29 +0200
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        trivial@kernel.org, Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [PATCH 1/1] staging - rtl8188eu: Deletion of unnecessary checks
 before three function calls
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:AXdIiP8YiusqjRILH9M7h618vqAQU2nzB4sqRaPDlTVC27LXdzz
 265Cnw/Feb4RdH9GVaeRXE9vr3t6uM9/iCluRDrVrSVCaPR9hyrfBUm4XvzH1HfSLzVjeZn
 hHyvW9BH2etlwqbfghZGUuwsgA/FgwPHW0RwEIWWuhLvAUDvnqNc3bcQf0iu8PvUteY76qO
 9BKvQfkiRzuWG4LmXMTxg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 45970693cad6c12da2d5ac7da3d2bd7a566170d7 Mon Sep 17 00:00:00 2001
From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 23 Oct 2014 20:55:13 +0200
Subject: [PATCH] staging - rtl8188eu: Deletion of unnecessary checks before
 three function calls

The functions kfree(), rtw_free_netdev() and vfree() test whether their
argument is NULL and then return immediately. Thus the test around the call
is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/staging/rtl8188eu/core/rtw_efuse.c   | 3 +--
 drivers/staging/rtl8188eu/core/rtw_mlme.c    | 3 +--
 drivers/staging/rtl8188eu/core/rtw_sta_mgt.c | 3 +--
 drivers/staging/rtl8188eu/core/rtw_xmit.c    | 6 ++----
 drivers/staging/rtl8188eu/os_dep/usb_intf.c  | 5 ++---
 5 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_efuse.c
b/drivers/staging/rtl8188eu/core/rtw_efuse.c
index 7006088..77f7552 100644
--- a/drivers/staging/rtl8188eu/core/rtw_efuse.c
+++ b/drivers/staging/rtl8188eu/core/rtw_efuse.c
@@ -212,8 +212,7 @@ efuse_phymap_to_logical(u8 *phymap, u16 _offset, u16
_size_byte, u8  *pbuf)
 exit:
 	kfree(efuseTbl);

-	if (eFuseWord)
-		kfree(eFuseWord);
+	kfree(eFuseWord);
 }

 static void efuse_read_phymap_from_txpktbuf(
diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme.c
b/drivers/staging/rtl8188eu/core/rtw_mlme.c
index 149c271..df54350 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme.c
@@ -122,8 +122,7 @@ void rtw_free_mlme_priv(struct mlme_priv *pmlmepriv)
 	rtw_free_mlme_priv_ie_data(pmlmepriv);

 	if (pmlmepriv) {
-		if (pmlmepriv->free_bss_buf)
-			vfree(pmlmepriv->free_bss_buf);
+		vfree(pmlmepriv->free_bss_buf);
 	}
 }

diff --git a/drivers/staging/rtl8188eu/core/rtw_sta_mgt.c
b/drivers/staging/rtl8188eu/core/rtw_sta_mgt.c
index e1dc8fa..af1de9c 100644
--- a/drivers/staging/rtl8188eu/core/rtw_sta_mgt.c
+++ b/drivers/staging/rtl8188eu/core/rtw_sta_mgt.c
@@ -201,8 +201,7 @@ u32	_rtw_free_sta_priv(struct	sta_priv *pstapriv)

 		rtw_mfree_sta_priv_lock(pstapriv);

-		if (pstapriv->pallocated_stainfo_buf)
-			vfree(pstapriv->pallocated_stainfo_buf);
+		vfree(pstapriv->pallocated_stainfo_buf);
 	}

 	return _SUCCESS;
diff --git a/drivers/staging/rtl8188eu/core/rtw_xmit.c
b/drivers/staging/rtl8188eu/core/rtw_xmit.c
index 639ace0..011c9cf 100644
--- a/drivers/staging/rtl8188eu/core/rtw_xmit.c
+++ b/drivers/staging/rtl8188eu/core/rtw_xmit.c
@@ -246,11 +246,9 @@ void _rtw_free_xmit_priv (struct xmit_priv *pxmitpriv)
 		pxmitbuf++;
 	}

-	if (pxmitpriv->pallocated_frame_buf)
-		vfree(pxmitpriv->pallocated_frame_buf);
+	vfree(pxmitpriv->pallocated_frame_buf);

-	if (pxmitpriv->pallocated_xmitbuf)
-		vfree(pxmitpriv->pallocated_xmitbuf);
+	vfree(pxmitpriv->pallocated_xmitbuf);

 	/*  free xmit extension buff */
 	pxmitbuf = (struct xmit_buf *)pxmitpriv->pxmit_extbuf;
diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index 407a318..cdb70e4 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -456,7 +456,7 @@ free_adapter:
 	if (status != _SUCCESS) {
 		if (pnetdev)
 			rtw_free_netdev(pnetdev);
-		else if (padapter)
+		else
 			vfree(padapter);
 		padapter = NULL;
 	}
@@ -487,8 +487,7 @@ static void rtw_usb_if1_deinit(struct adapter *if1)
 	DBG_88E("+r871xu_dev_remove, hw_init_completed=%d\n",
 		if1->hw_init_completed);
 	rtw_free_drv_sw(if1);
-	if (pnetdev)
-		rtw_free_netdev(pnetdev);
+	rtw_free_netdev(pnetdev);
 }

 static int rtw_drv_init(struct usb_interface *pusb_intf, const struct
usb_device_id *pdid)
-- 
2.1.2


