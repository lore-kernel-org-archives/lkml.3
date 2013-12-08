Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759543Ab3LHPEY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 10:04:24 -0500
Received: from 9.mo1.mail-out.ovh.net ([178.32.108.172]:55857 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756025Ab3LHPEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 10:04:20 -0500
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Douglas Gilbert <dgilbert@interlog.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Grant Likely <grant.likely@linaro.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
Subject: [PATCH v4 2/3] usb: ohci-at91: use dev variable instead of &pdev->dev
Date: Sun,  8 Dec 2013 16:02:59 +0100
Message-Id: <1386514980-6383-3-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386514980-6383-1-git-send-email-b.brezillon@overkiz.com>
References: <1386514980-6383-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 9970125150914050305
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrkeekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrkeekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of the dev variable instead of referencing the dev field of the
pdev struct.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/host/ohci-at91.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
index fe2ecc5..30f1445 100644
--- a/drivers/usb/host/ohci-at91.c
+++ b/drivers/usb/host/ohci-at91.c
@@ -152,7 +152,7 @@ static int usb_hcd_at91_probe(const struct hc_driver *driver,
 		return irq;
 	}
 
-	hcd = usb_create_hcd(driver, &pdev->dev, "at91");
+	hcd = usb_create_hcd(driver, dev, "at91");
 	if (!hcd)
 		return -ENOMEM;
 	hcd->rsrc_start = res->start;
@@ -165,28 +165,28 @@ static int usb_hcd_at91_probe(const struct hc_driver *driver,
 		goto err;
 	}
 
-	iclk = clk_get(&pdev->dev, "ohci_clk");
+	iclk = clk_get(dev, "ohci_clk");
 	if (IS_ERR(iclk)) {
-		dev_err(&pdev->dev, "failed to get ohci_clk\n");
+		dev_err(dev, "failed to get ohci_clk\n");
 		retval = PTR_ERR(iclk);
 		goto err;
 	}
-	fclk = clk_get(&pdev->dev, "uhpck");
+	fclk = clk_get(dev, "uhpck");
 	if (IS_ERR(fclk)) {
-		dev_err(&pdev->dev, "failed to get uhpck\n");
+		dev_err(dev, "failed to get uhpck\n");
 		retval = PTR_ERR(fclk);
 		goto err4;
 	}
-	hclk = clk_get(&pdev->dev, "hclk");
+	hclk = clk_get(dev, "hclk");
 	if (IS_ERR(hclk)) {
-		dev_err(&pdev->dev, "failed to get hclk\n");
+		dev_err(dev, "failed to get hclk\n");
 		retval = PTR_ERR(hclk);
 		goto err5;
 	}
 	if (IS_ENABLED(CONFIG_COMMON_CLK)) {
-		uclk = clk_get(&pdev->dev, "usb_clk");
+		uclk = clk_get(dev, "usb_clk");
 		if (IS_ERR(uclk)) {
-			dev_err(&pdev->dev, "failed to get uclk\n");
+			dev_err(dev, "failed to get uclk\n");
 			retval = PTR_ERR(uclk);
 			goto err6;
 		}
-- 
1.7.9.5

