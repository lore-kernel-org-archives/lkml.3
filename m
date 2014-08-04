Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbaHDNCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 09:02:33 -0400
Received: from smtprelay06.ispgateway.de ([80.67.31.104]:47786 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaHDNCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 09:02:32 -0400
From: Christoph Jaeger <email@christophjaeger.info>
To: shigekatsu.tateno@atmel.com, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Christoph Jaeger <email@christophjaeger.info>
Subject: [PATCH 04/10] staging: ozwpan: Remove redundant initialization
Date: Mon,  4 Aug 2014 14:54:50 +0200
Message-Id: <1407156896-3246-5-git-send-email-email@christophjaeger.info>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407156896-3246-1-git-send-email-email@christophjaeger.info>
References: <1407156896-3246-1-git-send-email-email@christophjaeger.info>
X-Df-Sender: MTg4NDM4Mw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Member 'ops' has already been initialized by calling cdev_init().

Signed-off-by: Christoph Jaeger <email@christophjaeger.info>
---
 drivers/staging/ozwpan/ozcdev.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/ozwpan/ozcdev.c b/drivers/staging/ozwpan/ozcdev.c
index 10c0a96..f82e12c 100644
--- a/drivers/staging/ozwpan/ozcdev.c
+++ b/drivers/staging/ozwpan/ozcdev.c
@@ -360,7 +360,6 @@ int oz_cdev_register(void)
 	       MAJOR(g_cdev.devnum), MINOR(g_cdev.devnum));
 	cdev_init(&g_cdev.cdev, &oz_fops);
 	g_cdev.cdev.owner = THIS_MODULE;
-	g_cdev.cdev.ops = &oz_fops;
 	spin_lock_init(&g_cdev.lock);
 	init_waitqueue_head(&g_cdev.rdq);
 	err = cdev_add(&g_cdev.cdev, g_cdev.devnum, 1);
-- 
1.9.1

