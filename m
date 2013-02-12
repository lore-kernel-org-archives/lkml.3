Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759232Ab3BLWlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 17:41:37 -0500
Received: from mail.df.lth.se ([194.47.250.12]:18871 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758850Ab3BLWl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 17:41:29 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4/9] block: xd: some whitespace and #if 0 removal
Date: Tue, 12 Feb 2013 23:40:55 +0100
Message-Id: <1360708860-23466-6-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1360708860-23466-5-git-send-email-linus.walleij@linaro.org>
References: <1360708860-23466-1-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-2-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-3-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-4-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-5-git-send-email-linus.walleij@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Structure some whitespace that I personally found very irritating
when reading the code, like sole tabs on lines and dangling
spaces. (We get very used to our code looking the same these
days.) Also delete a few instances of commenting the obvious
like heads = 12 /* assign number of heads */ and some to git
they will not be fixed down the road either. Made some attempts
to document functions into legal kerneldoc (far from all).

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/block/xd.c | 319 +++++++++++++++++++++++++++++------------------------
 1 file changed, 174 insertions(+), 145 deletions(-)

diff --git a/drivers/block/xd.c b/drivers/block/xd.c
index 549a7fa..18f51e9 100644
--- a/drivers/block/xd.c
+++ b/drivers/block/xd.c
@@ -4,7 +4,7 @@
  *
  * Author: Pat Mackinlay, pat@it.com.au
  * Date: 29/09/92
