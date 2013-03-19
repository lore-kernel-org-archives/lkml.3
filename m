Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932576Ab3CSO55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:57:57 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34961 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756838Ab3CSO5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:57:53 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCHv2 08/12] stating: ti-soc-thermal: use sizeof(*pointer) while allocating
Date: Tue, 19 Mar 2013 10:54:24 -0400
Message-ID: <1363704868-11843-9-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363704868-11843-1-git-send-email-eduardo.valentin@ti.com>
References: <1363704868-11843-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Follow Documentation/CodingStyle and use sizeof(*pointer)
instead of sizeof(struct type).

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/ti-soc-thermal/ti-bandgap.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ti-soc-thermal/ti-bandgap.c b/drivers/staging/ti-soc-thermal/ti-bandgap.c
index 2fe90e1..7d67f72 100644
--- a/drivers/staging/ti-soc-thermal/ti-bandgap.c
+++ b/drivers/staging/ti-soc-thermal/ti-bandgap.c
@@ -900,8 +900,7 @@ static struct ti_bandgap *ti_bandgap_build(struct platform_device *pdev)
 		return ERR_PTR(-EINVAL);
 	}
 
-	bgp = devm_kzalloc(&pdev->dev, sizeof(struct ti_bandgap),
-				    GFP_KERNEL);
+	bgp = devm_kzalloc(&pdev->dev, sizeof(*bgp), GFP_KERNEL);
 	if (!bgp) {
 		dev_err(&pdev->dev, "Unable to allocate mem for driver ref\n");
 		return ERR_PTR(-ENOMEM);
-- 
1.7.7.1.488.ge8e1c

