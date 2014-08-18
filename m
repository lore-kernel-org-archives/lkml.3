Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbaHRKLP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 06:11:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42391 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbaHRJd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:33:27 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Loic Poulain <loic.poulain@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 001/137] Bluetooth: Ignore H5 non-link packets in non-active state
Date: Mon, 18 Aug 2014 10:31:02 +0100
Message-Id: <1408354398-10226-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Loic Poulain <loic.poulain@intel.com>

commit 48439d501e3d9e8634bdc0c418e066870039599d upstream.

When detecting a non-link packet, h5_reset_rx() frees the Rx skb.
Not returning after that will cause the upcoming h5_rx_payload()
call to dereference a now NULL Rx skb and trigger a kernel oops.

Signed-off-by: Loic Poulain <loic.poulain@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/bluetooth/hci_h5.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/hci_h5.c b/drivers/bluetooth/hci_h5.c
index b6154d5a07a5..db0be2fb05fe 100644
--- a/drivers/bluetooth/hci_h5.c
+++ b/drivers/bluetooth/hci_h5.c
@@ -406,6 +406,7 @@ static int h5_rx_3wire_hdr(struct hci_uart *hu, unsigned char c)
 	    H5_HDR_PKT_TYPE(hdr) != HCI_3WIRE_LINK_PKT) {
 		BT_ERR("Non-link packet received in non-active state");
 		h5_reset_rx(h5);
+		return 0;
 	}
 
 	h5->rx_func = h5_rx_payload;
-- 
1.9.1

