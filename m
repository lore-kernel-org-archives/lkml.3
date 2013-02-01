Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab3BAN2V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:28:21 -0500
Received: from mail.kernel.org ([198.145.19.201]:44164 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755323Ab3BANGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:06:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Olivier Sobrie <olivier@sobrie.be>, Anant Gole <anantgole@ti.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [ 02/89] can: ti_hecc: fix invalid error codes
Date: Fri,  1 Feb 2013 14:07:17 +0100
Message-Id: <20130201130207.630221652@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olivier Sobrie <olivier@sobrie.be>

commit 71088c4bd9b8f8cbffb0e66f2abc14297e4b2ca8 upstream.

Errors in CAN protocol (location) are reported in data[3] of the can
frame instead of data[2].

Signed-off-by: Olivier Sobrie <olivier@sobrie.be>
Cc: Anant Gole <anantgole@ti.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/ti_hecc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/can/ti_hecc.c
+++ b/drivers/net/can/ti_hecc.c
@@ -746,12 +746,12 @@ static int ti_hecc_error(struct net_devi
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


