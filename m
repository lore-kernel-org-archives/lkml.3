Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab3BANHH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:07:07 -0500
Received: from mail.kernel.org ([198.145.19.201]:44175 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044Ab3BANG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:06:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Olivier Sobrie <olivier@sobrie.be>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [ 03/89] can: pch_can: fix invalid error codes
Date: Fri,  1 Feb 2013 14:07:18 +0100
Message-Id: <20130201130207.700248905@linuxfoundation.org>
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

commit ee50e135aeb048b90fab662e661c58b67341830b upstream.

Errors in CAN protocol (location) are reported in data[3] of the can
frame instead of data[2].

Signed-off-by: Olivier Sobrie <olivier@sobrie.be>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/pch_can.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -560,7 +560,7 @@ static void pch_can_error(struct net_dev
 		stats->rx_errors++;
 		break;
 	case PCH_CRC_ERR:
-		cf->data[2] |= CAN_ERR_PROT_LOC_CRC_SEQ |
+		cf->data[3] |= CAN_ERR_PROT_LOC_CRC_SEQ |
 			       CAN_ERR_PROT_LOC_CRC_DEL;
 		priv->can.can_stats.bus_error++;
 		stats->rx_errors++;


