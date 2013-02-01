Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161023Ab3BAKrP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:47:15 -0500
Received: from mail.kernel.org ([198.145.19.201]:38545 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932072Ab3BAKrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:47:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Olivier Sobrie <olivier@sobrie.be>,
        Bhupesh Sharma <bhupesh.sharma@st.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [ 01/15] can: c_can: fix invalid error codes
Date: Fri,  1 Feb 2013 11:48:34 +0100
Message-Id: <20130201104756.575187263@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201104756.470588207@linuxfoundation.org>
References: <20130201104756.470588207@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olivier Sobrie <olivier@sobrie.be>

commit 6ea45886865c1abb01bb861f7f6bdd5d0f398cb3 upstream.

Errors in CAN protocol (location) are reported in data[3] of the can
frame instead of data[2].

Signed-off-by: Olivier Sobrie <olivier@sobrie.be>
Cc: Bhupesh Sharma <bhupesh.sharma@st.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/c_can/c_can.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -916,7 +916,7 @@ static int c_can_handle_bus_err(struct n
 		break;
 	case LEC_ACK_ERROR:
 		netdev_dbg(dev, "ack error\n");
-		cf->data[2] |= (CAN_ERR_PROT_LOC_ACK |
+		cf->data[3] |= (CAN_ERR_PROT_LOC_ACK |
 				CAN_ERR_PROT_LOC_ACK_DEL);
 		break;
 	case LEC_BIT1_ERROR:
@@ -929,7 +929,7 @@ static int c_can_handle_bus_err(struct n
 		break;
 	case LEC_CRC_ERROR:
 		netdev_dbg(dev, "CRC error\n");
-		cf->data[2] |= (CAN_ERR_PROT_LOC_CRC_SEQ |
+		cf->data[3] |= (CAN_ERR_PROT_LOC_CRC_SEQ |
 				CAN_ERR_PROT_LOC_CRC_DEL);
 		break;
 	default:


