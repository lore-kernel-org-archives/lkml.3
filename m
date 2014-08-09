Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931AbaHIQH1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 12:07:27 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:54501 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbaHIQHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 12:07:24 -0400
Date: Sat, 9 Aug 2014 21:37:18 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] com20020_cs: Remove typedef com20020_dev_t
Message-ID: <20140809160718.GA15251@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Linux kernel coding style guidelines suggest not using typedefs
for structure types. This patch gets rid of the typedef for
com20020_dev_t. Also, the name of the struct is changed to drop the
_t, to make the name look less typedef-like.

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
To send to: netdev@vger.kernel.org,linux-kernel@vger.kernel.org 
 drivers/net/arcnet/com20020_cs.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/arcnet/com20020_cs.c b/drivers/net/arcnet/com20020_cs.c
index 326a612..1a790a2 100644
--- a/drivers/net/arcnet/com20020_cs.c
+++ b/drivers/net/arcnet/com20020_cs.c
@@ -112,20 +112,20 @@ static void com20020_detach(struct pcmcia_device *p_dev);
 
 /*====================================================================*/
 
-typedef struct com20020_dev_t {
+struct com20020_dev {
     struct net_device       *dev;
-} com20020_dev_t;
+};
 
 static int com20020_probe(struct pcmcia_device *p_dev)
 {
-    com20020_dev_t *info;
+    struct com20020_dev *info;
     struct net_device *dev;
     struct arcnet_local *lp;
 
     dev_dbg(&p_dev->dev, "com20020_attach()\n");
 
     /* Create new network device */
-    info = kzalloc(sizeof(struct com20020_dev_t), GFP_KERNEL);
+    info = kzalloc(sizeof(*info), GFP_KERNEL);
     if (!info)
 	goto fail_alloc_info;
 
@@ -160,7 +160,7 @@ fail_alloc_info:
 
 static void com20020_detach(struct pcmcia_device *link)
 {
-    struct com20020_dev_t *info = link->priv;
+    struct com20020_dev *info = link->priv;
     struct net_device *dev = info->dev;
 
     dev_dbg(&link->dev, "detach...\n");
@@ -199,7 +199,7 @@ static void com20020_detach(struct pcmcia_device *link)
 static int com20020_config(struct pcmcia_device *link)
 {
     struct arcnet_local *lp;
-    com20020_dev_t *info;
+    struct com20020_dev *info;
     struct net_device *dev;
     int i, ret;
     int ioaddr;
@@ -291,7 +291,7 @@ static void com20020_release(struct pcmcia_device *link)
 
 static int com20020_suspend(struct pcmcia_device *link)
 {
-	com20020_dev_t *info = link->priv;
+	struct com20020_dev *info = link->priv;
 	struct net_device *dev = info->dev;
 
 	if (link->open)
@@ -302,7 +302,7 @@ static int com20020_suspend(struct pcmcia_device *link)
 
 static int com20020_resume(struct pcmcia_device *link)
 {
-	com20020_dev_t *info = link->priv;
+	struct com20020_dev *info = link->priv;
 	struct net_device *dev = info->dev;
 
 	if (link->open) {
-- 
1.9.1

