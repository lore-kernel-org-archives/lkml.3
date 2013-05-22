Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757671Ab3EVWOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 18:14:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42148 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757505Ab3EVWKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 18:10:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jon Mason <jon.mason@intel.com>
Subject: [ 13/21] NTB: fix pointer math issues
Date: Wed, 22 May 2013 15:10:31 -0700
Message-Id: <20130522205234.156185697@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130522205232.597066680@linuxfoundation.org>
References: <20130522205232.597066680@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit cc0f868d8adef7bdc12cda132654870086d766bc upstream.

->remote_rx_info and ->rx_info are struct ntb_rx_info pointers.  If we
add sizeof(struct ntb_rx_info) then it goes too far.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jon Mason <jon.mason@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ntb/ntb_transport.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -486,7 +486,7 @@ static void ntb_transport_setup_qp_mw(st
 			     (qp_num / NTB_NUM_MW * rx_size);
 	rx_size -= sizeof(struct ntb_rx_info);
 
-	qp->rx_buff = qp->remote_rx_info + sizeof(struct ntb_rx_info);
+	qp->rx_buff = qp->remote_rx_info + 1;
 	qp->rx_max_frame = min(transport_mtu, rx_size);
 	qp->rx_max_entry = rx_size / qp->rx_max_frame;
 	qp->rx_index = 0;
@@ -780,7 +780,7 @@ static void ntb_transport_init_queue(str
 		      (qp_num / NTB_NUM_MW * tx_size);
 	tx_size -= sizeof(struct ntb_rx_info);
 
-	qp->tx_mw = qp->rx_info + sizeof(struct ntb_rx_info);
+	qp->tx_mw = qp->rx_info + 1;
 	qp->tx_max_frame = min(transport_mtu, tx_size);
 	qp->tx_max_entry = tx_size / qp->tx_max_frame;
 	qp->tx_index = 0;


