Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab3BCPFP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:05:15 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34544 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754812Ab3BCO57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:57:59 -0500
Message-Id: <20130203144652.545911853@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:48:20 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Olivier Sobrie <olivier@sobrie.be>,
        Bhupesh Sharma <bhupesh.sharma@st.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [ 096/128] can: c_can: fix invalid error codes
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

commit 6ea45886865c1abb01bb861f7f6bdd5d0f398cb3 upstream.

Errors in CAN protocol (location) are reported in data[3] of the can
frame instead of data[2].

Cc: Bhupesh Sharma <bhupesh.sharma@st.com>
Signed-off-by: Olivier Sobrie <olivier@sobrie.be>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/can/c_can/c_can.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 5233b8f..58607f1 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -960,7 +960,7 @@ static int c_can_handle_bus_err(struct net_device *dev,
 		break;
 	case LEC_ACK_ERROR:
 		netdev_dbg(dev, "ack error\n");
-		cf->data[2] |= (CAN_ERR_PROT_LOC_ACK |
+		cf->data[3] |= (CAN_ERR_PROT_LOC_ACK |
 				CAN_ERR_PROT_LOC_ACK_DEL);
 		break;
 	case LEC_BIT1_ERROR:
@@ -973,7 +973,7 @@ static int c_can_handle_bus_err(struct net_device *dev,
 		break;
 	case LEC_CRC_ERROR:
 		netdev_dbg(dev, "CRC error\n");
-		cf->data[2] |= (CAN_ERR_PROT_LOC_CRC_SEQ |
+		cf->data[3] |= (CAN_ERR_PROT_LOC_CRC_SEQ |
 				CAN_ERR_PROT_LOC_CRC_DEL);
 		break;
 	default:


