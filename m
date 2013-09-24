Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab3IXVKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 17:10:54 -0400
Received: from smtprelay0016.hostedemail.com ([216.40.44.16]:49017 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754815Ab3IXVKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 17:10:51 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:69:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1542:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:3138:3139:3140:3141:3142:3353:3865:3866:3867:3868:3870:3871:4250:4321:5007:6261:7903:10004:10026:10848:11026:11658:11914:12043:12438:12517:12519:12555:13161:13229:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wrist90_71f98a10be4d
X-Filterd-Recvd-Size: 3533
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Samuel Ortiz <samuel@sortiz.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/10] irda: Remove extern from function prototypes
Date: Tue, 24 Sep 2013 14:10:04 -0700
Message-Id: <294da3abaa73a0b69fd54e442b0b5bd9455b7be6.1380056108.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1380056108.git.joe@perches.com>
References: <cover.1380056108.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a mix of function prototypes with and without extern
in the kernel sources.  Standardize on not using extern for
function prototypes.

Function prototypes don't need to be written with extern.
extern is assumed by the compiler.  Its use is as unnecessary as
using auto to declare automatic/local variables in a block.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/irda/sir-dev.h | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/net/irda/sir-dev.h b/drivers/net/irda/sir-dev.h
index 6d5b1e2..f50b9c1 100644
--- a/drivers/net/irda/sir-dev.h
+++ b/drivers/net/irda/sir-dev.h
@@ -102,28 +102,29 @@ struct sir_driver {
 
 /* exported */
 
-extern int irda_register_dongle(struct dongle_driver *new);
-extern int irda_unregister_dongle(struct dongle_driver *drv);
+int irda_register_dongle(struct dongle_driver *new);
+int irda_unregister_dongle(struct dongle_driver *drv);
 
-extern struct sir_dev * sirdev_get_instance(const struct sir_driver *drv, const char *name);
-extern int sirdev_put_instance(struct sir_dev *self);
+struct sir_dev *sirdev_get_instance(const struct sir_driver *drv,
+				    const char *name);
+int sirdev_put_instance(struct sir_dev *self);
 
-extern int sirdev_set_dongle(struct sir_dev *dev, IRDA_DONGLE type);
-extern void sirdev_write_complete(struct sir_dev *dev);
-extern int sirdev_receive(struct sir_dev *dev, const unsigned char *cp, size_t count);
+int sirdev_set_dongle(struct sir_dev *dev, IRDA_DONGLE type);
+void sirdev_write_complete(struct sir_dev *dev);
+int sirdev_receive(struct sir_dev *dev, const unsigned char *cp, size_t count);
 
 /* low level helpers for SIR device/dongle setup */
-extern int sirdev_raw_write(struct sir_dev *dev, const char *buf, int len);
-extern int sirdev_raw_read(struct sir_dev *dev, char *buf, int len);
-extern int sirdev_set_dtr_rts(struct sir_dev *dev, int dtr, int rts);
+int sirdev_raw_write(struct sir_dev *dev, const char *buf, int len);
+int sirdev_raw_read(struct sir_dev *dev, char *buf, int len);
+int sirdev_set_dtr_rts(struct sir_dev *dev, int dtr, int rts);
 
 /* not exported */
 
-extern int sirdev_get_dongle(struct sir_dev *self, IRDA_DONGLE type);
-extern int sirdev_put_dongle(struct sir_dev *self);
+int sirdev_get_dongle(struct sir_dev *self, IRDA_DONGLE type);
+int sirdev_put_dongle(struct sir_dev *self);
 
-extern void sirdev_enable_rx(struct sir_dev *dev);
-extern int sirdev_schedule_request(struct sir_dev *dev, int state, unsigned param);
+void sirdev_enable_rx(struct sir_dev *dev);
+int sirdev_schedule_request(struct sir_dev *dev, int state, unsigned param);
 
 /* inline helpers */
 
-- 
1.8.1.2.459.gbcd45b4.dirty

