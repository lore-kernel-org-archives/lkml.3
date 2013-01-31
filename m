Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab3AaLNu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 06:13:50 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:61394 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab3AaLNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 06:13:46 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-6a-510a51e9bf00
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, kishon@ti.com
Subject: [PATCH RFC] usb: dwc3: Get PHY from platform specific dwc3 dt node.
Date: Thu, 31 Jan 2013 16:50:32 +0530
Message-id: <1359631232-7107-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsWyRsSkVvdlIFegwf7/RhaXd81hs5i9pJ/F
	Ysb5fUwWi5a1MjuweHzeJBfAGMVlk5Kak1mWWqRvl8CV8fR5O1PBEp6KZwtWszQwzuTqYuTk
	kBAwkfh39SkrhC0mceHeerYuRi4OIYGljBLTG1YzwxSdfPWNESIxnVFi65c+VghnMpNE44+r
	bCBVbAK6Ek1vdzGC2CICshKHr/xmBiliFpjDKNHT+xNslLCAj8T3zd/A9rEIqEps7N4L1swr
	4C6xf+lmqHUKEm9uP4OyL7NJLOzJgqgXkPg2+RBLFyMHUFxWYtMBqBJJiYMrbrBMYBRcwMiw
	ilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyMw5E7/eya1g3Flg8UhRgEORiUeXg1HzkAh1sSy
	4srcQ4wSHMxKIryV+lyBQrwpiZVVqUX58UWlOanFhxiTgZZPZJYSTc4HxkNeSbyhsYm5qbGp
	pZGRmakpacJK4ryMp54ECAmkJ5akZqemFqQWwWxh4uCUamC0Osyx4P3BBYdTr4crno+/kNST
	uNP/4cPTHnudzimF5Zi9+sW3t0heo7mhRzXiZ5NKuIHEU9ur8fIXNhhmW6iUVsUKFMye4ff2
	2TUDoVMLr2yorhdNkJ3TfI/Fq2qfjuyGVX6fW8w2qb85U7JhyzPB9U2rqiXFJu6QeDzZzZ/r
	9MqDZ6/O/Z2uxFKckWioxVxUnAgAyo0DnH0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsVy+t9jQd2XgVyBBktfqVhc3jWHzWL2kn4W
	ixnn9zFZLFrWyuzA4vF5k1wAY1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5
	kkJeYm6qrZKLT4CuW2YO0BIlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEN
	Y8bT5+1MBUt4Kp4tWM3SwDiTq4uRk0NCwETi5KtvjBC2mMSFe+vZuhi5OIQEpjNKbP3Sxwrh
	TGaSaPxxlQ2kik1AV6Lp7S6wDhEBWYnDV34zgxQxC8xhlOjp/ckMkhAW8JH4vvkbK4jNIqAq
	sbF7L1gzr4C7xP6lm5kh1ilIvLn9jHkCI/cCRoZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmb
	GMEh/UxqB+PKBotDjAIcjEo8vBqOnIFCrIllxZW5hxglOJiVRHgr9bkChXhTEiurUovy44tK
	c1KLDzEmA22fyCwlmpwPjLe8knhDYxNzU2NTSxMLEzNL0oSVxHkZTz0JEBJITyxJzU5NLUgt
	gtnCxMEp1cDoxZSeOcObeavKobIf/7RvOin+dCv0uSaeeKXw1OM69Tj3Wcnvw8rZiry67GvV
	mPKdTZZu++j7eOoGOxOHaI+eug3nzoTWel2WEODoqa0RfJ/PHy+WFLZw6oqmMr8ti6cFqxUc
	cZ0fOF9vRdXOP6+2Z/yPtOe23dl+4++VCgs3RdNLTQvb9yqxFGckGmoxFxUnAgDOjW5xrQIA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With device tree support in place for dwc3-core layer,
it gets PHY from "synopsis-dwc3" node.
Some controllers may not have separate memory maps and interrupts
for dwc3 core and platform glue layers. In such case only glue
layer's node will exist.
Moreover, SoCs having multiple dwc3 controllers will have multiple
PHYs, which eventually be added using usb_add_phy_dev(), and not
using usb_add_phy(). So each dwc3 controller won't be able to
get PHYs by simply calling devm_usb_get_phy() also.
In such cases, dwc3 should expect PHYs from its parent's node.
So, adding provision for getting PHY from platform specific
device tree node.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---

Based on 'usb-next'.

 drivers/usb/dwc3/core.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 9999094..75439c0 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -423,6 +423,11 @@ static int dwc3_probe(struct platform_device *pdev)
 	if (node) {
 		dwc->usb2_phy = devm_usb_get_phy_by_phandle(dev, "usb-phy", 0);
 		dwc->usb3_phy = devm_usb_get_phy_by_phandle(dev, "usb-phy", 1);
+	} else if (dev->parent->of_node) {
+		dwc->usb2_phy = devm_usb_get_phy_by_phandle(dev->parent,
+								"usb-phy", 0);
+		dwc->usb3_phy = devm_usb_get_phy_by_phandle(dev->parent,
+								"usb-phy", 1);
 	} else {
 		dwc->usb2_phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
 		dwc->usb3_phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB3);
-- 
1.7.6.5

