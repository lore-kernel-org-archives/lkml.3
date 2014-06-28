Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964794AbaF1SGb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:06:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54361 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052AbaF1Rwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:52:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hedberg <johan.hedberg@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 3.15 084/139] Bluetooth: Fix authentication check for FIPS security level
Date: Sat, 28 Jun 2014 10:47:25 -0700
Message-Id: <20140628174609.267221542@linuxfoundation.org>
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

commit 7e3691e13ab51f3491e996e2edaf99b173621288 upstream.

When checking whether we need to request authentication or not we should
include HCI_SECURITY_FIPS to the levels that always need authentication.
This patch fixes check for it in the hci_outgoing_auth_needed()
function.

Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/hci_event.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -1342,6 +1342,7 @@ static int hci_outgoing_auth_needed(stru
 	 * is requested.
 	 */
 	if (!hci_conn_ssp_enabled(conn) && !(conn->auth_type & 0x01) &&
+	    conn->pending_sec_level != BT_SECURITY_FIPS &&
 	    conn->pending_sec_level != BT_SECURITY_HIGH &&
 	    conn->pending_sec_level != BT_SECURITY_MEDIUM)
 		return 0;


