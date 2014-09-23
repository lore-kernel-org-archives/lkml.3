Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbaIWAX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 20:23:59 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:62340 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbaIWAX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 20:23:58 -0400
Date: Tue, 23 Sep 2014 09:22:08 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, markh@compro.net
Cc: markh@compro.net, daeseok.youn@gmail.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] staging: dgap: adds missing iounmap for re_map_port in
 dgap_release_remap()
Message-ID: <20140923002208.GA20768@devel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 779d144..637ea8a 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -1026,6 +1026,7 @@ static void dgap_release_remap(struct board_t *brd)
 	release_mem_region(brd->membase, 0x200000);
 	release_mem_region(brd->membase + PCI_IO_OFFSET, 0x200000);
 	iounmap(brd->re_map_membase);
+	iounmap(brd->re_map_port);
 }
 /*****************************************************************************
 *
-- 
1.7.1

