Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab3A2B7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 20:59:50 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:36027 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752598Ab3A2B7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 20:59:09 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v3 4/6] staging/fwserial: Fold constant MAX_ASYNC_PAYLOAD
Date: Mon, 28 Jan 2013 20:57:47 -0500
Message-Id: <1359424669-5723-5-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359424669-5723-1-git-send-email-peter@hurleysoftware.com>
References: <20130107232206.GA15244@kroah.com>
 <1359424669-5723-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since peer->max_payload is now limited to 1394-2008 spec maximum
of 4096, the port->max_payload limit can now be simplified.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/staging/fwserial/fwserial.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
index ae180a3..940639f 100644
--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -1674,8 +1674,7 @@ static void fwserial_virt_plug_complete(struct fwtty_peer *peer,
 
 	/* reconfigure tx_fifo optimally for this peer */
 	spin_lock_bh(&port->lock);
-	port->max_payload = min3(peer->max_payload, peer->fifo_len,
-				 MAX_ASYNC_PAYLOAD);
+	port->max_payload = min(peer->max_payload, peer->fifo_len);
 	dma_fifo_change_tx_limit(&port->tx_fifo, port->max_payload);
 	spin_unlock_bh(&peer->port->lock);
 
-- 
1.8.1.1

