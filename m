Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338AbaEPPXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:23:38 -0400
Received: from lnfm1.sai.msu.ru ([93.180.26.255]:47640 "EHLO lnfm1.sai.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932760AbaEPPW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:22:58 -0400
X-Greylist: delayed 3818 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 May 2014 11:22:55 EDT
Date: Fri, 16 May 2014 18:19:54 +0400 (MSK)
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
To: balbi@ti.com
cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Add tusb_revision to struct musb to store the
 revision.
Message-ID: <alpine.LRH.2.00.1405161819060.23182@lnfm1.sai.msu.ru>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 0bd8c14855eeb049f49685f36386750a999078a3 Mon Sep 17 00:00:00 2001
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
Date: Fri, 9 May 2014 15:52:00 +0400
Subject: [PATCH 1/2] Add tusb_revision to struct musb to store the revision.

Add field to store tusb6010 revision value. Read the revision at
the startup and store to the variable.

Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>
---
  drivers/usb/musb/musb_core.h | 1 +
  drivers/usb/musb/tusb6010.c  | 1 +
  2 files changed, 2 insertions(+)

diff --git a/drivers/usb/musb/musb_core.h b/drivers/usb/musb/musb_core.h
index 7083e82..d7dea2f 100644
--- a/drivers/usb/musb/musb_core.h
+++ b/drivers/usb/musb/musb_core.h
@@ -337,6 +337,7 @@ struct musb {
  	dma_addr_t		async;
  	dma_addr_t		sync;
  	void __iomem		*sync_va;
+	u8			tusb_revision;
  #endif

  	/* passed down from chip/board specific irq handlers */
diff --git a/drivers/usb/musb/tusb6010.c b/drivers/usb/musb/tusb6010.c
index 4e9fb1d..81fa8fd 100644
--- a/drivers/usb/musb/tusb6010.c
+++ b/drivers/usb/musb/tusb6010.c
@@ -1011,6 +1011,7 @@ static int tusb_musb_start(struct musb *musb)
  		goto err;
  	}

+	musb->tusb_revision = tusb_get_revision(musb);
  	ret = tusb_print_revision(musb);
  	if (ret < 2) {
  		printk(KERN_ERR "tusb: Unsupported TUSB6010 revision %i\n",
-- 
1.8.1.4

