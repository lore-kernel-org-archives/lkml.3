Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935031Ab3DHKau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:30:50 -0400
Received: from webhosting06.bon.m2soft.com ([195.38.20.37]:55703 "EHLO
	webhosting06.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762080Ab3DHKas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 06:30:48 -0400
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Apr 2013 06:30:48 EDT
X-No-Relay: not in my network
X-No-Relay: not in my network
Date: Mon, 8 Apr 2013 12:18:58 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Kay Sievers <kay@vrfy.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] printk: fix failure to return error in devkmsg_poll
Message-ID: <20130408121858.70d2e601@absol.kitzblitz>
Organization: -
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwAQMAAABtzGvEAAAAAXNSR0IArs4c6QAAAAZQTFRF
 AJnV/f/88sgWwwAAAKNJREFUGNM10LENwyAQheFHKCgZgTVSRHI2gy5reROTDSiREvnyHhdXnwXS+
 T+ACJgBYTiGSmDDOTdR7XDeTi9ksxEcoKFcTOCJLO7kC5SWFjPZCR69nI9+x5u6OJM1RN5UYUiNKa
 ZRpHHUoqh1v8hKEZ1FSGCrYOvgVmxd9DIXcSJwLTycm7bj0e4wkJGB48w/FckAwUKl/OGDZAcqItk
 BU+wHXLqKsjYyPeMAAAAASUVORK5CYII=
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Error value got overwritten instantly.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 kernel/printk.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index abbdd9e..6317194 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -608,7 +608,8 @@ static unsigned int devkmsg_poll(struct file *file, poll_table *wait)
 		/* return error when data has vanished underneath us */
 		if (user->seq < log_first_seq)
 			ret = POLLIN|POLLRDNORM|POLLERR|POLLPRI;
-		ret = POLLIN|POLLRDNORM;
+		else
+			ret = POLLIN|POLLRDNORM;
 	}
 	raw_spin_unlock_irq(&logbuf_lock);
 
-- 
1.8.1.2
