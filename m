Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239AbaFAM3v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 08:29:51 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:56554 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756936AbaFAM3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 08:29:50 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlsQAFYci1NXQzKE/2dsb2JhbABYgwerUAQBAQEBAQEGmBuBCRd0gwIjgRo3iEYB1V8XhVWIGWQdhCoEj0WKO4sbiBKDOjuBMA
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Wolfram Sang <wsa@the-dreams.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] drivers/parport/parport_ip32.c: use PTR_ERR_OR_ZERO
Date: Sun,  1 Jun 2014 14:28:36 +0200
Message-Id: <1401625716-302-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

replace IS_ERR/PTR_ERR

Cc: Wolfram Sang <wsa@the-dreams.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
This is untested.

 drivers/parport/parport_ip32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/parport/parport_ip32.c b/drivers/parport/parport_ip32.c
index c864f82..30e981b 100644
--- a/drivers/parport/parport_ip32.c
+++ b/drivers/parport/parport_ip32.c
@@ -2204,7 +2204,7 @@ static int __init parport_ip32_init(void)
 {
 	pr_info(PPIP32 "SGI IP32 built-in parallel port driver v0.6\n");
 	this_port = parport_ip32_probe_port();
-	return IS_ERR(this_port) ? PTR_ERR(this_port) : 0;
+	return PTR_ERR_OR_ZERO(this_port);
 }
 
 /**
-- 
1.8.4.5