- * 
+ *
  * Revised: 01/01/93, ...
  *
  * Ref: DTC 5150X Controller Specification (thanks to Kevin Fowler,
@@ -31,6 +31,8 @@
  *
  * Bugfix: 15/02/01, Paul G. - inform queue layer of tiny xd_maxsect.
  *
+ * Revised 12/02/13, Linus Walleij - add delays after outb(), increase
+ *   timeouts, fix whitespace and checkpatch issues.
  */
 
 #include <linux/module.h>
@@ -65,38 +67,54 @@ static void __init do_xd_setup (int *integers);
 static int xd[5] = { -1,-1,-1,-1, };
 #endif
 
-#define XD_DONT_USE_DMA		0  /* Initial value. may be overriden using
-				      "nodma" module option */
-#define XD_INIT_DISK_DELAY	(30)  /* 30 ms delay during disk initialization */
+/* Initial value. may be overriden using "nodma" module option */
+#define XD_DONT_USE_DMA		0
+/* 30 ms delay during disk initialization */
+#define XD_INIT_DISK_DELAY	(30)
 
-/* Above may need to be increased if a problem with the 2nd drive detection
-   (ST11M controller) or resetting a controller (WD) appears */
+/*
+ * Above may need to be increased if a problem with the 2nd drive detection
+ * (ST11M controller) or resetting a controller (WD) appears
+ */
 
 static XD_INFO xd_info[XD_MAXDRIVES];
 
-/* If you try this driver and find that your card is not detected by the driver at bootup, you need to add your BIOS
-   signature and details to the following list of signatures. A BIOS signature is a string embedded into the first
-   few bytes of your controller's on-board ROM BIOS. To find out what yours is, use something like MS-DOS's DEBUG
-   command. Run DEBUG, and then you can examine your BIOS signature with:
-
-	d xxxx:0000
-
-   where xxxx is the segment of your controller (like C800 or D000 or something). On the ASCII dump at the right, you should
-   be able to see a string mentioning the manufacturer's copyright etc. Add this string into the table below. The parameters
-   in the table are, in order:
-
-	offset			; this is the offset (in bytes) from the start of your ROM where the signature starts
-	signature		; this is the actual text of the signature
-	xd_?_init_controller	; this is the controller init routine used by your controller
-	xd_?_init_drive		; this is the drive init routine used by your controller
-
-   The controllers directly supported at the moment are: DTC 5150x, WD 1004A27X, ST11M/R and override. If your controller is
-   made by the same manufacturer as one of these, try using the same init routines as they do. If that doesn't work, your
-   best bet is to use the "override" routines. These routines use a "portable" method of getting the disk's geometry, and
-   may work with your card. If none of these seem to work, try sending me some email and I'll see what I can do <grin>.
-
-   NOTE: You can now specify your XT controller's parameters from the command line in the form xd=TYPE,IRQ,IO,DMA. The driver
-   should be able to detect your drive's geometry from this info. (eg: xd=0,5,0x320,3 is the "standard"). */
+/*
+ * If you try this driver and find that your card is not detected by the
+ * driver at bootup, you need to add your BIOS signature and details to the
+ * following list of signatures. A BIOS signature is a string embedded into
+ * the first few bytes of your controller's on-board ROM BIOS. To find out
+ * what yours is, use something like MS-DOS's DEBUG command. Run DEBUG, and
+ * then you can examine your BIOS signature with:
+ *
+ *	d xxxx:0000
+ *
+ * where xxxx is the segment of your controller (like C800 or D000 or
+ * something). On the ASCII dump at the right, you should be able to see a
+ * string mentioning the manufacturer's copyright etc. Add this string into
+ * the table below. The parameters in the table are, in order:
+ *
+ *	offset			; this is the offset (in bytes) from the
+ *				; start of your ROM where the signature starts
+ *	signature		; this is the actual text of the signature
+ *	xd_?_init_controller	; this is the controller init routine used by
+ *				; your controller
+ *	xd_?_init_drive		; this is the drive init routine used by your
+ *				; controller
+ *
+ * The controllers directly supported at the moment are: DTC 5150x,
+ * WD 1004A27X, ST11M/R and override. If your controller is made by the same
+ * manufacturer as one of these, try using the same init routines as they do.
+ * If that doesn't work, your best bet is to use the "override" routines.
+ * These routines use a "portable" method of getting the disk's geometry, and
+ * may work with your card. If none of these seem to work, try sending me some
+ * email and I'll see what I can do <grin>.
+ *
+ * NOTE: You can now specify your XT controller's parameters from the command
+ * line in the form xd=TYPE,IRQ,IO,DMA. The driver should be able to detect
+ * your drive's geometry from this info. (eg: xd=0,5,0x320,3 is the
+ * "standard").
+ */
 
 #include <asm/page.h>
 #define xd_dma_mem_alloc(size) __get_dma_pages(GFP_KERNEL,get_order(size))
@@ -194,7 +212,7 @@ static int __init xd_init(void)
 		if (controller)
 			xd_sigs[controller].init_controller(address);
 		xd_drives = xd_initdrives(xd_sigs[controller].init_drive);
-		
+
 		printk("Detected %d hard drive%s (using IRQ%d & DMA%d)\n",
 			xd_drives,xd_drives == 1 ? "" : "s",xd_irq,xd_dma);
 	}
@@ -279,7 +297,7 @@ Enomem:
 }
 
 /* xd_detect: scan the possible BIOS ROM locations for the signature strings */
-static u_char __init xd_detect (u_char *controller, unsigned int *address)
+static u_char __init xd_detect(u_char *controller, unsigned int *address)
 {
 	int i, j;
 
@@ -310,7 +328,7 @@ static u_char __init xd_detect (u_char *controller, unsigned int *address)
 }
 
 /* do_xd_request: handle an incoming request */
-static void do_xd_request (struct request_queue * q)
+static void do_xd_request(struct request_queue * q)
 {
 	struct request *req;
 
@@ -356,7 +374,8 @@ static int xd_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 }
 
 /* xd_ioctl: handle device ioctl's */
