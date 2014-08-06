Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbaHFMrb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 08:47:31 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:65285 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbaHFMr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 08:47:29 -0400
Date: Wed, 6 Aug 2014 18:17:25 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] sound: oss: uart401: Remove typedef uart401_devc
Message-ID: <20140806124725.GA7931@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Linux kernel coding style guidelines suggest not using typedefs
for structure types. This patch gets rid of the typedef for uart401_devc.

The following Coccinelle semantic patch detects the case.

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
 sound/oss/uart401.c | 40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/sound/oss/uart401.c b/sound/oss/uart401.c
index 62b8869..279bc56 100644
--- a/sound/oss/uart401.c
+++ b/sound/oss/uart401.c
@@ -30,7 +30,7 @@
 
 #include "mpu401.h"
 
-typedef struct uart401_devc
+struct uart401_devc
 {
 	int             base;
 	int             irq;
@@ -41,14 +41,13 @@ typedef struct uart401_devc
 	int             my_dev;
 	int             share_irq;
 	spinlock_t	lock;
-}
-uart401_devc;
+};
 
 #define	DATAPORT   (devc->base)
 #define	COMDPORT   (devc->base+1)
 #define	STATPORT   (devc->base+1)
 
-static int uart401_status(uart401_devc * devc)
+static int uart401_status(struct uart401_devc *devc)
 {
 	return inb(STATPORT);
 }
@@ -56,17 +55,17 @@ static int uart401_status(uart401_devc * devc)
 #define input_avail(devc) (!(uart401_status(devc)&INPUT_AVAIL))
 #define output_ready(devc)	(!(uart401_status(devc)&OUTPUT_READY))
 
-static void uart401_cmd(uart401_devc * devc, unsigned char cmd)
+static void uart401_cmd(struct uart401_devc *devc, unsigned char cmd)
 {
 	outb((cmd), COMDPORT);
 }
 
-static int uart401_read(uart401_devc * devc)
+static int uart401_read(struct uart401_devc *devc)
 {
 	return inb(DATAPORT);
 }
 
-static void uart401_write(uart401_devc * devc, unsigned char byte)
+static void uart401_write(struct uart401_devc *devc, unsigned char byte)
 {
 	outb((byte), DATAPORT);
 }
@@ -77,10 +76,10 @@ static void uart401_write(uart401_devc * devc, unsigned char byte)
 #define	MPU_RESET	0xFF
 #define	UART_MODE_ON	0x3F
 
-static int      reset_uart401(uart401_devc * devc);
-static void     enter_uart_mode(uart401_devc * devc);
+static int      reset_uart401(struct uart401_devc *devc);
+static void     enter_uart_mode(struct uart401_devc *devc);
 
-static void uart401_input_loop(uart401_devc * devc)
+static void uart401_input_loop(struct uart401_devc *devc)
 {
 	int work_limit=30000;
 	
@@ -99,7 +98,7 @@ static void uart401_input_loop(uart401_devc * devc)
 
 irqreturn_t uart401intr(int irq, void *dev_id)
 {
-	uart401_devc *devc = dev_id;
+	struct uart401_devc *devc = dev_id;
 
 	if (devc == NULL)
 	{
@@ -118,7 +117,8 @@ uart401_open(int dev, int mode,
 	     void            (*output) (int dev)
 )
 {
-	uart401_devc *devc = (uart401_devc *) midi_devs[dev]->devc;
+	struct uart401_devc *devc = (struct uart401_devc *)
+				    midi_devs[dev]->devc;
 
 	if (devc->opened)
 		return -EBUSY;
@@ -138,7 +138,8 @@ uart401_open(int dev, int mode,
 
 static void uart401_close(int dev)
 {
-	uart401_devc *devc = (uart401_devc *) midi_devs[dev]->devc;
+	struct uart401_devc *devc = (struct uart401_devc *)
+				    midi_devs[dev]->devc;
 
 	reset_uart401(devc);
 	devc->opened = 0;
@@ -148,7 +149,8 @@ static int uart401_out(int dev, unsigned char midi_byte)
 {
 	int timeout;
 	unsigned long flags;
-	uart401_devc *devc = (uart401_devc *) midi_devs[dev]->devc;
+	struct uart401_devc *devc = (struct uart401_devc *)
+				    midi_devs[dev]->devc;
 
 	if (devc->disabled)
 		return 1;
@@ -219,7 +221,7 @@ static const struct midi_operations uart401_operations =
 	.buffer_status	= uart401_buffer_status,
 };
 
-static void enter_uart_mode(uart401_devc * devc)
+static void enter_uart_mode(struct uart401_devc *devc)
 {
 	int ok, timeout;
 	unsigned long flags;
@@ -241,7 +243,7 @@ static void enter_uart_mode(uart401_devc * devc)
 	spin_unlock_irqrestore(&devc->lock,flags);
 }
 
-static int reset_uart401(uart401_devc * devc)
+static int reset_uart401(struct uart401_devc *devc)
 {
 	int ok, timeout, n;
 
@@ -285,7 +287,7 @@ static int reset_uart401(uart401_devc * devc)
 
 int probe_uart401(struct address_info *hw_config, struct module *owner)
 {
-	uart401_devc *devc;
+	struct uart401_devc *devc;
 	char *name = "MPU-401 (UART) MIDI";
 	int ok = 0;
 	unsigned long flags;
@@ -300,7 +302,7 @@ int probe_uart401(struct address_info *hw_config, struct module *owner)
 		return 0;
 	}
 
-	devc = kmalloc(sizeof(uart401_devc), GFP_KERNEL);
+	devc = kmalloc(sizeof(struct uart401_devc), GFP_KERNEL);
 	if (!devc) {
 		printk(KERN_WARNING "uart401: Can't allocate memory\n");
 		goto cleanup_region;
@@ -392,7 +394,7 @@ cleanup_region:
 
 void unload_uart401(struct address_info *hw_config)
 {
-	uart401_devc *devc;
+	struct uart401_devc *devc;
 	int n=hw_config->slots[4];
 	
 	/* Not set up */
-- 
1.9.1

