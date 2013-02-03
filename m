Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116Ab3BCPCO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:02:14 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34591 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755005Ab3BCO6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:58:16 -0500
Message-Id: <20130203144652.630301626@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:48:21 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Olivier Sobrie <olivier@sobrie.be>,
        Anant Gole <anantgole@ti.com>, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [ 097/128] can: ti_hecc: fix invalid error codes
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olivier Sobrie <olivier@sobrie.be>

commit 71088c4bd9b8f8cbffb0e66f2abc14297e4b2ca8 upstream.

Errors in CAN protocol (location) are reported in data[3] of the can
frame instead of data[2].

Cc: Anant Gole <anantgole@ti.com>
Signed-off-by: Olivier Sobrie <olivier@sobrie.be>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/can/ti_hecc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/ti_hecc.c b/drivers/net/can/ti_hecc.c
index f898c63..300581b 100644
--- a/drivers/net/can/ti_hecc.c
+++ b/drivers/net/can/ti_hecc.c
@@ -746,12 +746,12 @@ static int ti_hecc_error(struct net_device *ndev, int int_status,
 		}
 		if (err_status & HECC_CANES_CRCE) {
 			hecc_set_bit(priv, HECC_CANES, HECC_CANES_CRCE);
-			cf->data[2] |= CAN_ERR_PROT_LOC_CRC_SEQ |
+			cf->data[3] |= CAN_ERR_PROT_LOC_CRC_SEQ |
 					CAN_ERR_PROT_LOC_CRC_DEL;
 		}
 		if (err_status & HECC_CANES_ACKE) {
 			hecc_set_bit(priv, HECC_CANES, HECC_CANES_ACKE);
-			cf->data[2] |= CAN_ERR_PROT_LOC_ACK |
+			cf->data[3] |= CAN_ERR_PROT_LOC_ACK |
 					CAN_ERR_PROT_LOC_ACK_DEL;
 		}
 	}


