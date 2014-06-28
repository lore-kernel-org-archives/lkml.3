Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339AbaF1RwZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:52:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54296 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320AbaF1RwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:52:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hedberg <johan.hedberg@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 3.15 086/139] Bluetooth: Fix missing check for FIPS security level
Date: Sat, 28 Jun 2014 10:47:27 -0700
Message-Id: <20140628174609.361212277@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hedberg <johan.hedberg@intel.com>

commit f3fb0b58c85666f73139963a7a04d7878f3d22c9 upstream.

When checking whether a legacy link key provides at least HIGH security
level we also need to check for FIPS level which is one step above HIGH.
This patch fixes a missing check in the hci_link_key_request_evt()
function.

Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/hci_event.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2958,7 +2958,8 @@ static void hci_link_key_request_evt(str
 		}
 
 		if (key->type == HCI_LK_COMBINATION && key->pin_len < 16 &&
-		    conn->pending_sec_level == BT_SECURITY_HIGH) {
+		    (conn->pending_sec_level == BT_SECURITY_HIGH ||
+		     conn->pending_sec_level == BT_SECURITY_FIPS)) {
 			BT_DBG("%s ignoring key unauthenticated for high security",
 			       hdev->name);
 			goto not_found;


