Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbaCHTmu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 14:42:50 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:63824 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbaCHTmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 14:42:47 -0500
From: Richard Cochran <richardcochran@gmail.com>
To: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        Christian Riesch <christian.riesch@omicron.at>,
        David Miller <davem@davemloft.net>,
        =?UTF-8?q?Stefan=20S=C3=B8rensen?= 
	<stefan.sorensen@spectralink.com>
Subject: [PATCH RFC net-next v1 5/9] dp83640: trivial fixes
Date: Sat,  8 Mar 2014 20:42:05 +0100
Message-Id: <90f9511e41d4d2d43478184ccbfa837f816fdf81.1394307304.git.richardcochran@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1394307303.git.richardcochran@gmail.com>
References: <cover.1394307303.git.richardcochran@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up the input checking code on the external time stamp
function by using an unsigned rather than a signed channel index.

Also, this patch corrects the author's email address. When this macro
was last changed, the top level domain part of the email address was
left behind.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/phy/dp83640.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index 98e7cbf..d6c1061 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -424,13 +424,13 @@ static int ptp_dp83640_enable(struct ptp_clock_info *ptp,
 	struct dp83640_clock *clock =
 		container_of(ptp, struct dp83640_clock, caps);
 	struct phy_device *phydev = clock->chosen->phydev;
-	int index;
+	unsigned int index;
 	u16 evnt, event_num, gpio_num;
 
 	switch (rq->type) {
 	case PTP_CLK_REQ_EXTTS:
 		index = rq->extts.index;
-		if (index < 0 || index >= N_EXT_TS)
+		if (index >= N_EXT_TS)
 			return -EINVAL;
 		event_num = EXT_EVENT + index;
 		evnt = EVNT_WR | (event_num & EVNT_SEL_MASK) << EVNT_SEL_SHIFT;
@@ -1363,7 +1363,7 @@ static void __exit dp83640_exit(void)
 }
 
 MODULE_DESCRIPTION("National Semiconductor DP83640 PHY driver");
-MODULE_AUTHOR("Richard Cochran <richardcochran@gmail.at>");
+MODULE_AUTHOR("Richard Cochran <richardcochran@gmail.com>");
 MODULE_LICENSE("GPL");
 
 module_init(dp83640_init);
-- 
1.7.10.4

