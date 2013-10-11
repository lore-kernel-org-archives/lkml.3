Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421Ab3JKKv1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:51:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58740 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932301Ab3JKKoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:44:01 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andre Guedes <andre.guedes@openbossa.org>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 078/100] Bluetooth: Fix encryption key size for peripheral role
Date: Fri, 11 Oct 2013 11:41:48 +0100
Message-Id: <1381488130-30235-79-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andre Guedes <andre.guedes@openbossa.org>

commit 89cbb4da0abee2f39d75f67f9fd57f7410c8b65c upstream.

This patch fixes the connection encryption key size information when
the host is playing the peripheral role. We should set conn->enc_key_
size in hci_le_ltk_request_evt, otherwise it is left uninitialized.

Signed-off-by: Andre Guedes <andre.guedes@openbossa.org>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/bluetooth/hci_event.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 9871e8b..7797c9d 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3456,6 +3456,8 @@ static inline void hci_le_ltk_request_evt(struct hci_dev *hdev,
 	else
 		conn->pending_sec_level = BT_SECURITY_MEDIUM;
 
+	conn->enc_key_size = ltk->enc_size;
+
 	hci_send_cmd(hdev, HCI_OP_LE_LTK_REPLY, sizeof(cp), &cp);
 
 	if (ltk->type & HCI_SMP_STK) {
-- 
1.8.3.2

