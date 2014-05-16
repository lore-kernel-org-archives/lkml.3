Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306AbaEPNKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:10:51 -0400
Received: from gloria.sntech.de ([95.129.55.99]:56143 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbaEPNKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:10:50 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] power: generic-adc-battery: return meaningful error when no channel available
Date: Fri, 16 May 2014 15:14:20 +0200
Message-ID: <2822261.bmyft01XjZ@phil>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <3453746.GBc4Nvx1gU@phil>
References: <3453746.GBc4Nvx1gU@phil>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Stuebner <heiko.stuebner@bq.com>

When no channel was found the driver currently always returns -ENODEV. This
hides the actual error which is available in ret from the kernel and disables
for example -EPROBE_DEFER handling.

Signed-off-by: Heiko Stuebner <heiko.stuebner@bq.com>
---
 drivers/power/generic-adc-battery.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/power/generic-adc-battery.c b/drivers/power/generic-adc-battery.c
index 540d57f..02f434b 100644
--- a/drivers/power/generic-adc-battery.c
+++ b/drivers/power/generic-adc-battery.c
@@ -297,10 +297,8 @@ static int gab_probe(struct platform_device *pdev)
 	}
 
 	/* none of the channels are supported so let's bail out */
-	if (index == 0) {
-		ret = -ENODEV;
+	if (index == 0)
 		return ret;
-	}
 
 	/*
 	 * Total number of properties is equal to static properties
-- 
1.9.0


