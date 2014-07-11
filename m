Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063AbaGKKXV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 06:23:21 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:44515 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbaGKKXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 06:23:18 -0400
Date: Fri, 11 Jul 2014 19:22:04 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com
Cc: markh@compro.net, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/9] staging: dgap: redundant NULL and magic check in
 dgap_get_modem_info()
Message-ID: <20140711102204.GA22311@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "ch" is already checking in caller.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 9affc5b..79ea116 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -3061,9 +3061,6 @@ static int dgap_get_modem_info(struct channel_t *ch, unsigned int __user *value)
 	ulong lock_flags;
 	int rc;
 
-	if (!ch || ch->magic != DGAP_CHANNEL_MAGIC)
-		return -EIO;
-
 	spin_lock_irqsave(&ch->ch_lock, lock_flags);
 
 	mstat = readb(&(ch->ch_bs->m_stat));
-- 
1.7.1

