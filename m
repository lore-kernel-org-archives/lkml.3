Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630Ab3EVWNY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 18:13:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42159 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757528Ab3EVWKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 18:10:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jon Mason <jon.mason@intel.com>
Subject: [ 16/21] NTB: reset tx_index on link toggle
Date: Wed, 22 May 2013 15:10:34 -0700
Message-Id: <20130522205234.499685625@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130522205232.597066680@linuxfoundation.org>
References: <20130522205232.597066680@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jon Mason <jon.mason@intel.com>

commit 90f9e934647e652a69396e18c779215a493271cf upstream.

If the NTB link toggles, the driver could stop receiving due to the
tx_index not being set to 0 on the transmitting size on a link-up event.
This is due to the driver expecting the incoming data to start at the
beginning of the receive buffer and not at a random place.

Signed-off-by: Jon Mason <jon.mason@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ntb/ntb_transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -505,6 +505,7 @@ static void ntb_transport_setup_qp_mw(st
 
 	qp->rx_pkts = 0;
 	qp->tx_pkts = 0;
+	qp->tx_index = 0;
 }
 
 static void ntb_free_mw(struct ntb_transport *nt, int num_mw)
@@ -819,7 +820,6 @@ static void ntb_transport_init_queue(str
 	qp->tx_mw = qp->rx_info + 1;
 	qp->tx_max_frame = min(transport_mtu, tx_size);
 	qp->tx_max_entry = tx_size / qp->tx_max_frame;
-	qp->tx_index = 0;
 
 	if (nt->debugfs_dir) {
 		char debugfs_name[4];


