Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbaGZTMS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:12:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34078 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581AbaGZTKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:10:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Loic Poulain <loic.poulain@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 3.14 07/87] Bluetooth: Ignore H5 non-link packets in non-active state
Date: Sat, 26 Jul 2014 12:01:41 -0700
Message-Id: <20140726190214.772223221@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190214.530473925@linuxfoundation.org>
References: <20140726190214.530473925@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Loic Poulain <loic.poulain@intel.com>

commit 48439d501e3d9e8634bdc0c418e066870039599d upstream.

When detecting a non-link packet, h5_reset_rx() frees the Rx skb.
Not returning after that will cause the upcoming h5_rx_payload()
call to dereference a now NULL Rx skb and trigger a kernel oops.

Signed-off-by: Loic Poulain <loic.poulain@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bluetooth/hci_h5.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/bluetooth/hci_h5.c
+++ b/drivers/bluetooth/hci_h5.c
@@ -406,6 +406,7 @@ static int h5_rx_3wire_hdr(struct hci_ua
 	    H5_HDR_PKT_TYPE(hdr) != HCI_3WIRE_LINK_PKT) {
 		BT_ERR("Non-link packet received in non-active state");
 		h5_reset_rx(h5);
+		return 0;
 	}
 
 	h5->rx_func = h5_rx_payload;


