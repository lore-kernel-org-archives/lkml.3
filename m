Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbaCHTnm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 14:43:42 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:50553 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbaCHTm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 14:42:58 -0500
From: Richard Cochran <richardcochran@gmail.com>
To: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        Christian Riesch <christian.riesch@omicron.at>,
        David Miller <davem@davemloft.net>,
        =?UTF-8?q?Stefan=20S=C3=B8rensen?= 
	<stefan.sorensen@spectralink.com>
Subject: [PATCH RFC net-next v1 8/9] dp83640: let external input pins from the module parameters be defaults.
Date: Sat,  8 Mar 2014 20:42:08 +0100
Message-Id: <15717348d8d80ac471563cf811ffc8db41dea3cb.1394307304.git.richardcochran@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1394307303.git.richardcochran@gmail.com>
References: <cover.1394307303.git.richardcochran@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the driver to use the new pin configuration method when
programming the external time stamp input signals.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/phy/dp83640.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index f98998f..d60b90c 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -468,7 +468,10 @@ static int ptp_dp83640_enable(struct ptp_clock_info *ptp,
 		event_num = EXT_EVENT + index;
 		evnt = EVNT_WR | (event_num & EVNT_SEL_MASK) << EVNT_SEL_SHIFT;
 		if (on) {
-			gpio_num = gpio_tab[EXTTS0_GPIO + index];
+			gpio_num = 1 + ptp_find_pin(clock->ptp_clock,
+						    PTP_PF_EXTTS, index);
+			if (gpio_num < 1)
+				return -EINVAL;
 			evnt |= (gpio_num & EVNT_GPIO_MASK) << EVNT_GPIO_SHIFT;
 			if (rq->extts.flags & PTP_FALLING_EDGE)
 				evnt |= EVNT_FALL;
-- 
1.7.10.4

