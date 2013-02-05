Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757802Ab3BEWL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:11:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48116 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757740Ab3BEWLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:11:20 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bhupesh Sharma <bhupesh.sharma@st.com>, Olivier Sobrie <olivier@sobrie.be>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 59/93] can: c_can: fix invalid error codes
Date: Tue,  5 Feb 2013 20:06:48 -0200
Message-Id: <1360102042-10732-60-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olivier Sobrie <olivier@sobrie.be>

commit 6ea45886865c1abb01bb861f7f6bdd5d0f398cb3 upstream.

Errors in CAN protocol (location) are reported in data[3] of the can
frame instead of data[2].

Cc: Bhupesh Sharma <bhupesh.sharma@st.com>
Signed-off-by: Olivier Sobrie <olivier@sobrie.be>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/can/c_can/c_can.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 86cd532..21a3d77 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -914,7 +914,7 @@ static int c_can_handle_bus_err(struct net_device *dev,
 		break;
 	case LEC_ACK_ERROR:
 		netdev_dbg(dev, "ack error\n");
-		cf->data[2] |= (CAN_ERR_PROT_LOC_ACK |
+		cf->data[3] |= (CAN_ERR_PROT_LOC_ACK |
 				CAN_ERR_PROT_LOC_ACK_DEL);
 		break;
 	case LEC_BIT1_ERROR:
@@ -927,7 +927,7 @@ static int c_can_handle_bus_err(struct net_device *dev,
 		break;
 	case LEC_CRC_ERROR:
 		netdev_dbg(dev, "CRC error\n");
-		cf->data[2] |= (CAN_ERR_PROT_LOC_CRC_SEQ |
+		cf->data[3] |= (CAN_ERR_PROT_LOC_CRC_SEQ |
 				CAN_ERR_PROT_LOC_CRC_DEL);
 		break;
 	default:
-- 
1.7.9.5

