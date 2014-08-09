Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbaHIQWa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 12:22:30 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:38000 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbaHIQW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 12:22:27 -0400
Date: Sat, 9 Aug 2014 21:52:20 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Simon Kelley <simon@thekelleys.org.uk>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] atmel: Remove typedef atmel_priv_ioctl
Message-ID: <20140809162220.GA18091@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Linux kernel coding style guidelines suggest not using typedefs
for structure types. This patch gets rid of the typedef for
atmel_priv_ioctl. 

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
 drivers/net/wireless/atmel.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/atmel.c b/drivers/net/wireless/atmel.c
index 1fe41af..9183f1c 100644
--- a/drivers/net/wireless/atmel.c
+++ b/drivers/net/wireless/atmel.c
@@ -2598,11 +2598,11 @@ static const iw_handler atmel_private_handler[] =
 	NULL,				/* SIOCIWFIRSTPRIV */
 };
 
-typedef struct atmel_priv_ioctl {
+struct atmel_priv_ioctl {
 	char id[32];
 	unsigned char __user *data;
 	unsigned short len;
-} atmel_priv_ioctl;
+};
 
 #define ATMELFWL	SIOCIWFIRSTPRIV
 #define ATMELIDIFC	ATMELFWL + 1
@@ -2615,7 +2615,7 @@ static const struct iw_priv_args atmel_private_args[] = {
 		.cmd = ATMELFWL,
 		.set_args = IW_PRIV_TYPE_BYTE
 				| IW_PRIV_SIZE_FIXED
-				| sizeof (atmel_priv_ioctl),
+				| sizeof(struct atmel_priv_ioctl),
 		.get_args = IW_PRIV_TYPE_NONE,
 		.name = "atmelfwl"
 	}, {
@@ -2645,7 +2645,7 @@ static int atmel_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 {
 	int i, rc = 0;
 	struct atmel_private *priv = netdev_priv(dev);
-	atmel_priv_ioctl com;
+	struct atmel_priv_ioctl com;
 	struct iwreq *wrq = (struct iwreq *) rq;
 	unsigned char *new_firmware;
 	char domain[REGDOMAINSZ + 1];
-- 
1.9.1

