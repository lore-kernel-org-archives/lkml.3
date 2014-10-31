Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760199AbaJaVtD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 17:49:03 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:15618 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754839AbaJaVtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 17:49:00 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvgNAKkCVFRXQwLV/2dsb2JhbABcgw6BLLlrBQF0mhoCgRgXAQEBAQF9hAMBBVYjEFE5HhmIRQG8PI5oAQEBAQYihjeKWQcWhDUFnXiWSIN5PC+CSwEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 6/8] cdrom: use bool for true/false initialized variable
Date: Fri, 31 Oct 2014 22:48:02 +0100
Message-Id: <1414792084-7739-7-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1414792084-7739-1-git-send-email-fabf@skynet.be>
References: <1414792084-7739-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/cdrom/cdrom.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index a4dd382..a1a26d5 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -3678,9 +3678,9 @@ static struct ctl_table_header *cdrom_sysctl_header;
 
 static void cdrom_sysctl_register(void)
 {
-	static int initialized;
+	static bool initialized;
 
-	if (initialized == 1)
+	if (initialized)
 		return;
 
 	cdrom_sysctl_header = register_sysctl_table(cdrom_root_table);
@@ -3692,7 +3692,7 @@ static void cdrom_sysctl_register(void)
 	cdrom_sysctl_settings.lock = lockdoor;
 	cdrom_sysctl_settings.check = check_media_type;
 
-	initialized = 1;
+	initialized = true;
 }
 
 static void cdrom_sysctl_unregister(void)
-- 
1.9.3

