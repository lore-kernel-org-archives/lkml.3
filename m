Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbbAJRI6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 12:08:58 -0500
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:53636 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752686AbbAJRI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 12:08:57 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgsNABNcsVRbtAnC/2dsb2JhbABbgwaBKrM5BQEBAQEBAQUBd5c6gQpEAQEBAQF9hGkjgRo3iDABvBONcIYFiRBkHYQTBZdHgQ+KTYYbIoFFAYIpPTGBA4FAAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 1/1 linux-next] tty: remove unused variable sprop
Date: Sat, 10 Jan 2015 18:08:51 +0100
Message-Id: <1420909731-31577-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sprop is unused in find_console_handle() since commit a752ee56ad84
("tty: Update hypervisor tty drivers to use core stdout parsing code.")

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/tty/ehv_bytechan.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/tty/ehv_bytechan.c b/drivers/tty/ehv_bytechan.c
index 3c60923..342b36b 100644
--- a/drivers/tty/ehv_bytechan.c
+++ b/drivers/tty/ehv_bytechan.c
@@ -112,7 +112,6 @@ static void disable_tx_interrupt(struct ehv_bc_data *bc)
 static int find_console_handle(void)
 {
 	struct device_node *np = of_stdout;
-	const char *sprop = NULL;
 	const uint32_t *iprop;
 
 	/* We don't care what the aliased node is actually called.  We only
-- 
2.1.0

