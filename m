Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058Ab3HBNXI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 09:23:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60093 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3HBNXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 09:23:06 -0400
Date: Fri, 2 Aug 2013 15:23:01 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-sh@vger.kernel.org
cc: "Koul, Vinod" <vinod.koul@intel.com>, Magnus Damm <magnus.damm@gmail.com>,
        linux-kernel@vger.kernel.org,
        "Shimoda, Yoshihiro" <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH] DMA: sudmac: fix compiler warning
Message-ID: <Pine.LNX.4.64.1308021520150.28012@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:5rJ7LIJ62YSHwLT+YqsDUzpzy9k7+9iHy8t9B3p4/Mq
 jlGsGfG7Z2JOJzRmtZA56sTgSXkJGG9ijHQl9zb+Hq/IZoZODn
 EgxK0OMHeAkjxYzsICk1pvrrsBNu1Wf0GkWiUDiwMLFr7nf8Ee
 1l9bKnKLcY7rUSk3coKQsLUOaXJDeKgP6jUbzyA3Oqp1GJXS4B
 FnqK9h/xhDKmAw0gBHRgmFj8yJGiUK0MrfGWI9DN860SM1C9jX
 erw0MrP9zMJBqGw27b2tgFAldc0hihwSncB73l7WR3IrjRdMgT
 uXMgbtFENZCa1cT2Z95Isj3kGJ9rTXanm5Ugdvp8AE4PwzoydG
 yJ1UXb6uF3U7H3Qj/q9qa6Q6Z9XURBMFVnxuo06zIDOzlwR5wR
 866A11uwFZdZg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following compiler warning:

drivers/dma/sh/sudmac.c: In function 'sudmac_chan_remove':
drivers/dma/sh/sudmac.c:302: warning: unused variable 'sc'

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---
 drivers/dma/sh/sudmac.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/sh/sudmac.c b/drivers/dma/sh/sudmac.c
index 2a8e3c2..4600b42 100644
--- a/drivers/dma/sh/sudmac.c
+++ b/drivers/dma/sh/sudmac.c
@@ -299,8 +299,6 @@ static void sudmac_chan_remove(struct sudmac_device *su_dev)
 	int i;
 
 	shdma_for_each_chan(schan, &su_dev->shdma_dev, i) {
-		struct sudmac_chan *sc = to_chan(schan);
-
 		BUG_ON(!schan);
 
 		shdma_chan_remove(schan);
-- 
1.7.2.5

