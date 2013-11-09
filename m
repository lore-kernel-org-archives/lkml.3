Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932853Ab3KIHR7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:17:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33259 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932661Ab3KIGvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:51:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.11 24/94] rtlwifi: rtl8192cu: Fix error in pointer arithmetic
Date: Fri,  8 Nov 2013 22:51:30 -0800
Message-Id: <20131109065205.937871671@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>

commit 9473ca6e920a3b9ca902753ce52833657f9221cc upstream.

An error in calculating the offset in an skb causes the driver to read
essential device info from the wrong locations. The main effect is that
automatic gain calculations are nonsense.

Signed-off-by: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
@@ -343,7 +343,8 @@ bool rtl92cu_rx_query_desc(struct ieee80
 					(bool)GET_RX_DESC_PAGGR(pdesc));
 	rx_status->mactime = GET_RX_DESC_TSFL(pdesc);
 	if (phystatus) {
-		p_drvinfo = (struct rx_fwinfo_92c *)(pdesc + RTL_RX_DESC_SIZE);
+		p_drvinfo = (struct rx_fwinfo_92c *)(skb->data +
+						     stats->rx_bufshift);
 		rtl92c_translate_rx_signal_stuff(hw, skb, stats, pdesc,
 						 p_drvinfo);
 	}


