Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbbANIpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:45:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57712 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163AbbANHZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:25:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@intel.com>
Subject: [PATCH 3.18 035/150] Bluetooth: Clear LE white list when resetting controller
Date: Tue, 13 Jan 2015 23:21:46 -0800
Message-Id: <20150114072057.458630275@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcel Holtmann <marcel@holtmann.org>

commit a4d5504d5c39cc84f1f828e19967595597a8136e upstream.

The internal representation of the LE white list needs to be cleared
when receiving a successful HCI_Reset command. A reset of the controller
is expected to start with an empty LE white list.

When the LE white list is not cleared on controller reset, the passive
background scanning might skip programming the remote devices. Only
changes to the LE white list are programmed when passive background
is started.

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/hci_event.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -205,6 +205,8 @@ static void hci_cc_reset(struct hci_dev
 	hdev->le_scan_type = LE_SCAN_PASSIVE;
 
 	hdev->ssp_debug_mode = 0;
+
+	hci_bdaddr_list_clear(&hdev->le_white_list);
 }
 
 static void hci_cc_write_local_name(struct hci_dev *hdev, struct sk_buff *skb)


