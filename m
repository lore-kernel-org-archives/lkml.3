Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbbAGNzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 08:55:00 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:65317 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbbAGNy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 08:54:59 -0500
From: Hubert Feurstein <h.feurstein@gmail.com>
X-Google-Original-From: Hubert Feurstein <hubert.feurstein@deto.at>
To: netdev@vger.kernel.org
Cc: fabio.estevam@freescale.com, frank.li@freescale.com,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        Hubert Feurstein <h.feurstein@gmail.com>
Subject: [PATCH] net: fec: fix NULL pointer dereference in fec_enet_timeout_work
Date: Wed,  7 Jan 2015 14:48:17 +0100
Message-Id: <1420638497-6871-1-git-send-email-hubert.feurstein@deto.at>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hubert Feurstein <h.feurstein@gmail.com>

This patch initialises the fep->netdev pointer. This pointer was not
initialised at all, but is used in fec_enet_timeout_work and in some
error paths.

Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 5ebdf8d..dbcab1c 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3129,6 +3129,7 @@ fec_probe(struct platform_device *pdev)
 		pdev->id_entry = of_id->data;
 	fep->quirks = pdev->id_entry->driver_data;
 
+	fep->netdev = ndev;
 	fep->num_rx_queues = num_rx_qs;
 	fep->num_tx_queues = num_tx_qs;
 
-- 
2.2.1

