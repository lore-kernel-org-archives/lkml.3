Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759856Ab3K0Bc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:32:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39315 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758557Ab3K0A6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:58:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 3.12 026/116] staging: r8188eu: Set device type to wlan
Date: Tue, 26 Nov 2013 16:56:39 -0800
Message-Id: <20131127005738.753175872@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 0d1206be229697f897f00822bc142e66da731417 upstream.

The latest version of NetworkManager does not recognize the device as wireless
without this change.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/rtl8188eu/os_dep/os_intfs.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/staging/rtl8188eu/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
@@ -707,6 +707,10 @@ int rtw_init_netdev_name(struct net_devi
 	return 0;
 }
 
+static const struct device_type wlan_type = {
+	.name = "wlan",
+};
+
 struct net_device *rtw_init_netdev(struct adapter *old_padapter)
 {
 	struct adapter *padapter;
@@ -722,6 +726,7 @@ struct net_device *rtw_init_netdev(struc
 	if (!pnetdev)
 		return NULL;
 
+	pnetdev->dev.type = &wlan_type;
 	padapter = rtw_netdev_priv(pnetdev);
 	padapter->pnetdev = pnetdev;
 	DBG_88E("register rtw_netdev_ops to netdev_ops\n");


