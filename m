Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbaIOTcc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:32:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54675 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109AbaIOT1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:27:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hedberg <johan.hedberg@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 3.16 120/158] Bluetooth: Fix using uninitialized variable when pairing
Date: Mon, 15 Sep 2014 12:25:59 -0700
Message-Id: <20140915192546.482449632@linuxfoundation.org>
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

From: Johan Hedberg <johan.hedberg@intel.com>

commit 9f743d7499bc2c4dc8c35af33bdb2a29bea663b9 upstream.

Commit 6c53823ae0e10e723131055e1e65dd6a328a228e reshuffled the way the
authentication requirement gets set in the hci_io_capa_request_evt()
function, but at the same time it failed to update an if-statement where
cp.authentication is used before it has been initialized. The correct
value the code should be looking for in this if-statement is
conn->auth_type.

Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/hci_event.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3542,7 +3542,7 @@ static void hci_io_capa_request_evt(stru
 			 * except for the no-bonding case.
 			 */
 			if (conn->io_capability != HCI_IO_NO_INPUT_OUTPUT &&
-			    cp.authentication != HCI_AT_NO_BONDING)
+			    conn->auth_type != HCI_AT_NO_BONDING)
 				conn->auth_type |= 0x01;
 
 			cp.authentication = conn->auth_type;


