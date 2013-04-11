Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935919Ab3DKUtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:49:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17239 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935813Ab3DKUtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:23 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Qvu0aXIYMZQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=pEoFWOvEKmEA:10 a=yQdBAQUQAAAA:8 a=VwQbUJbxAAAA:8 a=vmLDa1wCAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=IcxpeKGZWnEA:10 a=gv_BBZfBKR8A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202600.427843914@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 087/171 ] rtlwifi: usb: add missing freeing of skbuff
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0087-rtlwifi-usb-add-missing-freeing-of-skbuff.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jussi Kivilinna <jussi.kivilinna@iki.fi>

[ Upstream commit 36ef0b473fbf43d5db23eea4616cc1d18cec245f ]

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: stable@vger.kernel.org
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/rtlwifi/usb.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index aa970fc..98b0d6d 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -842,6 +842,7 @@ static void _rtl_usb_transmit(struct ieee80211_hw *hw, struct sk_buff *skb,
 	if (unlikely(!_urb)) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 "Can't allocate urb. Drop skb!\n");
+		kfree_skb(skb);
 		return;
 	}
 	urb_list = &rtlusb->tx_pending[ep_num];
-- 
1.7.10.4


