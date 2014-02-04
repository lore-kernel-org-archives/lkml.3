Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936500AbaBDXBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 18:01:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56100 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933092AbaBDVCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:02:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.10 023/104] rtlwifi: Update beacon statistics for USB driver
Date: Tue,  4 Feb 2014 13:01:26 -0800
Message-Id: <20140204210223.393868870@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210222.731641778@linuxfoundation.org>
References: <20140204210222.731641778@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 65b9cc97c6852fae19dc5c7745e9abc8dd380aad upstream.

The USB drivers were not updating the beacon statistics, which led to
false beacon loss indications.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rtlwifi/usb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -477,6 +477,8 @@ static void _rtl_usb_rx_process_agg(stru
 			if (unicast)
 				rtlpriv->link_info.num_rx_inperiod++;
 		}
+		/* static bcn for roaming */
+		rtl_beacon_statistic(hw, skb);
 	}
 }
 


