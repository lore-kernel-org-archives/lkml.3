Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbaHDNBO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 09:01:14 -0400
Received: from smtprelay06.ispgateway.de ([80.67.31.103]:49407 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbaHDNBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 09:01:12 -0400
From: Christoph Jaeger <email@christophjaeger.info>
To: shigekatsu.tateno@atmel.com, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Christoph Jaeger <email@christophjaeger.info>
Subject: [PATCH 01/10] staging: ozwpan: Add module parameter description
Date: Mon,  4 Aug 2014 14:54:47 +0200
Message-Id: <1407156896-3246-2-git-send-email-email@christophjaeger.info>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407156896-3246-1-git-send-email-email@christophjaeger.info>
References: <1407156896-3246-1-git-send-email-email@christophjaeger.info>
X-Df-Sender: MTg4NDM4Mw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Jaeger <email@christophjaeger.info>
---
 drivers/staging/ozwpan/ozmain.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/ozwpan/ozmain.c b/drivers/staging/ozwpan/ozmain.c
index d1a5b7a..7d6ef4c 100644
--- a/drivers/staging/ozwpan/ozmain.c
+++ b/drivers/staging/ozwpan/ozmain.c
@@ -25,6 +25,9 @@ unsigned int oz_dbg_mask = OZ_DEFAULT_DBG_MASK;
  * netcards. Bindings can be added later using an IOCTL.
  */
 static char *g_net_dev = "";
+module_param(g_net_dev, charp, S_IRUGO);
+MODULE_PARM_DESC(g_net_dev, "The device(s) to bind to; "
+	"'*' means all, '' (empty string; default) means none.");
 
 /*
  * Context: process
@@ -48,7 +51,6 @@ static void __exit ozwpan_exit(void)
 	oz_cdev_deregister();
 }
 
-module_param(g_net_dev, charp, S_IRUGO);
 module_init(ozwpan_init);
 module_exit(ozwpan_exit);
 
-- 
1.9.1

