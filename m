Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180AbaFPO7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 10:59:54 -0400
Received: from mx-rz-2.rrze.uni-erlangen.de ([131.188.11.21]:58097 "EHLO
	mx-rz-2.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932086AbaFPO7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 10:59:48 -0400
X-RRZE-Submit-IP: 131.188.42.190
From: Stephan Gabert <stephan.gabert@fau.de>
To: pe1dnn@amsat.org, gregkh@linuxfoundation.org
Cc: nicolas.pfeiffer@fau.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-kernel@i4.cs.fau.de,
        Stephan Gabert <stephan.gabert@fau.de>
Subject: [PATCH 3/5] staging/wlags49_h2: correct check of the return value of register_netdev()
Date: Mon, 16 Jun 2014 16:50:51 +0200
Message-Id: <1402930253-32537-4-git-send-email-stephan.gabert@fau.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402930253-32537-1-git-send-email-stephan.gabert@fau.de>
References: <1402930253-32537-1-git-send-email-stephan.gabert@fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As mentioned in net/core/dev.c register_netdev() explicitly returns a
negative errno code on failure.

So in case of failure, one should rather test whether ret is negative
than just unlike 0.

Signed-off-by: Stephan Gabert <stephan.gabert@fau.de>
Signed-off-by: Nicolas Pfeiffer <nicolas.pfeiffer@fau.de>
---
 drivers/staging/wlags49_h2/wl_cs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wlags49_h2/wl_cs.c b/drivers/staging/wlags49_h2/wl_cs.c
index c79f1ed..764f547 100644
--- a/drivers/staging/wlags49_h2/wl_cs.c
+++ b/drivers/staging/wlags49_h2/wl_cs.c
@@ -232,7 +232,7 @@ int wl_adapter_insert(struct pcmcia_device *link)
 
 	SET_NETDEV_DEV(dev, &link->dev);
 	ret = register_netdev(dev);
-	if (ret != 0) {
+	if (ret < 0) {
 		printk("%s: register_netdev() failed\n", KBUILD_MODNAME);
 		goto failed;
 	}
-- 
1.9.1

