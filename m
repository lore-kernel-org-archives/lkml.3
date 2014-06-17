Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbaFQTYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 15:24:38 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:49486 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755372AbaFQTYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 15:24:37 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlQJACCVoFNbsl1t/2dsb2JhbABagw2rKgUBAQEBAQEFAZkmgQ0XdYQxLyOBGjeIRgHLOBeFY4kTHYQtBJpDk1iDQjs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Samuel Ortiz <samuel@sortiz.org>,
        netdev@vger.kernel.org
Subject: [PATCH 1/1] drivers/net/irda/kingsun-sir.c: remove null test before kfree
Date: Tue, 17 Jun 2014 21:22:50 +0200
Message-Id: <1403032970-6471-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning:
WARNING: kfree(NULL) is safe this check is probably not required

Cc: Samuel Ortiz <samuel@sortiz.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/irda/kingsun-sir.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/irda/kingsun-sir.c b/drivers/net/irda/kingsun-sir.c
index 96fe365..e638893 100644
--- a/drivers/net/irda/kingsun-sir.c
+++ b/drivers/net/irda/kingsun-sir.c
@@ -553,8 +553,8 @@ static int kingsun_probe(struct usb_interface *intf,
 	return 0;
 
 free_mem:
-	if (kingsun->out_buf) kfree(kingsun->out_buf);
-	if (kingsun->in_buf) kfree(kingsun->in_buf);
+	kfree(kingsun->out_buf);
+	kfree(kingsun->in_buf);
 	free_netdev(net);
 err_out1:
 	return ret;
-- 
1.8.4.5

