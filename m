Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687Ab3IKE6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:58:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3257 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211Ab3IKE44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:56:56 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=Ycy18gBuY3IA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=qrX8sv4p1xEA:10 a=VwQbUJbxAAAA:8 a=vmLDa1wCAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=gv_BBZfBKR8A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042928.531372455@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [218/251] zd1201: do not use stack as URB transfer_buffer
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0218-zd1201-do-not-use-stack-as-URB-transfer_buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jussi Kivilinna <jussi.kivilinna@iki.fi>

[ Upstream commit 1206ff4ff9d2ef7468a355328bc58ac6ebf5be44 ]

Patch fixes zd1201 not to use stack as URB transfer_buffer. URB buffers need
to be DMA-able, which stack is not.

Patch is only compile tested.

Cc: stable@vger.kernel.org
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/zd1201.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/zd1201.c b/drivers/net/wireless/zd1201.c
index 48273dd..4312eca 100644
--- a/drivers/net/wireless/zd1201.c
+++ b/drivers/net/wireless/zd1201.c
@@ -98,10 +98,12 @@ static int zd1201_fw_upload(struct usb_device *dev, int apfw)
 		goto exit;
 
 	err = usb_control_msg(dev, usb_rcvctrlpipe(dev, 0), 0x4,
-	    USB_DIR_IN | 0x40, 0,0, &ret, sizeof(ret), ZD1201_FW_TIMEOUT);
+	    USB_DIR_IN | 0x40, 0, 0, buf, sizeof(ret), ZD1201_FW_TIMEOUT);
 	if (err < 0)
 		goto exit;
 
+	memcpy(&ret, buf, sizeof(ret));
+
 	if (ret & 0x80) {
 		err = -EIO;
 		goto exit;
-- 
1.7.10.4


