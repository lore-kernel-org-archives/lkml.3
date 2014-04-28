Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363AbaD1NgK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 09:36:10 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:58322 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756035AbaD1NfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 09:35:22 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Felipe Balbi <balbi@ti.com>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH v8 10/20] usb: phy: msm: Remove HSUSB prefix from regulator names
Date: Mon, 28 Apr 2014 16:34:13 +0300
Message-Id: <1398692063-11372-11-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398692063-11372-1-git-send-email-iivanov@mm-sol.com>
References: <1398692063-11372-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Prefix did not bring any useful information. Currently none
of the MSM platforms define these regulators, so it is safe
to rename them.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/usb/phy/phy-msm-usb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index c2361bf..bd9e286 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -1418,9 +1418,9 @@ static int msm_otg_probe(struct platform_device *pdev)
 		return motg->irq;
 	}

-	regs[0].supply = "HSUSB_VDDCX";
-	regs[1].supply = "HSUSB_3p3";
-	regs[2].supply = "HSUSB_1p8";
+	regs[0].supply = "vddcx";
+	regs[1].supply = "v3p3";
+	regs[2].supply = "v1p8";

 	ret = devm_regulator_bulk_get(motg->phy.dev, ARRAY_SIZE(regs), regs);
 	if (ret)
--
1.8.3.2

