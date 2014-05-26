Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaEZSYa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 14:24:30 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:50426 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbaEZSY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 14:24:28 -0400
Message-ID: <1401128657.24099.17.camel@localhost.localdomain>
Subject: [PATCH 1/2] emac: add missing support of 10mbit in emac/rgmii
From: Ivan Mikhaylov <ivan@ru.ibm.com>
To: netdev@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alistair Popple <alistair@popple.id.au>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>
Date: Mon, 26 May 2014 22:24:17 +0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052618-9332-0000-0000-000000E764AD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In chips of emac/rgmii b'000' for 0/1 channel isn't suitable which
resulted in non working network interface in this mode.

Signed-off-by: Ivan Mikhaylov <ivan@ru.ibm.com>

---
 drivers/net/ethernet/ibm/emac/rgmii.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/ibm/emac/rgmii.c b/drivers/net/ethernet/ibm/emac/rgmii.c
index 4fb2f96..a01182c 100644
--- a/drivers/net/ethernet/ibm/emac/rgmii.c
+++ b/drivers/net/ethernet/ibm/emac/rgmii.c
@@ -45,6 +45,7 @@
 
 /* RGMIIx_SSR */
 #define RGMII_SSR_MASK(idx)	(0x7 << ((idx) * 8))
+#define RGMII_SSR_10(idx)	(0x1 << ((idx) * 8))
 #define RGMII_SSR_100(idx)	(0x2 << ((idx) * 8))
 #define RGMII_SSR_1000(idx)	(0x4 << ((idx) * 8))
 
@@ -139,6 +140,8 @@ void rgmii_set_speed(struct platform_device *ofdev, int input, int speed)
 		ssr |= RGMII_SSR_1000(input);
 	else if (speed == SPEED_100)
 		ssr |= RGMII_SSR_100(input);
+	else if (speed == SPEED_10)
+		ssr |= RGMII_SSR_10(input);
 
 	out_be32(&p->ssr, ssr);
 
-- 
1.9.3



