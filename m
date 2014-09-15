Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553AbaIOUtk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:49:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55119 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532AbaIOTgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:36:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@intel.com>
Subject: [PATCH 3.16 117/158] Bluetooth: Fix merge of advertising data and scan response data
Date: Mon, 15 Sep 2014 12:25:56 -0700
Message-Id: <20140915192546.388527573@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcel Holtmann <marcel@holtmann.org>

commit 42bd6a56ed1ab4b2cb50f4d4e674874da9b47f46 upstream.

The advertising data and scan response data are merged in the wrong
order. It should be advertsing data first and then scan response data
and not the other way around.

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/hci_event.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4177,8 +4177,8 @@ static void process_adv_report(struct hc
 	 * sending a merged device found event.
 	 */
 	mgmt_device_found(hdev, &d->last_adv_addr, LE_LINK,
-			  d->last_adv_addr_type, NULL, rssi, 0, 1, data, len,
-			  d->last_adv_data, d->last_adv_data_len);
+			  d->last_adv_addr_type, NULL, rssi, 0, 1,
+			  d->last_adv_data, d->last_adv_data_len, data, len);
 	clear_pending_adv_report(hdev);
 }
 


