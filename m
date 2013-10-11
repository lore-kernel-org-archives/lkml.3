Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab3JKU4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:56:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45342 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757238Ab3JKThR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:37:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andre Guedes <andre.guedes@openbossa.org>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: [ 27/48] Bluetooth: Fix encryption key size for peripheral role
Date: Fri, 11 Oct 2013 12:36:34 -0700
Message-Id: <20131011193640.176561765@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193637.253208688@linuxfoundation.org>
References: <20131011193637.253208688@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andre Guedes <andre.guedes@openbossa.org>

commit 89cbb4da0abee2f39d75f67f9fd57f7410c8b65c upstream.

This patch fixes the connection encryption key size information when
the host is playing the peripheral role. We should set conn->enc_key_
size in hci_le_ltk_request_evt, otherwise it is left uninitialized.

Signed-off-by: Andre Guedes <andre.guedes@openbossa.org>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/hci_event.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3379,6 +3379,8 @@ static inline void hci_le_ltk_request_ev
 	else
 		conn->pending_sec_level = BT_SECURITY_MEDIUM;
 
+	conn->enc_key_size = ltk->enc_size;
+
 	hci_send_cmd(hdev, HCI_OP_LE_LTK_REPLY, sizeof(cp), &cp);
 
 	if (ltk->type & HCI_SMP_STK) {


