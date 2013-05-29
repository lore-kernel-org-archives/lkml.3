Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967099Ab3E2VKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 17:10:23 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:21242 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967033Ab3E2VKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 17:10:14 -0400
Date: Thu, 30 May 2013 00:09:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        "open list:LED SUBSYSTEM" <linux-leds@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: [patch v2] leds: renesas-tpu: cleanup a small type issue
Message-ID: <20130529210955.GJ23987@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK5ve-Jyb8xfyiy=iM_bLSF-uofQ9r8uNmuBryLVujKVJ-SALQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Static checkers complain that, although this is declared as an
unsigned long, we can only use the lower 32 bits.  For anything
higher, we hit bugs widening then bitwise negate or wrapping bugs
doing the left shift.

>From looking at the context, this is not a problem because we only
use 16 bits.  I've changed some types to make it more clear.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: Changed unsigned short to u16.  Re-wrote the commit message.

diff --git a/drivers/leds/leds-renesas-tpu.c b/drivers/leds/leds-renesas-tpu.c
index 9483f1c..adebf49 100644
--- a/drivers/leds/leds-renesas-tpu.c
+++ b/drivers/leds/leds-renesas-tpu.c
@@ -63,7 +63,7 @@ static DEFINE_SPINLOCK(r_tpu_lock);
 #define TGRC 8 /* Timer general register C (+0x20) */
 #define TGRD 9 /* Timer general register D (+0x24) */
 
-static inline unsigned short r_tpu_read(struct r_tpu_priv *p, int reg_nr)
+static inline u16 r_tpu_read(struct r_tpu_priv *p, int reg_nr)
 {
 	struct led_renesas_tpu_config *cfg = p->pdev->dev.platform_data;
 	void __iomem *base = p->mapbase;
@@ -75,8 +75,7 @@ static inline unsigned short r_tpu_read(struct r_tpu_priv *p, int reg_nr)
 	return ioread16(base + offs);
 }
 
-static inline void r_tpu_write(struct r_tpu_priv *p, int reg_nr,
-			       unsigned short value)
+static inline void r_tpu_write(struct r_tpu_priv *p, int reg_nr, u16 value)
 {
 	struct led_renesas_tpu_config *cfg = p->pdev->dev.platform_data;
 	void __iomem *base = p->mapbase;
@@ -93,7 +92,8 @@ static inline void r_tpu_write(struct r_tpu_priv *p, int reg_nr,
 static void r_tpu_start_stop_ch(struct r_tpu_priv *p, int start)
 {
 	struct led_renesas_tpu_config *cfg = p->pdev->dev.platform_data;
-	unsigned long flags, value;
+	unsigned long flags;
+	u16 value;
 
 	/* start stop register shared by multiple timer channels */
 	spin_lock_irqsave(&r_tpu_lock, flags);
