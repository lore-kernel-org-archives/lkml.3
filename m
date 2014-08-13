Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbaHMJRV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 05:17:21 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:54912 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbaHMJRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 05:17:19 -0400
Date: Wed, 13 Aug 2014 14:47:13 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Simon Kelley <simon@thekelleys.org.uk>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] drivers/net/wireless: Remove typedef local_info_t
Message-ID: <20140813091713.GA2995@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Linux kernel coding style guidelines suggest not using typedefs
for structure types. This patch gets rid of the typedef for
local_info_t. Also, the name of the struct is changed to drop the _t,
to make the name look less typedef-like.

The following Coccinelle semantic patch detects the case:

@tn@
identifier i;
type td;
@@

-typedef
 struct i { ... }
-td
 ;

@@
type tn.td;
identifier tn.i;
@@

-td
+ struct i

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/net/wireless/atmel_cs.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/atmel_cs.c b/drivers/net/wireless/atmel_cs.c
index 4cfb4d9..7afc9c5 100644
--- a/drivers/net/wireless/atmel_cs.c
+++ b/drivers/net/wireless/atmel_cs.c
@@ -66,18 +66,18 @@ static void atmel_release(struct pcmcia_device *link);
 
 static void atmel_detach(struct pcmcia_device *p_dev);
 
-typedef struct local_info_t {
+struct local_info {
 	struct net_device *eth_dev;
-} local_info_t;
+};
 
 static int atmel_probe(struct pcmcia_device *p_dev)
 {
-	local_info_t *local;
+	struct local_info *local;
 
 	dev_dbg(&p_dev->dev, "atmel_attach()\n");
 
 	/* Allocate space for private device-specific data */
-	local = kzalloc(sizeof(local_info_t), GFP_KERNEL);
+	local = kzalloc(sizeof(*local), GFP_KERNEL);
 	if (!local)
 		return -ENOMEM;
 
@@ -117,7 +117,7 @@ static int atmel_config_check(struct pcmcia_device *p_dev, void *priv_data)
 
 static int atmel_config(struct pcmcia_device *link)
 {
-	local_info_t *dev;
+	struct local_info *dev;
 	int ret;
 	const struct pcmcia_device_id *did;
 
@@ -141,14 +141,14 @@ static int atmel_config(struct pcmcia_device *link)
 	if (ret)
 		goto failed;
 
-	((local_info_t*)link->priv)->eth_dev =
+	((struct local_info *)link->priv)->eth_dev =
 		init_atmel_card(link->irq,
 				link->resource[0]->start,
 				did ? did->driver_info : ATMEL_FW_TYPE_NONE,
 				&link->dev,
 				card_present,
 				link);
-	if (!((local_info_t*)link->priv)->eth_dev)
+	if (!((struct local_info *)link->priv)->eth_dev)
 			goto failed;
 
 
@@ -161,20 +161,20 @@ static int atmel_config(struct pcmcia_device *link)
 
 static void atmel_release(struct pcmcia_device *link)
 {
-	struct net_device *dev = ((local_info_t*)link->priv)->eth_dev;
+	struct net_device *dev = ((struct local_info *)link->priv)->eth_dev;
 
 	dev_dbg(&link->dev, "atmel_release\n");
 
 	if (dev)
 		stop_atmel_card(dev);
-	((local_info_t*)link->priv)->eth_dev = NULL;
+	((struct local_info *)link->priv)->eth_dev = NULL;
 
 	pcmcia_disable_device(link);
 }
 
 static int atmel_suspend(struct pcmcia_device *link)
 {
-	local_info_t *local = link->priv;
+	struct local_info *local = link->priv;
 
 	netif_device_detach(local->eth_dev);
 
@@ -183,7 +183,7 @@ static int atmel_suspend(struct pcmcia_device *link)
 
 static int atmel_resume(struct pcmcia_device *link)
 {
-	local_info_t *local = link->priv;
+	struct local_info *local = link->priv;
 
 	atmel_open(local->eth_dev);
 	netif_device_attach(local->eth_dev);
-- 
1.9.1

