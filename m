Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731AbaKJGqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 01:46:42 -0500
Received: from smtprelay0073.hostedemail.com ([216.40.44.73]:42244 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750829AbaKJGqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 01:46:40 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:2:41:69:355:379:541:800:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1535:1593:1594:1605:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:2904:2919:3138:3139:3140:3141:3142:3865:3867:3868:3870:3871:3872:4051:4120:4225:4250:4321:4384:4605:5007:6119:6261:7903:9040:9592:10004:10848:11026:11473:11657:11658:11914:12043:12296:12438:12517:12519:12555:12679:13972:14093:14097:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cable19_9120f6d6e0343
X-Filterd-Recvd-Size: 9736
Message-ID: <1415601995.8868.2.camel@perches.com>
Subject: [PATCH] tty: pr_warning->pr_warn and logging neatening
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-serial@vger.kernel.org
Date: Sun, 09 Nov 2014 22:46:35 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the pr_warning to the more common pr_warn.

Other miscellanea:

o Convert unusual PR_FMT define and uses to pr_fmt
o Remove unnecessary OOM message
o Fix grammar in an error message
o Convert a pr_warning with a KERN_ERR to pr_err

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/tty/ehv_bytechan.c           |  4 ++--
 drivers/tty/hvc/hvcs.c               |  2 +-
 drivers/tty/isicom.c                 | 14 +++++++-------
 drivers/tty/serial/bfin_sport_uart.c |  5 +++--
 drivers/tty/serial/mfd.c             |  2 +-
 drivers/tty/serial/mrst_max3110.c    | 27 ++++++++++++---------------
 drivers/tty/vt/keyboard.c            |  6 +++---
 drivers/tty/vt/vt.c                  |  4 ++--
 8 files changed, 31 insertions(+), 33 deletions(-)

diff --git a/drivers/tty/ehv_bytechan.c b/drivers/tty/ehv_bytechan.c
index 4f485e8..9d29d7e 100644
--- a/drivers/tty/ehv_bytechan.c
+++ b/drivers/tty/ehv_bytechan.c
@@ -309,8 +309,8 @@ static int __init ehv_bc_console_init(void)
 	 * handle for udbg.
 	 */
 	if (stdout_bc != CONFIG_PPC_EARLY_DEBUG_EHV_BC_HANDLE)
-		pr_warning("ehv-bc: udbg handle %u is not the stdout handle\n",
-			   CONFIG_PPC_EARLY_DEBUG_EHV_BC_HANDLE);
+		pr_warn("ehv-bc: udbg handle %u is not the stdout handle\n",
+			CONFIG_PPC_EARLY_DEBUG_EHV_BC_HANDLE);
 #endif
 
 	/* add_preferred_console() must be called before register_console(),
diff --git a/drivers/tty/hvc/hvcs.c b/drivers/tty/hvc/hvcs.c
index 81e939e..00bec633 100644
--- a/drivers/tty/hvc/hvcs.c
+++ b/drivers/tty/hvc/hvcs.c
@@ -1575,7 +1575,7 @@ static int __init hvcs_module_init(void)
 	 */
 	rc = driver_create_file(&(hvcs_vio_driver.driver), &driver_attr_rescan);
 	if (rc)
-		pr_warning(KERN_ERR "HVCS: Failed to create rescan file (err %d)\n", rc);
+		pr_err("HVCS: Failed to create rescan file (err %d)\n", rc);
 
 	return 0;
 }
diff --git a/drivers/tty/isicom.c b/drivers/tty/isicom.c
index 858291c..59ed783 100644
--- a/drivers/tty/isicom.c
+++ b/drivers/tty/isicom.c
@@ -249,7 +249,7 @@ static int lock_card(struct isi_board *card)
 		spin_unlock_irqrestore(&card->card_lock, card->flags);
 		msleep(10);
 	}
-	pr_warning("Failed to lock Card (0x%lx)\n", card->base);
+	pr_warn("Failed to lock Card (0x%lx)\n", card->base);
 
 	return 0;	/* Failed to acquire the card! */
 }
