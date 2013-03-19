Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab3CSJwv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 05:52:51 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:64137 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757999Ab3CSJwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 05:52:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap8CANk0SFFbdWObgWdsb2JhbABDxSKBWxYOAQEWJiiCJQEFJ1IQUVcGE4gYsjGQIY8OB4NAA5ZfiWyKITs
X-IPAS-Result: Ap8CANk0SFFbdWObgWdsb2JhbABDxSKBWxYOAQEWJiiCJQEFJ1IQUVcGE4gYsjGQIY8OB4NAA5ZfiWyKITs
X-IronPort-AV: E=Sophos;i="4.84,870,1355094000"; 
   d="scan'208";a="18790005"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 2/9] staging/sb105x: rename _INLINE_ to inline
Date: Tue, 19 Mar 2013 10:51:23 +0100
Message-Id: <1363686690-27090-3-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363686690-27090-1-git-send-email-siglesias@igalia.com>
References: <1363686690-27090-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to have a definition of inline. It doesn't harm anything if explicitly
specify

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/sb105x/sb_pci_mp.c |   24 ++++++++++++------------
 drivers/staging/sb105x/sb_pci_mp.h |    9 ---------
 2 files changed, 12 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/sb105x/sb_pci_mp.c b/drivers/staging/sb105x/sb_pci_mp.c
index 660ec9c..4c88bfc 100644
--- a/drivers/staging/sb105x/sb_pci_mp.c
+++ b/drivers/staging/sb105x/sb_pci_mp.c
@@ -15,9 +15,9 @@ static int NR_PORTS=0;
 static struct mp_port multi_ports[MAX_MP_PORT];
 static struct irq_info irq_lists[NR_IRQS];
 
-static _INLINE_ unsigned int serial_in(struct mp_port *mtpt, int offset);
-static _INLINE_ void serial_out(struct mp_port *mtpt, int offset, int value);
-static _INLINE_ unsigned int read_option_register(struct mp_port *mtpt, int offset);
+static inline unsigned int serial_in(struct mp_port *mtpt, int offset);
+static inline void serial_out(struct mp_port *mtpt, int offset, int value);
+static inline unsigned int read_option_register(struct mp_port *mtpt, int offset);
 static int sb1054_get_register(struct sb_uart_port * port, int page, int reg);
 static int sb1054_set_register(struct sb_uart_port * port, int page, int reg, int value);
 static void SendATCommand(struct mp_port * mtpt);
@@ -79,9 +79,9 @@ static void multi_stop_tx(struct sb_uart_port *port);
 static void multi_start_tx(struct sb_uart_port *port);
 static void multi_stop_rx(struct sb_uart_port *port);
 static void multi_enable_ms(struct sb_uart_port *port);
-static _INLINE_ void receive_chars(struct mp_port *mtpt, int *status );
-static _INLINE_ void transmit_chars(struct mp_port *mtpt);
-static _INLINE_ void check_modem_status(struct mp_port *mtpt);
+static inline void receive_chars(struct mp_port *mtpt, int *status );
+static inline void transmit_chars(struct mp_port *mtpt);
+static inline void check_modem_status(struct mp_port *mtpt);
 static inline void multi_handle_port(struct mp_port *mtpt);
 static irqreturn_t multi_interrupt(int irq, void *dev_id);
 static void serial_do_unlink(struct irq_info *i, struct mp_port *mtpt);
@@ -121,17 +121,17 @@ module_param_array(fcr_arr,int,&fcr_count,0);
 module_param_array(ttr,int,&ttr_count,0);
 module_param_array(rtr,int,&rtr_count,0);
 
-static _INLINE_ unsigned int serial_in(struct mp_port *mtpt, int offset)
+static inline unsigned int serial_in(struct mp_port *mtpt, int offset)
 {
 	return inb(mtpt->port.iobase + offset);
 }
 
-static _INLINE_ void serial_out(struct mp_port *mtpt, int offset, int value)
+static inline void serial_out(struct mp_port *mtpt, int offset, int value)
 {
 	outb(value, mtpt->port.iobase + offset);
 }
 
-static _INLINE_ unsigned int read_option_register(struct mp_port *mtpt, int offset)
+static inline unsigned int read_option_register(struct mp_port *mtpt, int offset)
 {
 	return inb(mtpt->option_base_addr + offset);
 }
@@ -2044,7 +2044,7 @@ static void multi_enable_ms(struct sb_uart_port *port)
 }
 
 
-static _INLINE_ void receive_chars(struct mp_port *mtpt, int *status )
+static inline void receive_chars(struct mp_port *mtpt, int *status )
 {
 	struct tty_struct *tty = mtpt->port.info->tty;
 	unsigned char lsr = *status;
@@ -2105,7 +2105,7 @@ ignore_char:
 
 
 
-static _INLINE_ void transmit_chars(struct mp_port *mtpt)
+static inline void transmit_chars(struct mp_port *mtpt)
 {
 	struct circ_buf *xmit = &mtpt->port.info->xmit;
 	int count;
@@ -2150,7 +2150,7 @@ static _INLINE_ void transmit_chars(struct mp_port *mtpt)
 
 
 
-static _INLINE_ void check_modem_status(struct mp_port *mtpt)
+static inline void check_modem_status(struct mp_port *mtpt)
 {
 	int status;
 
diff --git a/drivers/staging/sb105x/sb_pci_mp.h b/drivers/staging/sb105x/sb_pci_mp.h
index f33efde..579dd83 100644
--- a/drivers/staging/sb105x/sb_pci_mp.h
+++ b/drivers/staging/sb105x/sb_pci_mp.h
@@ -174,15 +174,6 @@ static DEFINE_MUTEX(mp_mutex);
 #define DEBUG_INTR(fmt...)  do { } while (0)
 #endif
 
-#if defined(__i386__) && (defined(CONFIG_M386) || defined(CONFIG_M486))
-#define SERIAL_INLINE
-#endif
-#ifdef SERIAL_INLINE
-#define _INLINE_ inline
-#else
-#define _INLINE_
-#endif
-
 #define TYPE_POLL	1
 #define TYPE_INTERRUPT	2
 
-- 
1.7.10.4

