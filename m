Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbaGJCts (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 22:49:48 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:9745 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaGJCtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 22:49:45 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-ed-53bdff455da2
From: Joonyoung Shim <jy0922.shim@samsung.com>
To: netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: steve.glendinning@shawell.net, drake@endlessm.com
Subject: [PATCH] usbnet: smsc95xx: add reset_resume function with reset
 operation
Date: Thu, 10 Jul 2014 11:49:42 +0900
Message-id: <1404960582-28096-1-git-send-email-jy0922.shim@samsung.com>
X-Mailer: git-send-email 1.8.1.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsWyRsSkQNft/95gg909LBaP5j9mtri8aw6b
	xaJlrcwWxxaIWTR/esXkwOqx6HuWx//myywenzfJBTBHcdmkpOZklqUW6dslcGXsW9fPVvCL
	r2L7hbQGxpk8XYycHBICJhIPz51hgrDFJC7cW8/WxcjFISSwlFFi/4qFbDBFW7ddY4ZITGeU
	+Np4jAXCaWWS+PTvGgtIFZuAnsSdbcfBRokIhEocv/yTFcRmFjCV+HLxB1hcWCBY4tO9U8wg
	NouAqsTT2e1gNbwC7hJTXvxggdimIPHz8gmwMyQEbrNJbHgKcQaLgIDEt8mHgIo4gBKyEpsO
	MEPUS0ocXHGDZQKj4AJGhlWMoqkFyQXFSelFRnrFibnFpXnpesn5uZsYgaF4+t+zvh2MNw9Y
	H2JMBho3kVlKNDkfGMp5JfGGxmZGFqYmpsZG5pZmpAkrifMuepgUJCSQnliSmp2aWpBaFF9U
	mpNafIiRiYNTqoFx/a71lstv/VhZ5WoTUJHacnvRdIMv2wW2RuROmjCx+PWzuw6pZxUW7wjc
	WSkgcXnC9rhTsheevojpZD7+YLrRJEtX8XIH59sWgfsM09QESucdYpVd+z9A8lSelFPlzScp
	k82qZVl3Ki4ovboh8ZyQ/z4JK1+hC6XZa4Jbbh//ERvUZyfDp6GmxFKckWioxVxUnAgAPLee
	e1sCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsVy+t9jQV3X/3uDDTqWWVk8mv+Y2eLyrjls
	FouWtTJbHFsgZtH86RWTA6vHou9ZHv+bL7N4fN4kF8Ac1cBok5GamJJapJCal5yfkpmXbqvk
	HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0UUmhLDGnFCgUkFhcrKRvh2lCaIibrgVM
	Y4Sub0gQXI+RARpIWMOYsW9dP1vBL76K7RfSGhhn8nQxcnJICJhIbN12jRnCFpO4cG89Wxcj
	F4eQwHRGia+Nx1ggnFYmiU//rrGAVLEJ6Enc2XacCcQWEQiVOH75JyuIzSxgKvHl4g+wuLBA
	sMSne6fAprIIqEo8nd0OVsMr4C4x5cUPFohtChI/L59gm8DIvYCRYRWjaGpBckFxUnqukV5x
	Ym5xaV66XnJ+7iZGcKA/k97BuKrB4hCjAAejEg9vQ8/eYCHWxLLiytxDjBIczEoivLdKgEK8
	KYmVValF+fFFpTmpxYcYTYG2T2SWEk3OB0ZhXkm8obGJmZGlkbmhhZGxuZI478FW60AhgfTE
	ktTs1NSC1CKYPiYOTqkGxox6/gczTZeqT25e9JA18JqiQUzV9pOiHzZO2hDQ3H3jzeX8K92P
	94qJfV5+aIPgbObVfD2TlTMedcRJN2tHczYfeSc7eZ9pdLWa3ez1M7jz36Xd6nfkqFy7Vf3Q
	w8zuPzabduu213IkSRkqTJ76/GHec57dEifly750xyQu+/+fLb957zyXJCWW4oxEQy3mouJE
	AJ2vPhWKAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The smsc95xx needs to resume with reset operation. Otherwise it causes
system hang by network error like below after resume. This case appears
on odroid u3 board.

[    9.727600] smsc95xx 1-2:1.0 eth0: kevent 2 may have been dropped
[    9.727648] smsc95xx 1-2:1.0 eth0: kevent 2 may have been dropped
[    9.727689] smsc95xx 1-2:1.0 eth0: kevent 2 may have been dropped
[    9.727728] smsc95xx 1-2:1.0 eth0: kevent 2 may have been dropped
[    9.729486] PM: resume of devices complete after 2011.219 msecs
[   10.117609] Restarting tasks ... done.
[   11.725099] smsc95xx 1-2:1.0 eth0: kevent 2 may have been dropped
[   13.480846] smsc95xx 1-2:1.0 eth0: kevent 2 may have been dropped
[   13.481361] smsc95xx 1-2:1.0 eth0: kevent 2 may have been dropped
...

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 drivers/net/usb/smsc95xx.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 424db65e..d07bf4c 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1714,6 +1714,18 @@ static int smsc95xx_resume(struct usb_interface *intf)
 	return ret;
 }
 
+static int smsc95xx_reset_resume(struct usb_interface *intf)
+{
+	struct usbnet *dev = usb_get_intfdata(intf);
+	int ret;
+
+	ret = smsc95xx_reset(dev);
+	if (ret < 0)
+		return ret;
+
+	return smsc95xx_resume(intf);
+}
+
 static void smsc95xx_rx_csum_offload(struct sk_buff *skb)
 {
 	skb->csum = *(u16 *)(skb_tail_pointer(skb) - 2);
@@ -2004,7 +2016,7 @@ static struct usb_driver smsc95xx_driver = {
 	.probe		= usbnet_probe,
 	.suspend	= smsc95xx_suspend,
 	.resume		= smsc95xx_resume,
-	.reset_resume	= smsc95xx_resume,
+	.reset_resume	= smsc95xx_reset_resume,
 	.disconnect	= usbnet_disconnect,
 	.disable_hub_initiated_lpm = 1,
 	.supports_autosuspend = 1,
-- 
1.8.1.2

