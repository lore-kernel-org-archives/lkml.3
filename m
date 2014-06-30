Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820AbaF3R2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 13:28:19 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:59345 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755245AbaF3R2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 13:28:17 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhgJAO2dsVNbtAo1/2dsb2JhbABagw2sQQUBAQEBAQEFAW4BmUaBERd1hGAjgRo3iEYByDEXhWSIP2QdhC0Fml6LP4g+g0Q7gTE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>, linux-bluetooth@vger.kernel.org
Subject: [PATCH 1/1] Bluetooth: constify seq_operations
Date: Mon, 30 Jun 2014 19:26:23 +0200
Message-Id: <1404149183-7059-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bt_seq_ops is only used with __seq_open_private as
const struct seq_operations *

Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: linux-bluetooth@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/bluetooth/af_bluetooth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/af_bluetooth.c b/net/bluetooth/af_bluetooth.c
index 2021c48..4dca029 100644
--- a/net/bluetooth/af_bluetooth.c
+++ b/net/bluetooth/af_bluetooth.c
@@ -639,7 +639,7 @@ static int bt_seq_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static struct seq_operations bt_seq_ops = {
+static const struct seq_operations bt_seq_ops = {
 	.start = bt_seq_start,
 	.next  = bt_seq_next,
 	.stop  = bt_seq_stop,
-- 
1.8.4.5

