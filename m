Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639AbaKTPQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 10:16:34 -0500
Received: from mout.web.de ([212.227.15.4]:60799 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008AbaKTPQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 10:16:32 -0500
Message-ID: <546E05C0.9030703@users.sourceforge.net>
Date: Thu, 20 Nov 2014 16:16:16 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jan Dumon <j.dumon@option.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] net: USB: Deletion of unnecessary checks before the function
 call "kfree"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:rBBneGfVnTj8Vch8saKVBVQVFbyYb+waQeGTFDblD3qXhHTPzPq
 HvTjykzrZzWe5C6nCFeXZQQ2wUC9iCrR2TqnYs99LrW7ENRSsdF70D+vLTUW792VMwD0sPU
 TMagDp2zUR6/BfiZxg2ciQlEn6DP7xI6MTSZXcRLw5AE2R2kUgdSGuVmYOjCOZ5nTNRyaZJ
 O9zSLU6Ysjqzj1O6Zpl0A==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 20 Nov 2014 16:11:56 +0100

The kfree() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/net/usb/asix_devices.c | 3 +--
 drivers/net/usb/hso.c          | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 5d19409..8a7582b 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -499,8 +499,7 @@ static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
 
 static void ax88772_unbind(struct usbnet *dev, struct usb_interface *intf)
 {
-	if (dev->driver_priv)
-		kfree(dev->driver_priv);
+	kfree(dev->driver_priv);
 }
 
 static const struct ethtool_ops ax88178_ethtool_ops = {
diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index babda7d..9c5aa92 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2746,8 +2746,7 @@ exit:
 		tty_unregister_device(tty_drv, serial->minor);
 		kfree(serial);
 	}
-	if (hso_dev)
-		kfree(hso_dev);
+	kfree(hso_dev);
 	return NULL;
 
 }
-- 
2.1.3

