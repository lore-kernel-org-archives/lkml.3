Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122AbaLTWl0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 17:41:26 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:51889 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbaLTWlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 17:41:23 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Kirill Tkhai <ktkhai@parallels.com>, Ingo Molnar <mingo@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-cris-kernel@axis.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch: cris: arch-v32: drivers: sync_serial.c:  Remove unused function
Date: Sat, 20 Dec 2014 23:44:10 +0100
Message-Id: <1419115450-12522-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function sync_data_avail_to_end() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/cris/arch-v32/drivers/sync_serial.c |   20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/arch/cris/arch-v32/drivers/sync_serial.c b/arch/cris/arch-v32/drivers/sync_serial.c
index 5a14913..4781514 100644
--- a/arch/cris/arch-v32/drivers/sync_serial.c
+++ b/arch/cris/arch-v32/drivers/sync_serial.c
@@ -409,26 +409,6 @@ static inline int sync_data_avail(struct sync_port *port)
 	return avail;
 }
 
-static inline int sync_data_avail_to_end(struct sync_port *port)
-{
-	int avail;
-	unsigned char *start;
-	unsigned char *end;
-
-	start = (unsigned char*)port->readp; /* cast away volatile */
-	end = (unsigned char*)port->writep;  /* cast away volatile */
-	/* 0123456789  0123456789
-	 *  -----           -----
-	 *  ^rp  ^wp    ^wp ^rp
-	 */
-
-	if (end >= start)
-		avail = end - start;
-	else
-		avail = port->flip + port->in_buffer_size - start;
-	return avail;
-}
-
 static int sync_serial_open(struct inode *inode, struct file *file)
 {
 	int dev = iminor(inode);
-- 
1.7.10.4

