Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbaKJUWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 15:22:17 -0500
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:26770 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752233AbaKJUWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 15:22:15 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtsNAMAdYVRXQ4qy/2dsb2JhbABcgw6BLbgoBQF0miwCgScXAQEBAQF9hAMBBVYjEFE5HhmIRQG9HI9/AQEBAQYihjqKWwcWhDUFniWBNIcBjiuDezwvgksBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Joe Perches <joe@perches.com>, Jens Axboe <axboe@kernel.dk>,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH v2 02/10 linux-next] cdrom: use static const char * const where possible
Date: Mon, 10 Nov 2014 21:21:47 +0100
Message-Id: <1415650916-9975-3-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415650916-9975-1-git-send-email-fabf@skynet.be>
References: <1415650916-9975-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both mrw_format_status and mrw_address_space strings are
only read in pr_info.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/cdrom/cdrom.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index c7fa0e2..c311e0d 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -302,14 +302,14 @@ module_param(mrw_format_restart, bool, 0);
 
 static DEFINE_MUTEX(cdrom_mutex);
 
-static const char *mrw_format_status[] = {
+static const char * const mrw_format_status[] = {
 	"not mrw",
 	"bgformat inactive",
 	"bgformat active",
 	"mrw complete",
 };
 
-static const char *mrw_address_space[] = { "DMA", "GAA" };
+static const char * const mrw_address_space[] = { "DMA", "GAA" };
 
 #if (ERRLOGMASK != CD_NOTHING)
 #define cd_dbg(type, fmt, ...)				\
-- 
1.9.1

