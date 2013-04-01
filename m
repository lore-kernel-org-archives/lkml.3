Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758732Ab3DAN6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 09:58:25 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:43950 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758586Ab3DAN6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 09:58:15 -0400
X-AuditID: cbfee690-b7f656d0000007e3-5e-515992756e74
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-omap@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, balbi@ti.com,
        stern@rowland.harvard.edu, sarah.a.sharp@linux.intel.com,
        rob.herring@calxeda.com, kgene.kim@samsung.com, kishon@ti.com,
        dianders@chromium.org, t.figa@samsung.com, p.paneri@samsung.com
Subject: [PATCH v3 06/11] usb: xhci: Enable runtime pm in xhci-plat
Date: Mon, 01 Apr 2013 19:24:05 +0530
Message-id: <1364824448-14732-7-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1364824448-14732-1-git-send-email-gautam.vivek@samsung.com>
References: <1364824448-14732-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWyRsSkTrd0UmSgwf6PZhYH79dbnF12kM2i
	efF6NoveBVfZLC487WGzuLxrDpvF7CX9LBYzzu9jsli0rJXZ4vyWTiaLwysOMFk0nzjFbDHh
	9wU2i/UzXrM48Hks+HyF3WN2w0UWj3knAz32z10D5N39wejRt2UVo8fxG9uZPD5vkgvgiOKy
	SUnNySxLLdK3S+DKOL7JvGA6V8WhL+9ZGhj3cnQxcnJICJhI7LzRzgphi0lcuLeerYuRi0NI
	YCmjxK6vHxlhig5+esUCkVjEKPF27XtGCGcKk8TlOW1g7WwCuhJNb3cBJTg4RATiJDZPEAYJ
	Mwt0MUksPSoOYgsLOEtMvd/PDmKzCKhK9D3qYwOxeQU8JF7/7WGDWKYg8eb2M2YQm1PAU+LD
	1sVMILYQUE371ROsIHslBB6xS7Qfec8EMUhA4tvkQywgeyUEZCU2HWCGmCMpcXDFDZYJjMIL
	GBlWMYqmFiQXFCelF5noFSfmFpfmpesl5+duYgRG0el/zybsYLx3wPoQYzLQuInMUqLJ+cAo
	zCuJNzQ2M7IwNTE1NjK3NCNNWEmcV73FOlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDo3OD
	qthkSy9d5oqYjT8XLL+5d0bC2Yy25zMVFET/eKlM75usc+vmEzPZF/9vm3l7fVZZJf1u2p3G
	QqXAx9M8DkddOxx069yd5eyZ/cddPs9eJ5es/MlrqnLP9IWGmyf75Ue/WPdVxDjc8qzOPhUh
	lWPrvnRbX7nBUy7wdnmA7Yq5HNPSZU0fP1diKc5INNRiLipOBABUs3okuAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+xgG7ppMhAg0nbdC0O3q+3OLvsIJtF
	8+L1bBa9C66yWVx42sNmcXnXHDaL2Uv6WSxmnN/HZLFoWSuzxfktnUwWh1ccYLJoPnGK2WLC
	7wtsFutnvGZx4PNY8PkKu8fshossHvNOBnrsn7sGyLv7g9Gjb8sqRo/jN7YzeXzeJBfAEdXA
	aJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdLeSQlli
	TilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMeP4JvOC6VwVh768Z2lg3MvRxcjJ
	ISFgInHw0ysWCFtM4sK99WxdjFwcQgKLGCXern3PCOFMYZK4PKeNFaSKTUBXountLqAEB4eI
	QJzE5gnCIGFmgS4miaVHxUFsYQFnian3+9lBbBYBVYm+R31sIDavgIfE6789bBDLFCTe3H7G
	DGJzCnhKfNi6mAnEFgKqab96gnUCI+8CRoZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMEx
	+kxqB+PKBotDjAIcjEo8vBEXIgKFWBPLiitzDzFKcDArifCuyIwMFOJNSaysSi3Kjy8qzUkt
	PsSYDHTVRGYp0eR8YPrIK4k3NDYxNzU2tTSxMDGzJE1YSZz3QKt1oJBAemJJanZqakFqEcwW
	Jg5OqQbG+rlSDD8WFl/t9PPeOkF5x8rKhTr9bw3NuWpnGLzTnrl2397CmLdvvFNjjBZvLj0a
	bLFg6uX1h9edcZt0zf3WHv4wUaMLunHyBiUBb71v8Lxk2CXYza6gpJp+pONR/+kUu+er++NS
	5vpdm3Is+sZmxjctgton/4dH5/2caqSSIZz59JTHX1sjJZbijERDLeai4kQAX1dmwBUDAAA=
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
 drivers/usb/host/xhci-plat.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index df90fe5..b10573e 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -12,6 +12,7 @@
  */
 
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 
@@ -149,6 +150,9 @@ static int xhci_plat_probe(struct platform_device *pdev)
 	if (ret)
 		goto put_usb3_hcd;
 
+	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
+
 	return 0;
 
 put_usb3_hcd:
@@ -174,6 +178,8 @@ static int xhci_plat_remove(struct platform_device *dev)
 	struct usb_hcd	*hcd = platform_get_drvdata(dev);
 	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
 
+	pm_runtime_disable(&dev->dev);
+
 	usb_remove_hcd(xhci->shared_hcd);
 	usb_put_hcd(xhci->shared_hcd);
 
-- 
1.7.6.5

