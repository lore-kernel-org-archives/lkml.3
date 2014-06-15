Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbaFOG1N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 02:27:13 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:55545 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752624AbaFOG1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 02:27:12 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuEGAAE8nVNXQzGY/2dsb2JhbABagw2rDgYBAwEGmSSBAxd1hGAjgRo3iEYBzwsXhWOIL2QdhC0Ej2yKV4swiCiDQjuBMQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Wolfram Sang <wsa@the-dreams.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/1 RESEND] drivers/parport/parport_ip32.c: use PTR_ERR_OR_ZERO
Date: Sun, 15 Jun 2014 08:25:54 +0200
Message-Id: <1402813554-2750-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

replace IS_ERR/PTR_ERR

Cc: Wolfram Sang <wsa@the-dreams.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
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