@@ -378,13 +378,13 @@ static inline int __isicom_paranoia_check(struct isi_port const *port,
 	char *name, const char *routine)
 {
 	if (!port) {
-		pr_warning("Warning: bad isicom magic for dev %s in %s.\n",
-			   name, routine);
+		pr_warn("Warning: bad isicom magic for dev %s in %s\n",
+			name, routine);
 		return 1;
 	}
 	if (port->magic != ISICOM_MAGIC) {
-		pr_warning("Warning: NULL isicom port for dev %s in %s.\n",
-			   name, routine);
+		pr_warn("Warning: NULL isicom port for dev %s in %s\n",
+			name, routine);
 		return 1;
 	}
 
@@ -546,8 +546,8 @@ static irqreturn_t isicom_interrupt(int irq, void *dev_id)
 	byte_count = header & 0xff;
 
 	if (channel + 1 > card->port_count) {
-		pr_warning("%s(0x%lx): %d(channel) > port_count.\n",
-			   __func__, base, channel+1);
+		pr_warn("%s(0x%lx): %d(channel) > port_count\n",
+			__func__, base, channel + 1);
 		outw(0x0000, base+0x04); /* enable interrupts */
 		spin_unlock(&card->card_lock);
 		return IRQ_HANDLED;
diff --git a/drivers/tty/serial/bfin_sport_uart.c b/drivers/tty/serial/bfin_sport_uart.c
index d62d8da..67d4083 100644
--- a/drivers/tty/serial/bfin_sport_uart.c
+++ b/drivers/tty/serial/bfin_sport_uart.c
@@ -517,14 +517,15 @@ static void sport_set_termios(struct uart_port *port,
 		up->csize = 5;
 		break;
 	default:
-		pr_warning("requested word length not supported\n");
+		pr_warn("requested word length not supported\n");
+		break;
 	}
 
 	if (termios->c_cflag & CSTOPB) {
 		up->stopb = 1;
 	}
 	if (termios->c_cflag & PARENB) {
-		pr_warning("PAREN bits is not supported yet\n");
+		pr_warn("PAREN bit is not supported yet\n");
 		/* up->parib = 1; */
 	}
 
diff --git a/drivers/tty/serial/mfd.c b/drivers/tty/serial/mfd.c
index 445799d..e1f4fda 100644
--- a/drivers/tty/serial/mfd.c
+++ b/drivers/tty/serial/mfd.c
@@ -1371,7 +1371,7 @@ static void hsu_global_init(void)
 	hsu->iolen = 0x1000;
 
 	if (!(request_mem_region(hsu->paddr, hsu->iolen, "HSU global")))
-		pr_warning("HSU: error in request mem region\n");
+		pr_warn("HSU: error in request mem region\n");
 
 	hsu->reg = ioremap_nocache((unsigned long)hsu->paddr, hsu->iolen);
 	if (!hsu->reg) {
diff --git a/drivers/tty/serial/mrst_max3110.c b/drivers/tty/serial/mrst_max3110.c
index 1504a14..77239d5 100644
--- a/drivers/tty/serial/mrst_max3110.c
+++ b/drivers/tty/serial/mrst_max3110.c
@@ -27,6 +27,8 @@
  *    interrupt for a low speed UART device
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #ifdef CONFIG_MAGIC_SYSRQ
 #define SUPPORT_SYSRQ
 #endif
@@ -47,8 +49,6 @@
 
 #include "mrst_max3110.h"
 
-#define PR_FMT	"mrst_max3110: "
-
 #define UART_TX_NEEDED 1
 #define CON_TX_NEEDED  2
 #define BIT_IRQ_PENDING    3
@@ -127,8 +127,8 @@ static int max3110_out(struct uart_max3110 *max, const u16 out)
 	*obuf = out;
 	ret = max3110_write_then_read(max, obuf, ibuf, 2, 1);
 	if (ret) {
-		pr_warning(PR_FMT "%s(): get err msg %d when sending 0x%x\n",
-				__func__, ret, out);
+		pr_warn("%s: get err msg %d when sending 0x%x\n",
+			__func__, ret, out);
 		goto exit;
 	}
 
@@ -153,10 +153,8 @@ static int max3110_read_multi(struct uart_max3110 *max)
 
 	blen = M3110_RX_FIFO_DEPTH * sizeof(u16);
 	buf = kzalloc(blen * 2, GFP_KERNEL | GFP_DMA);
-	if (!buf) {
-		pr_warning(PR_FMT "%s(): fail to alloc dma buffer\n", __func__);
+	if (!buf)
 		return 0;
-	}
 
 	/* tx/rx always have the same length */
 	obuf = buf;
@@ -212,13 +210,13 @@ serial_m3110_con_setup(struct console *co, char *options)
 	int parity = 'n';
 	int flow = 'n';
 
-	pr_info(PR_FMT "setting up console\n");
+	pr_info("setting up console\n");
 
 	if (co->index == -1)
 		co->index = 0;
 
 	if (!max) {
-		pr_err(PR_FMT "pmax is NULL, return");
+		pr_err("pmax is NULL, return\n");
 		return -ENODEV;
 	}
 
@@ -296,8 +294,7 @@ static void send_circ_buf(struct uart_max3110 *max,
 
 			ret = max3110_write_then_read(max, obuf, ibuf, blen, 0);
 			if (ret)
-				pr_warning(PR_FMT "%s(): get err msg %d\n",
-						__func__, ret);
+				pr_warn("%s: get err msg %d\n", __func__, ret);
 
 			receive_chars(max, ibuf, len);
 
@@ -411,7 +408,7 @@ static int max3110_main_thread(void *_max)
 	int ret = 0;
 	struct circ_buf *xmit = &max->con_xmit;
 
-	pr_info(PR_FMT "start main thread\n");
+	pr_info("start main thread\n");
 
 	do {
 		wait_event_interruptible(*wq,
@@ -455,7 +452,7 @@ static int max3110_read_thread(void *_max)
 {
 	struct uart_max3110 *max = _max;
 
-	pr_info(PR_FMT "start read thread\n");
+	pr_info("start read thread\n");
 	do {
 		/*
 		 * If can't acquire the mutex, it means the main thread
@@ -481,7 +478,7 @@ static int serial_m3110_startup(struct uart_port *port)
 	int ret = 0;
 
 	if (port->line != 0) {
-		pr_err(PR_FMT "uart port startup failed\n");
+		pr_err("uart port startup failed\n");
 		return -1;
 	}
 
@@ -504,7 +501,7 @@ static int serial_m3110_startup(struct uart_port *port)
 		if (IS_ERR(max->read_thread)) {
 			ret = PTR_ERR(max->read_thread);
 			max->read_thread = NULL;
-			pr_err(PR_FMT "Can't create read thread!\n");
+			pr_err("Can't create read thread!\n");
 			return ret;
 		}
 	}
diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
index 9d00088..acfb4c0 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -926,7 +926,7 @@ static void k_brl(struct vc_data *vc, unsigned char value, char up_flag)
 
 	if (kbd->kbdmode != VC_UNICODE) {
 		if (!up_flag)
-			pr_warning("keyboard mode must be unicode for braille patterns\n");
+			pr_warn("keyboard mode must be unicode for braille patterns\n");
 		return;
 	}
 
@@ -1310,8 +1310,8 @@ static void kbd_keycode(unsigned int keycode, int down, int hw_raw)
 	if (raw_mode && !hw_raw)
 		if (emulate_raw(vc, keycode, !down << 7))
 			if (keycode < BTN_MISC && printk_ratelimit())
-				pr_warning("can't emulate rawmode for keycode %d\n",
-					   keycode);
+				pr_warn("can't emulate rawmode for keycode %d\n",
+					keycode);
 
 #ifdef CONFIG_SPARC
 	if (keycode == KEY_A && sparc_l1_a_state) {
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index b33b00b..7b1665d 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -3849,8 +3849,8 @@ void do_unblank_screen(int leaving_gfx)
 		return;
 	if (!vc_cons_allocated(fg_console)) {
 		/* impossible */
-		pr_warning("unblank_screen: tty %d not allocated ??\n",
-			   fg_console+1);
+		pr_warn("unblank_screen: tty %d not allocated ??\n",
+			fg_console + 1);
 		return;
 	}
 	vc = vc_cons[fg_console].d;


