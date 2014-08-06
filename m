Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbaHFQgd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 12:36:33 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:53235 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbaHFQgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 12:36:32 -0400
Date: Wed, 6 Aug 2014 22:06:25 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] pcmcia/vrc4171: Remove typedefs for enums and struct
Message-ID: <20140806163625.GA4238@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Linux kernel coding style guidelines suggest not using typedefs
for structure and enum types. This patch gets rid of the typedefs for
vrc4171_slot_t, vrc4171_slotb_t and vrc4171_socket_t. Also, the names
of the enums and the struct are changed to drop the _t, to make the
name look less typedef-like.

The following Coccinelle semantic patch detects the cases for struct type:

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
 drivers/pcmcia/vrc4171_card.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/pcmcia/vrc4171_card.c b/drivers/pcmcia/vrc4171_card.c
index d98a086..b3019a3 100644
--- a/drivers/pcmcia/vrc4171_card.c
+++ b/drivers/pcmcia/vrc4171_card.c
@@ -84,32 +84,32 @@ MODULE_LICENSE("GPL");
 #define IO_MAX_MAPS	2
 #define MEM_MAX_MAPS	5
 
-typedef enum {
+enum vrc4171_slot {
 	SLOT_PROBE = 0,
 	SLOT_NOPROBE_IO,
 	SLOT_NOPROBE_MEM,
 	SLOT_NOPROBE_ALL,
 	SLOT_INITIALIZED,
-} vrc4171_slot_t;
+};
 
-typedef enum {
+enum vrc4171_slotb {
 	SLOTB_IS_NONE,
 	SLOTB_IS_PCCARD,
 	SLOTB_IS_CF,
 	SLOTB_IS_FLASHROM,
-} vrc4171_slotb_t;
+};
 
-typedef struct vrc4171_socket {
-	vrc4171_slot_t slot;
+struct vrc4171_socket {
+	enum vrc4171_slot slot;
 	struct pcmcia_socket pcmcia_socket;
 	char name[24];
 	int csc_irq;
 	int io_irq;
 	spinlock_t lock;
-} vrc4171_socket_t;
+};
 
-static vrc4171_socket_t vrc4171_sockets[CARD_MAX_SLOTS];
-static vrc4171_slotb_t vrc4171_slotb = SLOTB_IS_NONE;
+static struct vrc4171_socket vrc4171_sockets[CARD_MAX_SLOTS];
+static enum vrc4171_slotb vrc4171_slotb = SLOTB_IS_NONE;
 static char vrc4171_card_name[] = "NEC VRC4171 Card Controller";
 static unsigned int vrc4171_irq;
 static uint16_t vrc4171_irq_mask = 0xdeb8;
@@ -141,7 +141,7 @@ static inline uint16_t vrc4171_get_irq_status(void)
 	return inw(INTERRUPT_STATUS);
 }
 
-static inline void vrc4171_set_multifunction_pin(vrc4171_slotb_t config)
+static inline void vrc4171_set_multifunction_pin(enum vrc4171_slotb config)
 {
 	uint16_t config1;
 
@@ -234,7 +234,7 @@ static inline int search_nonuse_irq(void)
 
 static int pccard_init(struct pcmcia_socket *sock)
 {
-	vrc4171_socket_t *socket;
+	struct vrc4171_socket *socket;
 	unsigned int slot;
 
 	sock->features |= SS_CAP_PCCARD | SS_CAP_PAGE_REGS;
@@ -317,7 +317,7 @@ static inline uint8_t set_Vcc_value(u_char Vcc)
 
 static int pccard_set_socket(struct pcmcia_socket *sock, socket_state_t *state)
 {
-	vrc4171_socket_t *socket;
+	struct vrc4171_socket *socket;
 	unsigned int slot;
 	uint8_t voltage, power, control, cscint;
 
@@ -517,7 +517,7 @@ static inline unsigned int get_events(int slot)
 
 static irqreturn_t pccard_interrupt(int irq, void *dev_id)
 {
-	vrc4171_socket_t *socket;
+	struct vrc4171_socket *socket;
 	unsigned int events;
 	irqreturn_t retval = IRQ_NONE;
 	uint16_t status;
@@ -567,7 +567,7 @@ static inline void reserve_using_irq(int slot)
 
 static int vrc4171_add_sockets(void)
 {
-	vrc4171_socket_t *socket;
+	struct vrc4171_socket *socket;
 	int slot, retval;
 
 	for (slot = 0; slot < CARD_MAX_SLOTS; slot++) {
@@ -617,7 +617,7 @@ static int vrc4171_add_sockets(void)
 
 static void vrc4171_remove_sockets(void)
 {
-	vrc4171_socket_t *socket;
+	struct vrc4171_socket *socket;
 	int slot;
 
 	for (slot = 0; slot < CARD_MAX_SLOTS; slot++) {
-- 
1.9.1

