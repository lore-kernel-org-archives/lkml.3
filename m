Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574Ab3B1XF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 18:05:29 -0500
Received: from longford.logfs.org ([213.229.74.203]:58575 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352Ab3B1XF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 18:05:26 -0500
From: Joern Engel <joern@logfs.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@alien8.de>,
        Jeff Moyer <jmoyer@redhat.com>, Joern Engel <joern@logfs.org>
Subject: [PATCH 4/9] netconsole: use CON_ALLDATA
Date: Thu, 28 Feb 2013 16:39:57 -0500
Message-Id: <1362087602-8979-5-git-send-email-joern@logfs.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1362087602-8979-1-git-send-email-joern@logfs.org>
References: <1362087602-8979-1-git-send-email-joern@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Netconsole should really see every message ever printed.  The
alternative is to try debugging with information like this:
[166135.633974] Stack:
[166135.634016] Call Trace:
[166135.634029]  <IRQ>
[166135.634156]  <EOI>
[166135.634177] Code: 00 00 55 48 89 e5 0f 1f 44 00 00 ff 15 31 49 80 00 c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 0f 1f 44 00 00
[166135.634384]  48 8b 14 25 98 24 01 00 48 8d 14 92 48 8d 04 bd 00 00 00 00

Signed-off-by: Joern Engel <joern@logfs.org>
---
 drivers/net/netconsole.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index 6989ebe..77783fe 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -718,7 +718,7 @@ static void write_msg(struct console *con, const char *msg, unsigned int len)
 
 static struct console netconsole = {
 	.name	= "netcon",
-	.flags	= CON_ENABLED,
+	.flags	= CON_ENABLED | CON_ALLDATA,
 	.write	= write_msg,
 };
 
-- 
1.7.10.4

