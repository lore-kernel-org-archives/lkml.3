Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375AbaFMHoA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 03:44:00 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:43791 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaFMHn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 03:43:59 -0400
Date: Fri, 13 Jun 2014 16:43:03 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, gregkh@linuxfoundation.org
Cc: markh@compro.net, dan.carpenter@oracle.com,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/9] staging: dgap: introduce dgap_free_flipbuf()
Message-ID: <20140613074303.GA31627@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dgap_free_flipbuf() will free flipbuf and flipflagbuf which
are allocated in dgap_alloc_flipbuf()

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index db8c93b..c0016bd 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -190,6 +190,7 @@ static void dgap_do_fep_load(struct board_t *brd, const u8 *ufep, int len);
 static void dgap_do_conc_load(struct board_t *brd, u8 *uaddr, int len);
 #endif
 static int dgap_alloc_flipbuf(struct board_t *brd);
+static void dgap_free_flipbuf(struct board_t *brd);
 static int dgap_request_irq(struct board_t *brd);
 static void dgap_free_irq(struct board_t *brd);
 
@@ -4165,6 +4166,12 @@ static int dgap_alloc_flipbuf(struct board_t *brd)
 	return 0;
 }
 
+static void dgap_free_flipbuf(struct board_t *brd)
+{
+	kfree(brd->flipbuf);
+	kfree(brd->flipflagbuf);
+}
+
 /*
  * Create pr and tty device entries
  */
-- 
1.7.1

