Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbaFAN5I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 09:57:08 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:55112 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbaFAN5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 09:57:04 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: bluetooth: hci_core.c:  Cleaning up uninitialized variables
Date: Sun,  1 Jun 2014 15:57:56 +0200
Message-Id: <1401631076-20818-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a risk that the variable will be used without being initialized.

This was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 net/bluetooth/hci_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 1c6ffaa..1d93d2f 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -4603,7 +4603,7 @@ static struct hci_chan *hci_chan_sent(struct hci_dev *hdev, __u8 type,
 	struct hci_chan *chan = NULL;
 	unsigned int num = 0, min = ~0, cur_prio = 0;
 	struct hci_conn *conn;
-	int cnt, q, conn_num = 0;
+	int cnt, q = 0, conn_num = 0;
 
 	BT_DBG("%s", hdev->name);
 
-- 
1.7.10.4

