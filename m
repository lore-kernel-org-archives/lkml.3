Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab3AYXQD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 18:16:03 -0500
Received: from mout.gmx.net ([212.227.15.18]:52244 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164Ab3AYXQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 18:16:01 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX199MDtTGod9kJkNIO/1XaqUTNbuNS5XV2DjP5YTU8
	RRQerTlsJvGoga
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Devendra Naga <devendra.aaru@gmail.com>, Priit Laes <plaes@plaes.org>,
        Peter Huewe <peterhuewe@gmx.de>, Jesper Juhl <jj@chaosbits.net>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging/csr: Use kmemdup rather than duplicating its implementation
Date: Sat, 26 Jan 2013 00:19:19 +0100
Message-Id: <1359155959-3938-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found with coccicheck.
The semantic patch that makes this change is available
in scripts/coccinelle/api/memdup.cocci.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/csr/drv.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/csr/drv.c b/drivers/staging/csr/drv.c
index 4780c32..3bd52fd 100644
--- a/drivers/staging/csr/drv.c
+++ b/drivers/staging/csr/drv.c
@@ -819,15 +819,15 @@ unifi_write(struct file *filp, const char *p, size_t len, loff_t *poff)
         unifi_trace(priv, UDBG2, "unifi_write: signal 0x%.4X len:%d\n",
                     sig_id, signal_size);
 
-        /* Allocate a buffer for the signal */
-        signal_buf = kmalloc(signal_size, GFP_KERNEL);
+	/* Allocate a buffer for the signal */
+	signal_buf = kmemdup(bulkdata.d[0].os_data_ptr, signal_size,
+				GFP_KERNEL);
         if (!signal_buf) {
             unifi_net_data_free(priv, &bulkdata.d[0]);
             return -ENOMEM;
         }
 
         /* Get the signal from the os_data_ptr */
-        memcpy(signal_buf, bulkdata.d[0].os_data_ptr, signal_size);
         signal_buf[5] = (pcli->sender_id >> 8) & 0xff;
 
         if (signal_size < len) {
-- 
1.7.8.6

