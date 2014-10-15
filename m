Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbaJOTA5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 15:00:57 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:52804 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751436AbaJOTAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 15:00:55 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4SAIzDPlRbtBXi/2dsb2JhbABbgw6BK7guBQFzmiMEAoEYFwF9hDAvI4EaN4hCAblfj0eGIoosHYQ1BZ1UlhqBRwGCMTsvgkoBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 1/1 net-next] NFC: digital: remove redundant memory message
Date: Wed, 15 Oct 2014 21:00:49 +0200
Message-Id: <1413399649-8172-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let MM subsystem display out of memory messages.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/nfc/digital_core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/nfc/digital_core.c b/net/nfc/digital_core.c
index 009bcf3..41ba70c 100644
--- a/net/nfc/digital_core.c
+++ b/net/nfc/digital_core.c
@@ -697,10 +697,8 @@ static int digital_in_send(struct nfc_dev *nfc_dev, struct nfc_target *target,
 	int rc;
 
 	data_exch = kzalloc(sizeof(struct digital_data_exch), GFP_KERNEL);
-	if (!data_exch) {
-		pr_err("Failed to allocate data_exch struct\n");
+	if (!data_exch)
 		return -ENOMEM;
-	}
 
 	data_exch->cb = cb;
 	data_exch->cb_context = cb_context;
-- 
1.9.3

