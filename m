Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab3IKE6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:58:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3257 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291Ab3IKE5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:01 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=ld3SRQY_gnMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=MfXNMtAPPjoA:10 a=ruePrcMeAAAA:8 a=VwQbUJbxAAAA:8 a=J1Y8HTJGAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=2lorSeGhNQsA:10 a=XNN-oNMjSfgA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042925.126466206@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Stephane Grosjean <s.grosjean@peak-system.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [198/251] can: pcan_usb: fix wrong memcpy() bytes length
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0198-can-pcan_usb-fix-wrong-memcpy-bytes-length.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Stephane Grosjean <s.grosjean@peak-system.com>

[ Upstream commit 3c322a56b01695df15c70bfdc2d02e0ccd80654e ]

Fix possibly wrong memcpy() bytes length since some CAN records received from
PCAN-USB could define a DLC field in range [9..15].
In that case, the real DLC value MUST be used to move forward the record pointer
but, only 8 bytes max. MUST be copied into the data field of the struct
can_frame object of the skb given to the network core.

Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Stephane Grosjean <s.grosjean@peak-system.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/can/usb/peak_usb/pcan_usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb.c b/drivers/net/can/usb/peak_usb/pcan_usb.c
index 25723d8..925ab8e 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb.c
@@ -649,7 +649,7 @@ static int pcan_usb_decode_data(struct pcan_usb_msg_context *mc, u8 status_len)
 		if ((mc->ptr + rec_len) > mc->end)
 			goto decode_failed;
 
-		memcpy(cf->data, mc->ptr, rec_len);
+		memcpy(cf->data, mc->ptr, cf->can_dlc);
 		mc->ptr += rec_len;
 	}
 
-- 
1.7.10.4