-static int xd_locked_ioctl(struct block_device *bdev, fmode_t mode, u_int cmd, u_long arg)
+static int xd_locked_ioctl(struct block_device *bdev, fmode_t mode,
+			   u_int cmd, u_long arg)
 {
 	switch (cmd) {
 		case HDIO_SET_DMA:
@@ -385,7 +404,7 @@ static int xd_locked_ioctl(struct block_device *bdev, fmode_t mode, u_int cmd, u
 }
 
 static int xd_ioctl(struct block_device *bdev, fmode_t mode,
-			     unsigned int cmd, unsigned long param)
+		    unsigned int cmd, unsigned long param)
 {
 	int ret;
 
@@ -397,7 +416,8 @@ static int xd_ioctl(struct block_device *bdev, fmode_t mode,
 }
 
 /* xd_readwrite: handle a read/write request */
-static int xd_readwrite (u_char operation,XD_INFO *p,char *buffer,u_int block,u_int count)
+static int xd_readwrite(u_char operation, XD_INFO *p, char *buffer,
+			u_int block, u_int count)
 {
 	int drive = p->unit;
 	u_char cmdblk[6],sense[4];
@@ -405,7 +425,7 @@ static int xd_readwrite (u_char operation,XD_INFO *p,char *buffer,u_int block,u_
 	u_char head,sector,control,mode = PIO_MODE,temp;
 	char **real_buffer;
 	register int i;
-	
+
 #ifdef DEBUG_READWRITE
 	printk("xd_readwrite: operation = %s, drive = %d, buffer = 0x%X, block = %d, count = %d\n",operation == READ ? "read" : "write",drive,buffer,block,count);
 #endif /* DEBUG_READWRITE */
@@ -477,10 +497,10 @@ static int xd_readwrite (u_char operation,XD_INFO *p,char *buffer,u_int block,u_
 }
 
 /* xd_recalibrate: recalibrate a given drive and reset controller if necessary */
-static void xd_recalibrate (u_char drive)
+static void xd_recalibrate(u_char drive)
 {
 	u_char cmdblk[6];
-	
+
 	xd_build(cmdblk,CMD_RECALIBRATE,drive,0,0,0,0,0);
 	if (xd_command(cmdblk,PIO_MODE,NULL,NULL,NULL,XD_TIMEOUT * 8))
 		printk("xd%c: warning! error recalibrating, controller may be unstable\n", 'a'+drive);
@@ -504,10 +524,10 @@ static irqreturn_t xd_interrupt_handler(int irq, void *dev_id)
 }
 
 /* xd_setup_dma: set up the DMA controller for a data transfer */
-static u_char xd_setup_dma (u_char mode,u_char *buffer,u_int count)
+static u_char xd_setup_dma(u_char mode, u_char *buffer, u_int count)
 {
 	unsigned long f;
-	
+
 	if (nodma)
 		return (PIO_MODE);
 	if (((unsigned long) buffer & 0xFFFF0000) != (((unsigned long) buffer + count) & 0xFFFF0000)) {
@@ -516,21 +536,23 @@ static u_char xd_setup_dma (u_char mode,u_char *buffer,u_int count)
 #endif /* DEBUG_OTHER */
 		return (PIO_MODE);
 	}
-	
+
 	f=claim_dma_lock();
 	disable_dma(xd_dma);
 	clear_dma_ff(xd_dma);
 	set_dma_mode(xd_dma,mode);
 	set_dma_addr(xd_dma, (unsigned long) buffer);
 	set_dma_count(xd_dma,count);
-	
+
 	release_dma_lock(f);
 
-	return (DMA_MODE);			/* use DMA and INT */
+	return (DMA_MODE); /* use DMA and INT */
 }
 
 /* xd_build: put stuff into an array in a format suitable for the controller */
-static u_char *xd_build (u_char *cmdblk,u_char command,u_char drive,u_char head,u_short cylinder,u_char sector,u_char count,u_char control)
+static u_char *xd_build(u_char *cmdblk, u_char command, u_char drive,
+			u_char head, u_short cylinder, u_char sector,
+			u_char count, u_char control)
 {
 	cmdblk[0] = command;
 	cmdblk[1] = ((drive & 0x07) << 5) | (head & 0x1F);
@@ -538,18 +560,19 @@ static u_char *xd_build (u_char *cmdblk,u_char command,u_char drive,u_char head,
 	cmdblk[3] = cylinder & 0xFF;
 	cmdblk[4] = count;
 	cmdblk[5] = control;
-	
+
 	return (cmdblk);
 }
 
-static void xd_watchdog (unsigned long unused)
+static void xd_watchdog(unsigned long unused)
 {
 	xd_error = 1;
 	wake_up(&xd_wait_int);
 }
 
 /* xd_waitport: waits until port & mask == flags or a timeout occurs. return 1 for a timeout */
-static inline u_char xd_waitport (u_short port,u_char flags,u_char mask,u_long timeout)
+static inline u_char xd_waitport(u_short port, u_char flags,
+				 u_char mask, u_long timeout)
 {
 	u_long expiry = jiffies + timeout;
 	int success;
@@ -561,24 +584,24 @@ static inline u_char xd_waitport (u_short port,u_char flags,u_char mask,u_long t
 	return (success);
 }
 
-static inline u_int xd_wait_for_IRQ (void)
+static inline u_int xd_wait_for_IRQ(void)
 {
 	unsigned long flags;
 	xd_watchdog_int.expires = jiffies + 30 * HZ;
 	add_timer(&xd_watchdog_int);
-	
+
 	flags=claim_dma_lock();
 	enable_dma(xd_dma);
 	release_dma_lock(flags);
-	
+
 	sleep_on(&xd_wait_int);
 	del_timer(&xd_watchdog_int);
 	xdc_busy = 0;
-	
+
 	flags=claim_dma_lock();
 	disable_dma(xd_dma);
 	release_dma_lock(flags);
-	
+
 	if (xd_error) {
 		printk("xd: missed IRQ - command aborted\n");
 		xd_error = 0;
@@ -588,9 +611,10 @@ static inline u_int xd_wait_for_IRQ (void)
 }
 
 /* xd_command: handle all data transfers necessary for a single command */
-static u_int xd_command (u_char *command,u_char mode,u_char *indata,u_char *outdata,u_char *sense,u_long timeout)
+static u_int xd_command(u_char *command, u_char mode, u_char *indata,
+			u_char *outdata, u_char *sense, u_long timeout)
 {
-	u_char cmdblk[6],csb,complete = 0;
+	u_char cmdblk[6], csb, complete = 0;
 
 #ifdef DEBUG_COMMAND
 	printk("xd_command: command = 0x%X, mode = 0x%X, indata = 0x%X, outdata = 0x%X, sense = 0x%X\n",command,mode,indata,outdata,sense);
@@ -655,9 +679,9 @@ static u_int xd_command (u_char *command,u_char mode,u_char *indata,u_char *outd
 	return (csb & CSB_ERROR);
 }
 
-static u_char __init xd_initdrives (void (*init_drive)(u_char drive))
+static u_char __init xd_initdrives(void (*init_drive)(u_char drive))
 {
-	u_char cmdblk[6],i,count = 0;
+	u_char cmdblk[6], i, count = 0;
 
 	for (i = 0; i < XD_MAXDRIVES; i++) {
 		xd_build(cmdblk,CMD_TESTREADY,i,0,0,0,0,0);
@@ -673,19 +697,19 @@ static u_char __init xd_initdrives (void (*init_drive)(u_char drive))
 	return (count);
 }
 
-static void __init xd_manual_geo_set (u_char drive)
+static void __init xd_manual_geo_set(u_char drive)
 {
 	xd_info[drive].heads = (u_char)(xd_geo[3 * drive + 1]);
 	xd_info[drive].cylinders = (u_short)(xd_geo[3 * drive]);
 	xd_info[drive].sectors = (u_char)(xd_geo[3 * drive + 2]);
 }
 
-static void __init xd_dtc_init_controller (unsigned int address)
+static void __init xd_dtc_init_controller(unsigned int address)
 {
 	switch (address) {
 		case 0x00000:
 		case 0xC8000:	break;			/*initial: 0x320 */
-		case 0xCA000:	xd_iobase = 0x324; 
+		case 0xCA000:	xd_iobase = 0x324;
 		case 0xD0000:				/*5150CX*/
 		case 0xD8000:	break;			/*5150CX & 5150XL*/
 		default:        printk("xd_dtc_init_controller: unsupported BIOS address %06x\n",address);
@@ -698,7 +722,7 @@ static void __init xd_dtc_init_controller (unsigned int address)
 }
 
 
-static void __init xd_dtc5150cx_init_drive (u_char drive)
+static void __init xd_dtc5150cx_init_drive(u_char drive)
 {
 	/* values from controller's BIOS - BIOS chip may be removed */
 	static u_short geometry_table[][4] = {
@@ -726,7 +750,7 @@ static void __init xd_dtc5150cx_init_drive (u_char drive)
 	if (xd_geo[3*drive])
 		xd_manual_geo_set(drive);
 	else
-		if (n != 7) {	
+		if (n != 7) {
 			xd_info[drive].heads = (u_char)(geometry_table[n][1]);			/* heads */
 			xd_info[drive].cylinders = geometry_table[n][0];	/* cylinders */
 			xd_info[drive].sectors = 17;				/* sectors */
@@ -745,7 +769,7 @@ static void __init xd_dtc5150cx_init_drive (u_char drive)
 	xd_recalibrate(drive);
 }
 
-static void __init xd_dtc_init_drive (u_char drive)
+static void __init xd_dtc_init_drive(u_char drive)
 {
 	u_char cmdblk[6],buf[64];
 
@@ -772,11 +796,11 @@ static void __init xd_dtc_init_drive (u_char drive)
 		printk("xd_dtc_init_drive: error reading geometry for xd%c\n", 'a'+drive);
 }
 
-static void __init xd_wd_init_controller (unsigned int address)
+static void __init xd_wd_init_controller(unsigned int address)
 {
 	switch (address) {
 		case 0x00000:
-		case 0xC8000:	break;			/*initial: 0x320 */
+		case 0xC8000:	break; /*initial: 0x320 */
 		case 0xCA000:	xd_iobase = 0x324; break;
 		case 0xCC000:   xd_iobase = 0x328; break;
 		case 0xCE000:   xd_iobase = 0x32C; break;
@@ -785,15 +809,16 @@ static void __init xd_wd_init_controller (unsigned int address)
 		default:        printk("xd_wd_init_controller: unsupported BIOS address %06x\n",address);
 				break;
 	}
-	xd_maxsectors = 0x01;		/* this one doesn't wrap properly either... */
+	/* this one doesn't wrap properly either... */
+	xd_maxsectors = 0x01;
 
-	outb(0,XD_RESET);		/* reset the controller */
+	outb(0,XD_RESET);
 	udelay(OUTB_DELAY);
 
 	msleep(XD_INIT_DISK_DELAY);
 }
 
-static void __init xd_wd_init_drive (u_char drive)
+static void __init xd_wd_init_drive(u_char drive)
 {
 	/* values from controller's BIOS - BIOS may be disabled */
 	static u_short geometry_table[][4] = {
@@ -815,24 +840,20 @@ static void __init xd_wd_init_drive (u_char drive)
 	u_char cmdblk[6],buf[0x200];
 	u_char n = 0,rll,jumper_state,use_jumper_geo;
 	u_char wd_1002 = (xd_sigs[xd_type].string[7] == '6');
-	
+
 	jumper_state = ~(inb(0x322));
 	if (jumper_state & 0x40)
 		xd_irq = 9;
 	rll = (jumper_state & 0x30) ? (0x04 << wd_1002) : 0;
 	xd_build(cmdblk,CMD_READ,drive,0,0,0,1,0);
 	if (!xd_command(cmdblk,PIO_MODE,buf,NULL,NULL,XD_TIMEOUT * 2)) {
-		xd_info[drive].heads = buf[0x1AF];				/* heads */
-		xd_info[drive].cylinders = ((u_short *) (buf + 1))[0xD6];	/* cylinders */
-		xd_info[drive].sectors = 17;					/* sectors */
+		xd_info[drive].heads = buf[0x1AF];
+		xd_info[drive].cylinders = ((u_short *) (buf + 1))[0xD6];
+		xd_info[drive].sectors = 17;
 		if (xd_geo[3*drive])
 			xd_manual_geo_set(drive);
-#if 0
-		xd_info[drive].rwrite = ((u_short *) (buf))[0xD8];		/* reduced write */
-		xd_info[drive].wprecomp = ((u_short *) (buf))[0xDA];		/* write precomp */
-		xd_info[drive].ecc = buf[0x1B4];				/* ecc length */
-#endif /* 0 */
-		xd_info[drive].control = buf[0x1B5];				/* control byte */
+		/* control byte */
+		xd_info[drive].control = buf[0x1B5];
 		use_jumper_geo = !(xd_info[drive].heads) || !(xd_info[drive].cylinders);
 		if (xd_geo[3*drive]) {
 			xd_manual_geo_set(drive);
@@ -843,11 +864,6 @@ static void __init xd_wd_init_drive (u_char drive)
 			xd_info[drive].cylinders = geometry_table[n][0];
 			xd_info[drive].heads = (u_char)(geometry_table[n][1]);
 			xd_info[drive].control = rll ? 7 : 5;
-#if 0
-			xd_info[drive].rwrite = geometry_table[n][2];
-			xd_info[drive].wprecomp = geometry_table[n][3];
-			xd_info[drive].ecc = 0x0B;
-#endif /* 0 */
 		}
 		if (!wd_1002) {
 			if (use_jumper_geo)
@@ -857,24 +873,19 @@ static void __init xd_wd_init_drive (u_char drive)
 				xd_setparam(CMD_WDSETPARAM,drive,xd_info[drive].heads,xd_info[drive].cylinders,
 					((u_short *) (buf))[0xD8],((u_short *) (buf))[0xDA],buf[0x1B4]);
 		}
-	/* 1002 based RLL controller requests converted addressing, but reports physical 
-	   (physical 26 sec., logical 17 sec.) 
-	   1004 based ???? */
+		/*
+		 * 1002 based RLL controller requests converted addressing,
+		 * but reports physical (physical 26 sec., logical 17 sec.)
+		 * 1004 based ????
+		 */
 		if (rll & wd_1002) {
 			if ((xd_info[drive].cylinders *= 26,
 			     xd_info[drive].cylinders /= 17) > 1023)
 				xd_info[drive].cylinders = 1023;  /* 1024 ? */
-#if 0
-			xd_info[drive].rwrite *= 26; 
-			xd_info[drive].rwrite /= 17;
-			xd_info[drive].wprecomp *= 26
-			xd_info[drive].wprecomp /= 17;
-#endif /* 0 */
 		}
 	}
 	else
-		printk("xd_wd_init_drive: error reading geometry for xd%c\n",'a'+drive);	
-
+		printk("xd_wd_init_drive: error reading geometry for xd%c\n",'a'+drive);
 }
 
 static void __init xd_seagate_init_controller (unsigned int address)
@@ -890,41 +901,49 @@ static void __init xd_seagate_init_controller (unsigned int address)
 	}
 	xd_maxsectors = 0x40;
 
-	outb(0,XD_RESET);		/* reset the controller */
+	outb(0,XD_RESET);
 	udelay(OUTB_DELAY);
 }
 
-static void __init xd_seagate_init_drive (u_char drive)
+static void __init xd_seagate_init_drive(u_char drive)
 {
 	u_char cmdblk[6],buf[0x200];
 
 	xd_build(cmdblk,CMD_ST11GETGEOM,drive,0,0,0,1,0);
 	if (!xd_command(cmdblk,PIO_MODE,buf,NULL,NULL,XD_TIMEOUT * 2)) {
-		xd_info[drive].heads = buf[0x04];				/* heads */
-		xd_info[drive].cylinders = (buf[0x02] << 8) | buf[0x03];	/* cylinders */
-		xd_info[drive].sectors = buf[0x05];				/* sectors */
-		xd_info[drive].control = 0;					/* control byte */
+		xd_info[drive].heads = buf[0x04];
+		xd_info[drive].cylinders = (buf[0x02] << 8) | buf[0x03];
+		xd_info[drive].sectors = buf[0x05];
+		xd_info[drive].control = 0;
 	}
 	else
 		printk("xd_seagate_init_drive: error reading geometry from xd%c\n", 'a'+drive);
 }
 
 /* Omti support courtesy Dirk Melchers */
-static void __init xd_omti_init_controller (unsigned int address)
+static void __init xd_omti_init_controller(unsigned int address)
 {
 	switch (address) {
 		case 0x00000:
-		case 0xC8000:	break;			/*initial: 0x320 */
-		case 0xD0000:	xd_iobase = 0x324; break;
-		case 0xD8000:	xd_iobase = 0x328; break;
-		case 0xE0000:	xd_iobase = 0x32C; break;
-		default:	printk("xd_omti_init_controller: unsupported BIOS address %06x\n",address);
-				break;
+		case 0xC8000:
+			break; /*initial: 0x320 */
+		case 0xD0000:
+			xd_iobase = 0x324;
+			break;
+		case 0xD8000:
+			xd_iobase = 0x328;
+			break;
+		case 0xE0000:
+			xd_iobase = 0x32C;
+			break;
+		default:
+			printk("xd_omti_init_controller: unsupported BIOS address %06x\n",address);
+			break;
 	}
-	
+
 	xd_maxsectors = 0x40;
 
-	outb(0,XD_RESET);		/* reset the controller */
+	outb(0,XD_RESET);
 	udelay(OUTB_DELAY);
 }
 
@@ -938,15 +957,16 @@ static void __init xd_omti_init_drive (u_char drive)
 }
 
 /* Xebec support (AK) */
-static void __init xd_xebec_init_controller (unsigned int address)
+static void __init xd_xebec_init_controller(unsigned int address)
 {
-/* iobase may be set manually in range 0x300 - 0x33C
-      irq may be set manually to 2(9),3,4,5,6,7
-      dma may be set manually to 1,2,3
-	(How to detect them ???)
-BIOS address may be set manually in range 0x0 - 0xF8000
-If you need non-standard settings use the xd=... command */
-
+/*
+ * iobase may be set manually in range 0x300 - 0x33C
+ *    irq may be set manually to 2(9),3,4,5,6,7
+ *    dma may be set manually to 1,2,3
+ *	(How to detect them ???)
+ * BIOS address may be set manually in range 0x0 - 0xF8000
+ * If you need non-standard settings use the xd=... command
+ */
 	switch (address) {
 		case 0x00000:
 		case 0xC8000:	/* initially: xd_iobase==0x320 */
@@ -958,13 +978,15 @@ If you need non-standard settings use the xd=... command */
 		case 0xDA000:
 		case 0xDC000:
 		case 0xDE000:
-		case 0xE0000:	break;
-		default:	printk("xd_xebec_init_controller: unsupported BIOS address %06x\n",address);
-				break;
+		case 0xE0000:
+			break;
+		default:
+			printk("xd_xebec_init_controller: unsupported BIOS address %06x\n",address);
+			break;
 		}
 
 	xd_maxsectors = 0x01;
-	outb(0,XD_RESET);		/* reset the controller */
+	outb(0,XD_RESET);
 	udelay(OUTB_DELAY);
 
 	msleep(XD_INIT_DISK_DELAY);
@@ -992,31 +1014,30 @@ static void __init xd_xebec_init_drive (u_char drive)
 		{0x33E,7,0x33E,0x200,0x7}};
 	u_char n;
 
-	n = inb(XD_JUMPER) & 0x0F; /* BIOS's drive number: same geometry 
-					is assumed for BOTH drives */
+	/* BIOS's drive number: same geometry is assumed for BOTH drives */
+	n = inb(XD_JUMPER) & 0x0F;
 	if (xd_geo[3*drive])
 		xd_manual_geo_set(drive);
 	else {
-		xd_info[drive].heads = (u_char)(geometry_table[n][1]);			/* heads */
-		xd_info[drive].cylinders = geometry_table[n][0];	/* cylinders */
-		xd_info[drive].sectors = 17;				/* sectors */
-#if 0
-		xd_info[drive].rwrite = geometry_table[n][2];	/* reduced write */
-		xd_info[drive].precomp = geometry_table[n][3]		/* write precomp */
-		xd_info[drive].ecc = 0x0B;				/* ecc length */
-#endif /* 0 */
+		xd_info[drive].heads = (u_char)(geometry_table[n][1]);
+		xd_info[drive].cylinders = geometry_table[n][0];
+		xd_info[drive].sectors = 17;
 	}
-	xd_info[drive].control = geometry_table[n][4];			/* control byte */
+	xd_info[drive].control = geometry_table[n][4];
 	xd_setparam(CMD_XBSETPARAM,drive,xd_info[drive].heads,xd_info[drive].cylinders,geometry_table[n][2],geometry_table[n][3],0x0B);
 	xd_recalibrate(drive);
 }
 
-/* xd_override_init_drive: this finds disk geometry in a "binary search" style, narrowing in on the "correct" number of heads
-   etc. by trying values until it gets the highest successful value. Idea courtesy Salvador Abreu (spa@fct.unl.pt). */
-static void __init xd_override_init_drive (u_char drive)
+/**
+ * xd_override_init_drive() - this finds disk geometry in a "binary search"
+ * style, narrowing in on the "correct" number of heads etc. by trying values
+ * until it gets the highest successful value. Idea courtesy Salvador Abreu
+ * (spa@fct.unl.pt).
+ */
+static void __init xd_override_init_drive(u_char drive)
 {
-	u_short min[] = { 0,0,0 },max[] = { 16,1024,64 },test[] = { 0,0,0 };
-	u_char cmdblk[6],i;
+	u_short min[] = { 0,0,0 }, max[] = { 16,1024,64 }, test[] = { 0,0,0 };
+	u_char cmdblk[6], i;
 
 	if (xd_geo[3*drive])
 		xd_manual_geo_set(drive);
@@ -1039,8 +1060,10 @@ static void __init xd_override_init_drive (u_char drive)
 	xd_info[drive].control = 0;
 }
 
-/* xd_setup: initialise controller from command line parameters */
-static void __init do_xd_setup (int *integers)
+/**
+ * xd_setup() - initialise controller from command line parameters
+ */
+static void __init do_xd_setup(int *integers)
 {
 	switch (integers[0]) {
 		case 4: if (integers[4] < 0)
@@ -1060,8 +1083,12 @@ static void __init do_xd_setup (int *integers)
 	xd_maxsectors = 0x01;
 }
 
-/* xd_setparam: set the drive characteristics */
-static void __init xd_setparam (u_char command,u_char drive,u_char heads,u_short cylinders,u_short rwrite,u_short wprecomp,u_char ecc)
+/**
+ * xd_setparam() - set the drive characteristics
+ */
+static void __init xd_setparam (u_char command, u_char drive, u_char heads,
+				u_short cylinders, u_short rwrite,
+				u_short wprecomp, u_char ecc)
 {
 	u_char cmdblk[14];
 
@@ -1081,7 +1108,6 @@ static void __init xd_setparam (u_char command,u_char drive,u_char heads,u_short
 		printk("xd: error setting characteristics for xd%c\n", 'a'+drive);
 }
 
-
 #ifdef MODULE
 
 module_param_array(xd, int, NULL, 0);
@@ -1107,9 +1133,10 @@ void cleanup_module(void)
 			xd_dma_mem_free((unsigned long)xd_dma_buffer, xd_maxsectors * 0x200);
 	}
 }
+
 #else
 
-static int __init xd_setup (char *str)
+static int __init xd_setup(char *str)
 {
 	int ints[5];
 	get_options (str, ARRAY_SIZE (ints), ints);
@@ -1117,13 +1144,15 @@ static int __init xd_setup (char *str)
 	return 1;
 }
 
-/* xd_manual_geo_init: initialise drive geometry from command line parameters
-   (used only for WD drives) */
+/**
+ * xd_manual_geo_init() - initialise drive geometry from command line
+ * parameters (used only for WD drives)
+ */
 static int __init xd_manual_geo_init (char *str)
 {
 	int i, integers[1 + 3*XD_MAXDRIVES];
 
-	get_options (str, ARRAY_SIZE (integers), integers);
+	get_options (str, ARRAY_SIZE(integers), integers);
 	if (integers[0]%3 != 0) {
 		printk("xd: incorrect number of parameters for xd_geo\n");
 		return 1;
-- 
1.8.1.2

