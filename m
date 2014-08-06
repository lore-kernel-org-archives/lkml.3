Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbaHFOFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 10:05:54 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:49625 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbaHFOFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 10:05:52 -0400
Date: Wed, 6 Aug 2014 19:35:47 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pcmcia: Remove typedef in structs and emum
Message-ID: <20140806140547.GA15508@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Linux kernel coding style guidelines suggest not using typedefs
for structure and enum types. This patch gets rid of the typedefs for
cirrus_state_t, vg46x_state_t and pcic_id. Also, the names of the structs
are changed to drop the _t, to make the name look less typedef-like.

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
 drivers/pcmcia/i82365.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/pcmcia/i82365.c b/drivers/pcmcia/i82365.c
index e6f3d17d..c2ea2ec 100644
--- a/drivers/pcmcia/i82365.c
+++ b/drivers/pcmcia/i82365.c
@@ -132,14 +132,14 @@ module_param(recov_time, int, 0444);
 
 /*====================================================================*/
 
-typedef struct cirrus_state_t {
+struct cirrus_state {
     u_char		misc1, misc2;
     u_char		timer[6];
-} cirrus_state_t;
+};
 
-typedef struct vg46x_state_t {
+struct vg46x_state {
     u_char		ctl, ema;
-} vg46x_state_t;
+};
 
 struct i82365_socket {
     u_short		type, flags;
@@ -149,8 +149,8 @@ struct i82365_socket {
     u_short		psock;
     u_char		cs_irq, intr;
     union {
-	cirrus_state_t		cirrus;
-	vg46x_state_t		vg46x;
+	struct cirrus_state		cirrus;
+	struct vg46x_state		vg46x;
     } state;
 };
 
@@ -173,11 +173,11 @@ static struct timer_list poll_timer;
 /*====================================================================*/
 
 /* These definitions must match the pcic table! */
-typedef enum pcic_id {
+enum pcic_id {
     IS_I82365A, IS_I82365B, IS_I82365DF,
     IS_IBM, IS_RF5Cx96, IS_VLSI, IS_VG468, IS_VG469,
     IS_PD6710, IS_PD672X, IS_VT83C469,
-} pcic_id;
+};
 
 /* Flags for classifying groups of controllers */
 #define IS_VADEM	0x0001
@@ -189,12 +189,12 @@ typedef enum pcic_id {
 #define IS_REGISTERED	0x2000
 #define IS_ALIVE	0x8000
 
-typedef struct pcic_t {
+struct pcic {
     char		*name;
     u_short		flags;
-} pcic_t;
+};
 
-static pcic_t pcic[] = {
+static struct pcic pcic[] = {
     { "Intel i82365sl A step", 0 },
     { "Intel i82365sl B step", 0 },
     { "Intel i82365sl DF", IS_DF_PWR },
@@ -208,7 +208,7 @@ static pcic_t pcic[] = {
     { "VIA VT83C469", IS_CIRRUS|IS_VIA },
 };
 
-#define PCIC_COUNT	(sizeof(pcic)/sizeof(pcic_t))
+#define PCIC_COUNT	(sizeof(pcic)/sizeof(struct pcic))
 
 /*====================================================================*/
 
@@ -294,7 +294,7 @@ static void i365_set_pair(u_short sock, u_short reg, u_short data)
 static void cirrus_get_state(u_short s)
 {
     int i;
-    cirrus_state_t *p = &socket[s].state.cirrus;
+    struct cirrus_state *p = &socket[s].state.cirrus;
     p->misc1 = i365_get(s, PD67_MISC_CTL_1);
     p->misc1 &= (PD67_MC1_MEDIA_ENA | PD67_MC1_INPACK_ENA);
     p->misc2 = i365_get(s, PD67_MISC_CTL_2);
@@ -306,7 +306,7 @@ static void cirrus_set_state(u_short s)
 {
     int i;
     u_char misc;
-    cirrus_state_t *p = &socket[s].state.cirrus;
+    struct cirrus_state *p = &socket[s].state.cirrus;
 
     misc = i365_get(s, PD67_MISC_CTL_2);
     i365_set(s, PD67_MISC_CTL_2, p->misc2);
@@ -321,7 +321,7 @@ static void cirrus_set_state(u_short s)
 static u_int __init cirrus_set_opts(u_short s, char *buf)
 {
     struct i82365_socket *t = &socket[s];
-    cirrus_state_t *p = &socket[s].state.cirrus;
+    struct cirrus_state *p = &socket[s].state.cirrus;
     u_int mask = 0xffff;
 
     if (has_ring == -1) has_ring = 1;
@@ -377,7 +377,7 @@ static u_int __init cirrus_set_opts(u_short s, char *buf)
 
 static void vg46x_get_state(u_short s)
 {
-    vg46x_state_t *p = &socket[s].state.vg46x;
+    struct vg46x_state *p = &socket[s].state.vg46x;
     p->ctl = i365_get(s, VG468_CTL);
     if (socket[s].type == IS_VG469)
 	p->ema = i365_get(s, VG469_EXT_MODE);
@@ -385,7 +385,7 @@ static void vg46x_get_state(u_short s)
 
 static void vg46x_set_state(u_short s)
 {
-    vg46x_state_t *p = &socket[s].state.vg46x;
+    struct vg46x_state *p = &socket[s].state.vg46x;
     i365_set(s, VG468_CTL, p->ctl);
     if (socket[s].type == IS_VG469)
 	i365_set(s, VG469_EXT_MODE, p->ema);
@@ -393,7 +393,7 @@ static void vg46x_set_state(u_short s)
 
 static u_int __init vg46x_set_opts(u_short s, char *buf)
 {
-    vg46x_state_t *p = &socket[s].state.vg46x;
+    struct vg46x_state *p = &socket[s].state.vg46x;
     
     flip(p->ctl, VG468_CTL_ASYNC, async_clock);
     flip(p->ema, VG469_MODE_CABLE, cable_mode);
-- 
1.9.1

