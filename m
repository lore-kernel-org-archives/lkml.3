Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757688Ab3LBU1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:27:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39020 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab3LBTQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:16:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 3.12 015/212] staging: r8188eu: Fix AP mode
Date: Mon,  2 Dec 2013 11:13:26 -0800
Message-Id: <20131202191250.329563036@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 9ecfc0f45033584ec58617cf6ec37f75833d97e8 upstream.

Two code lines were accidentally deleted.  Restore them.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/rtl8188eu/core/rtw_ap.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/staging/rtl8188eu/core/rtw_ap.c
+++ b/drivers/staging/rtl8188eu/core/rtw_ap.c
@@ -1115,6 +1115,9 @@ int rtw_check_beacon_data(struct adapter
 			return _FAIL;
 	}
 
+	/* fix bug of flush_cam_entry at STOP AP mode */
+	psta->state |= WIFI_AP_STATE;
+	rtw_indicate_connect(padapter);
 	pmlmepriv->cur_network.join_res = true;/* for check if already set beacon */
 	return ret;
 }


