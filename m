Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab3LSPFH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:05:07 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:45441 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310Ab3LSPFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:05:04 -0500
From: Levente Kurusa <levex@linux.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Levente Kurusa <levex@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Christian Lamparter <chunkeey@googlemail.com>,
        linux-pcmcia@lists.infradead.org
Subject: [PATCH 24/38] pcmcia: add missing put_device call
Date: Thu, 19 Dec 2013 16:03:35 +0100
Message-Id: <1387465429-3568-25-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387465429-3568-2-git-send-email-levex@linux.com>
References: <1387465429-3568-2-git-send-email-levex@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required so that we give up the last reference to the device.

Signed-off-by: Levente Kurusa <levex@linux.com>
---
 drivers/pcmcia/cs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pcmcia/cs.c b/drivers/pcmcia/cs.c
index 5292db6..5057de9 100644
--- a/drivers/pcmcia/cs.c
+++ b/drivers/pcmcia/cs.c
@@ -607,6 +607,7 @@ static int pccardd(void *__skt)
 	if (ret) {
 		dev_printk(KERN_WARNING, &skt->dev,
 			   "PCMCIA: unable to register socket\n");
+		put_device(&skt->dev);
 		skt->thread = NULL;
 		complete(&skt->thread_done);
 		return 0;
-- 
1.8.3.1

