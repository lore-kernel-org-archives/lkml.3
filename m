Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab3CBNZj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 08:25:39 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:53326 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab3CBNZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 08:25:36 -0500
X-AuditID: cbfee68d-b7f636d0000009be-1f-5131fdce1cb6
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, sarah.a.sharp@linux.intel.com, kgene.kim@samsung.com,
        kishon@ti.com, Doug Anderson <dianders@chromium.org>
Subject: [PATCH v2 06/10] usb: xhci: Enable runtime pm in xhci-plat
Date: Sat, 02 Mar 2013 18:53:07 +0530
Message-id: <1362230590-20960-7-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1362230590-20960-1-git-send-email-gautam.vivek@samsung.com>
References: <1362230590-20960-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42JZI2JSp3vur2GgwZdNkhYH79dbnF12kM2i
	efF6NoveBVfZLC487WGzuLxrDpvF7CX9LBYzzu9jsli0rJXZovnEKWYHLo/ZDRdZPOadDPTY
	P3cNu0ffllWMHsdvbGfy+LxJLoAtissmJTUnsyy1SN8ugStj5+bTbAW7uSr2P77K3sB4h6OL
	kZNDQsBEYvGry6wQtpjEhXvr2boYuTiEBJYySpxes5QZpujfjAmMEInpjBLNWzrYIZwpTBKt
	D1tYQKrYBHQlmt7uYgSxRQRkJQ5f+c0MUsQs8JtR4vzuOWA7hAWcJfb0zmQDsVkEVCVOdu1j
	B7F5BTwkVt2fzAKxTkHize1nYKs5BTwlpl/fDNYrBFTz595xsM0SArvYJc6t6GCGGCQg8W3y
	IaBmDqCErMSmA1BnS0ocXHGDZQKj8AJGhlWMoqkFyQXFSelFhnrFibnFpXnpesn5uZsYgfFw
	+t+z3h2Mtw9YH2JMBho3kVlKNDkfGE95JfGGxibmpsamZkaWlpampAkrifPKXZIJFBJITyxJ
	zU5NLUgtii8qzUktPsTIxMEp1cA47fa5nxozxR3vsNnGzvp2Rb2SLftRyVWepLu1ORUn9BJ2
	xEnNucngdjshw3Xr3DjOv2L/NA/ET/D9bjR/87Xr33Z9z0qR23HbsDB/4bfy7+sERCpvleTb
	PVNbxrHt+7ubCt4veU9snZn2vrXPanNesp/NtH3zVJ9z7ztedDKs45xRexPXR1UvJZbijERD
	Leai4kQACiI3Zp0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t9jQd1zfw0DDY73ClgcvF9vcXbZQTaL
	5sXr2Sx6F1xls7jwtIfN4vKuOWwWs5f0s1jMOL+PyWLRslZmi+YTp5gduDxmN1xk8Zh3MtBj
	/9w17B59W1Yxehy/sZ3J4/MmuQC2qAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNL
	C3MlhbzE3FRbJRefAF23zBygy5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCB
	hDWMGTs3n2Yr2M1Vsf/xVfYGxjscXYycHBICJhL/ZkxghLDFJC7cW8/WxcjFISQwnVGieUsH
	O4QzhUmi9WELC0gVm4CuRNPbXWAdIgKyEoev/GYGKWIW+M0ocX73HFaQhLCAs8Se3plsIDaL
	gKrEya597CA2r4CHxKr7k1kg1ilIvLn9jBnE5hTwlJh+fTNYrxBQzZ97x9knMPIuYGRYxSia
	WpBcUJyUnmukV5yYW1yal66XnJ+7iREcbc+kdzCuarA4xCjAwajEwxvw0SBQiDWxrLgy9xCj
	BAezkgjv+auGgUK8KYmVValF+fFFpTmpxYcYk4GumsgsJZqcD0wEeSXxhsYm5qbGppYmFiZm
	lqQJK4nzMp56EiAkkJ5YkpqdmlqQWgSzhYmDU6qBsWOexbOTSfarMjYcbVkeeOkC28Mun6iT
	Ec8ivXcm5uSf+lTwZybTpoWnHzwLie9qeTtjg6ipYcLVKX5ZHa6sz1OeOJ7bdeBFyKXJUt8t
	/XbIXPH0rTaseSe44kBaX3SaxRmDyQXLUo7Fe916W5zS/7w5bKkIW5Dvx2WHw2bzit2Y07Yr
	R3yRkxJLcUaioRZzUXEiAOuITej6AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By enabling runtime pm in this driver allows users of
xhci-plat to enter into runtime pm. This is not full
runtime pm support (AKA xhci-plat doesn't actually power
anything off when in runtime suspend mode) but,
just basic enablement.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
CC: Doug Anderson <dianders@chromium.org>
---
 drivers/usb/host/xhci-plat.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index c9c7e13..595cb52 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -12,6 +12,7 @@
  */
 
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 
@@ -149,6 +150,8 @@ static int xhci_plat_probe(struct platform_device *pdev)
 	if (ret)
 		goto put_usb3_hcd;
 
+	pm_runtime_enable(&pdev->dev);
+
 	return 0;
 
 put_usb3_hcd:
@@ -174,6 +177,10 @@ static int xhci_plat_remove(struct platform_device *dev)
 	struct usb_hcd	*hcd = platform_get_drvdata(dev);
 	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
 
+	if (!pm_runtime_suspended(&dev->dev))
+		pm_runtime_put(&dev->dev);
+	pm_runtime_disable(&dev->dev);
+
 	usb_remove_hcd(xhci->shared_hcd);
 	usb_put_hcd(xhci->shared_hcd);
 
-- 
1.7.6.5

