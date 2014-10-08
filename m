Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083AbaJHLOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 07:14:47 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:45964 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192AbaJHLOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 07:14:46 -0400
Date: Wed, 8 Oct 2014 20:12:48 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, markh@compro.net
Cc: markh@compro.net, daeseok.youn@gmail.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com
Subject: [PATCH 1/3] staging: dgap: remove unnecessary if statement for
 checking NULL
Message-ID: <20141008111248.GA21995@devel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dgap_release_remap() function is only called after the memory
has been remapped so if statement for checking NULL doesn't
need.

And also release_mem_region() calls are moved after iounmap() calls.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index d0be1ce..a48740f 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -1013,15 +1013,10 @@ static int dgap_do_remap(struct board_t *brd)
 
 static void dgap_release_remap(struct board_t *brd)
 {
-	if (brd->re_map_membase) {
-		release_mem_region(brd->membase, 0x200000);
-		iounmap(brd->re_map_membase);
-	}
-
-	if (brd->re_map_port) {
-		release_mem_region(brd->membase + PCI_IO_OFFSET, 0x200000);
-		iounmap(brd->re_map_port);
-	}
+	iounmap(brd->re_map_port);
+	iounmap(brd->re_map_membase);
+	release_mem_region(brd->membase + PCI_IO_OFFSET, 0x200000);
+	release_mem_region(brd->membase, 0x200000);
 }
 /*****************************************************************************
 *
-- 
1.7.1

