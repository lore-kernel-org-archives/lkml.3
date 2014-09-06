Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750998AbaIFB6F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 21:58:05 -0400
Received: from mga14.intel.com ([192.55.52.115]:63653 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbaIFB6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 21:58:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,477,1406617200"; 
   d="scan'208";a="475619809"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: gregkh@linuxfoundation.org, jslaby@suse.cz
Cc: Mark Rustad <mark.d.rustad@intel.com>, linux-kernel@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH] tty/vt/keyboard: Resolve many shadow warnings
Date: Fri,  5 Sep 2014 18:57:57 -0700
Message-Id: <1409968677-4721-1-git-send-email-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Rustad <mark.d.rustad@intel.com>

Many local variables were given the same name as a global. This
is valid, but generates many shadow warnings in W=2 builds. Resolve
them by changing the local names. Also change local variables
named "up" because they shadow the semaphore "up" function. Also
moved the outer declaration of the variable "a" because it is
only used in one block, and that resolves all of the shadow warnings
for the other declarations of "a" that have different types.

Change diacr => dia, kbd => kb, rep => rpt, up => udp.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/tty/vt/keyboard.c | 166 +++++++++++++++++++++++-----------------------
 1 file changed, 83 insertions(+), 83 deletions(-)

diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
index d0e3a44..c039cfe 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -268,30 +268,30 @@ EXPORT_SYMBOL(kd_mksound);
 static int kbd_rate_helper(struct input_handle *handle, void *data)
 {
 	struct input_dev *dev = handle->dev;
-	struct kbd_repeat *rep = data;
+	struct kbd_repeat *rpt = data;
 
 	if (test_bit(EV_REP, dev->evbit)) {
 
-		if (rep[0].delay > 0)
+		if (rpt[0].delay > 0)
 			input_inject_event(handle,
-					   EV_REP, REP_DELAY, rep[0].delay);
-		if (rep[0].period > 0)
+					   EV_REP, REP_DELAY, rpt[0].delay);
+		if (rpt[0].period > 0)
 			input_inject_event(handle,
-					   EV_REP, REP_PERIOD, rep[0].period);
+					   EV_REP, REP_PERIOD, rpt[0].period);
 
-		rep[1].delay = dev->rep[REP_DELAY];
-		rep[1].period = dev->rep[REP_PERIOD];
+		rpt[1].delay = dev->rep[REP_DELAY];
+		rpt[1].period = dev->rep[REP_PERIOD];
 	}
 
 	return 0;
 }
 
-int kbd_rate(struct kbd_repeat *rep)
+int kbd_rate(struct kbd_repeat *rpt)
 {
-	struct kbd_repeat data[2] = { *rep };
+	struct kbd_repeat data[2] = { *rpt };
 
 	input_handler_for_each_handle(&kbd_handler, data, kbd_rate_helper);
-	*rep = data[1];	/* Copy currently used settings */
+	*rpt = data[1];	/* Copy currently used settings */
 
 	return 0;
 }
@@ -971,15 +971,15 @@ static unsigned char getledstate(void)
 	return ledstate;
 }
 
-void setledstate(struct kbd_struct *kbd, unsigned int led)
+void setledstate(struct kbd_struct *kb, unsigned int led)
 {
         unsigned long flags;
         spin_lock_irqsave(&led_lock, flags);
 	if (!(led & ~7)) {
 		ledioctl = led;
-		kbd->ledmode = LED_SHOW_IOCTL;
+		kb->ledmode = LED_SHOW_IOCTL;
 	} else
-		kbd->ledmode = LED_SHOW_FLAGS;
+		kb->ledmode = LED_SHOW_FLAGS;
 
 	set_leds();
 	spin_unlock_irqrestore(&led_lock, flags);
@@ -987,12 +987,12 @@ void setledstate(struct kbd_struct *kbd, unsigned int led)
 
 static inline unsigned char getleds(void)
 {
-	struct kbd_struct *kbd = kbd_table + fg_console;
+	struct kbd_struct *kb = kbd_table + fg_console;
 
-	if (kbd->ledmode == LED_SHOW_IOCTL)
+	if (kb->ledmode == LED_SHOW_IOCTL)
 		return ledioctl;
 
-	return kbd->ledflagstate;
+	return kb->ledflagstate;
 }
 
 static int kbd_update_leds_helper(struct input_handle *handle, void *data)
@@ -1018,12 +1018,12 @@ static int kbd_update_leds_helper(struct input_handle *handle, void *data)
  */
 int vt_get_leds(int console, int flag)
 {
-	struct kbd_struct * kbd = kbd_table + console;
+	struct kbd_struct *kb = kbd_table + console;
 	int ret;
 	unsigned long flags;
 
 	spin_lock_irqsave(&led_lock, flags);
-	ret = vc_kbd_led(kbd, flag);
+	ret = vc_kbd_led(kb, flag);
 	spin_unlock_irqrestore(&led_lock, flags);
 
 	return ret;
@@ -1040,8 +1040,8 @@ EXPORT_SYMBOL_GPL(vt_get_leds);
  */
 void vt_set_led_state(int console, int leds)
 {
-	struct kbd_struct * kbd = kbd_table + console;
-	setledstate(kbd, leds);
+	struct kbd_struct *kb = kbd_table + console;
+	setledstate(kb, leds);
 }
 
 /**
@@ -1059,10 +1059,10 @@ void vt_set_led_state(int console, int leds)
  */
 void vt_kbd_con_start(int console)
 {
-	struct kbd_struct * kbd = kbd_table + console;
+	struct kbd_struct *kb = kbd_table + console;
 	unsigned long flags;
 	spin_lock_irqsave(&led_lock, flags);
-	clr_vc_kbd_led(kbd, VC_SCROLLOCK);
+	clr_vc_kbd_led(kb, VC_SCROLLOCK);
 	set_leds();
 	spin_unlock_irqrestore(&led_lock, flags);
 }
@@ -1076,10 +1076,10 @@ void vt_kbd_con_start(int console)
  */
 void vt_kbd_con_stop(int console)
 {
-	struct kbd_struct * kbd = kbd_table + console;
+	struct kbd_struct *kb = kbd_table + console;
 	unsigned long flags;
 	spin_lock_irqsave(&led_lock, flags);
-	set_vc_kbd_led(kbd, VC_SCROLLOCK);
+	set_vc_kbd_led(kb, VC_SCROLLOCK);
 	set_leds();
 	spin_unlock_irqrestore(&led_lock, flags);
 }
@@ -1512,15 +1512,14 @@ int __init kbd_init(void)
 /**
  *	vt_do_diacrit		-	diacritical table updates
  *	@cmd: ioctl request
- *	@up: pointer to user data for ioctl
+ *	@udp: pointer to user data for ioctl
  *	@perm: permissions check computed by caller
  *
  *	Update the diacritical tables atomically and safely. Lock them
  *	against simultaneous keypresses
  */
-int vt_do_diacrit(unsigned int cmd, void __user *up, int perm)
+int vt_do_diacrit(unsigned int cmd, void __user *udp, int perm)
 {
-	struct kbdiacrs __user *a = up;
 	unsigned long flags;
 	int asize;
 	int ret = 0;
@@ -1528,12 +1527,13 @@ int vt_do_diacrit(unsigned int cmd, void __user *up, int perm)
 	switch (cmd) {
 	case KDGKBDIACR:
 	{
-		struct kbdiacr *diacr;
+		struct kbdiacrs __user *a = udp;
+		struct kbdiacr *dia;
 		int i;
 
-		diacr = kmalloc(MAX_DIACR * sizeof(struct kbdiacr),
+		dia = kmalloc(MAX_DIACR * sizeof(struct kbdiacr),
 								GFP_KERNEL);
-		if (diacr == NULL)
+		if (!dia)
 			return -ENOMEM;
 
 		/* Lock the diacriticals table, make a copy and then
@@ -1542,26 +1542,26 @@ int vt_do_diacrit(unsigned int cmd, void __user *up, int perm)
 
 		asize = accent_table_size;
 		for (i = 0; i < asize; i++) {
-			diacr[i].diacr = conv_uni_to_8bit(
+			dia[i].diacr = conv_uni_to_8bit(
 						accent_table[i].diacr);
-			diacr[i].base = conv_uni_to_8bit(
+			dia[i].base = conv_uni_to_8bit(
 						accent_table[i].base);
-			diacr[i].result = conv_uni_to_8bit(
+			dia[i].result = conv_uni_to_8bit(
 						accent_table[i].result);
 		}
 		spin_unlock_irqrestore(&kbd_event_lock, flags);
 
 		if (put_user(asize, &a->kb_cnt))
 			ret = -EFAULT;
-		else  if (copy_to_user(a->kbdiacr, diacr,
+		else  if (copy_to_user(a->kbdiacr, dia,
 				asize * sizeof(struct kbdiacr)))
 			ret = -EFAULT;
-		kfree(diacr);
+		kfree(dia);
 		return ret;
 	}
 	case KDGKBDIACRUC:
 	{
-		struct kbdiacrsuc __user *a = up;
+		struct kbdiacrsuc __user *a = udp;
 		void *buf;
 
 		buf = kmalloc(MAX_DIACR * sizeof(struct kbdiacruc),
@@ -1589,8 +1589,8 @@ int vt_do_diacrit(unsigned int cmd, void __user *up, int perm)
 
 	case KDSKBDIACR:
 	{
-		struct kbdiacrs __user *a = up;
-		struct kbdiacr *diacr = NULL;
+		struct kbdiacrs __user *a = udp;
+		struct kbdiacr *dia = NULL;
 		unsigned int ct;
 		int i;
 
@@ -1602,14 +1602,14 @@ int vt_do_diacrit(unsigned int cmd, void __user *up, int perm)
 			return -EINVAL;
 
 		if (ct) {
-			diacr = kmalloc(sizeof(struct kbdiacr) * ct,
+			dia = kmalloc(sizeof(struct kbdiacr) * ct,
 								GFP_KERNEL);
-			if (diacr == NULL)
+			if (!dia)
 				return -ENOMEM;
 
-			if (copy_from_user(diacr, a->kbdiacr,
+			if (copy_from_user(dia, a->kbdiacr,
 					sizeof(struct kbdiacr) * ct)) {
-				kfree(diacr);
+				kfree(dia);
 				return -EFAULT;
 			}
 		}
@@ -1618,20 +1618,20 @@ int vt_do_diacrit(unsigned int cmd, void __user *up, int perm)
 		accent_table_size = ct;
 		for (i = 0; i < ct; i++) {
 			accent_table[i].diacr =
-					conv_8bit_to_uni(diacr[i].diacr);
+					conv_8bit_to_uni(dia[i].diacr);
 			accent_table[i].base =
-					conv_8bit_to_uni(diacr[i].base);
+					conv_8bit_to_uni(dia[i].base);
 			accent_table[i].result =
-					conv_8bit_to_uni(diacr[i].result);
+					conv_8bit_to_uni(dia[i].result);
 		}
 		spin_unlock_irqrestore(&kbd_event_lock, flags);
-		kfree(diacr);
+		kfree(dia);
 		return 0;
 	}
 
 	case KDSKBDIACRUC:
 	{
-		struct kbdiacrsuc __user *a = up;
+		struct kbdiacrsuc __user *a = udp;
 		unsigned int ct;
 		void *buf = NULL;
 
@@ -1679,28 +1679,28 @@ int vt_do_diacrit(unsigned int cmd, void __user *up, int perm)
  */
 int vt_do_kdskbmode(int console, unsigned int arg)
 {
-	struct kbd_struct * kbd = kbd_table + console;
+	struct kbd_struct *kb = kbd_table + console;
 	int ret = 0;
 	unsigned long flags;
 
 	spin_lock_irqsave(&kbd_event_lock, flags);
 	switch(arg) {
 	case K_RAW:
-		kbd->kbdmode = VC_RAW;
+		kb->kbdmode = VC_RAW;
 		break;
 	case K_MEDIUMRAW:
-		kbd->kbdmode = VC_MEDIUMRAW;
+		kb->kbdmode = VC_MEDIUMRAW;
 		break;
 	case K_XLATE:
-		kbd->kbdmode = VC_XLATE;
+		kb->kbdmode = VC_XLATE;
 		do_compute_shiftstate();
 		break;
 	case K_UNICODE:
-		kbd->kbdmode = VC_UNICODE;
+		kb->kbdmode = VC_UNICODE;
 		do_compute_shiftstate();
 		break;
 	case K_OFF:
-		kbd->kbdmode = VC_OFF;
+		kb->kbdmode = VC_OFF;
 		break;
 	default:
 		ret = -EINVAL;
@@ -1719,17 +1719,17 @@ int vt_do_kdskbmode(int console, unsigned int arg)
  */
 int vt_do_kdskbmeta(int console, unsigned int arg)
 {
-	struct kbd_struct * kbd = kbd_table + console;
+	struct kbd_struct *kb = kbd_table + console;
 	int ret = 0;
 	unsigned long flags;
 
 	spin_lock_irqsave(&kbd_event_lock, flags);
 	switch(arg) {
 	case K_METABIT:
-		clr_vc_kbd_mode(kbd, VC_META);
+		clr_vc_kbd_mode(kb, VC_META);
 		break;
 	case K_ESCPREFIX:
-		set_vc_kbd_mode(kbd, VC_META);
+		set_vc_kbd_mode(kb, VC_META);
 		break;
 	default:
 		ret = -EINVAL;
@@ -1768,7 +1768,7 @@ int vt_do_kbkeycode_ioctl(int cmd, struct kbkeycode __user *user_kbkc,
 int vt_do_kdsk_ioctl(int cmd, struct kbentry __user *user_kbe, int perm,
 						int console)
 {
-	struct kbd_struct * kbd = kbd_table + console;
+	struct kbd_struct *kb = kbd_table + console;
 	struct kbentry tmp;
 	ushort *key_map, *new_map, val, ov;
 	unsigned long flags;
@@ -1786,7 +1786,7 @@ int vt_do_kdsk_ioctl(int cmd, struct kbentry __user *user_kbe, int perm,
 		key_map = key_maps[s];
 		if (key_map) {
 		    val = U(key_map[i]);
-		    if (kbd->kbdmode != VC_UNICODE && KTYP(val) >= NR_TYPES)
+		    if (kb->kbdmode != VC_UNICODE && KTYP(val) >= NR_TYPES)
 			val = K_HOLE;
 		} else
 		    val = (i ? K_HOLE : K_NOSUCHMAP);
@@ -1814,7 +1814,7 @@ int vt_do_kdsk_ioctl(int cmd, struct kbentry __user *user_kbe, int perm,
 		    if (KVAL(v) > max_vals[KTYP(v)])
 				return -EINVAL;
 		} else
-		    if (kbd->kbdmode != VC_UNICODE)
+		    if (kb->kbdmode != VC_UNICODE)
 				return -EINVAL;
 
 		/* ++Geert: non-PC keyboards may generate keycode zero */
@@ -1985,7 +1985,7 @@ reterr:
 
 int vt_do_kdskled(int console, int cmd, unsigned long arg, int perm)
 {
-	struct kbd_struct * kbd = kbd_table + console;
+	struct kbd_struct *kb = kbd_table + console;
         unsigned long flags;
 	unsigned char ucval;
 
@@ -1994,7 +1994,7 @@ int vt_do_kdskled(int console, int cmd, unsigned long arg, int perm)
 	/* don't use them - they will go away without warning */
 	case KDGKBLED:
                 spin_lock_irqsave(&kbd_event_lock, flags);
-		ucval = kbd->ledflagstate | (kbd->default_ledflagstate << 4);
+		ucval = kb->ledflagstate | (kb->default_ledflagstate << 4);
                 spin_unlock_irqrestore(&kbd_event_lock, flags);
 		return put_user(ucval, (char __user *)arg);
 
@@ -2004,8 +2004,8 @@ int vt_do_kdskled(int console, int cmd, unsigned long arg, int perm)
 		if (arg & ~0x77)
 			return -EINVAL;
                 spin_lock_irqsave(&led_lock, flags);
-		kbd->ledflagstate = (arg & 7);
-		kbd->default_ledflagstate = ((arg >> 4) & 7);
+		kb->ledflagstate = (arg & 7);
+		kb->default_ledflagstate = ((arg >> 4) & 7);
 		set_leds();
                 spin_unlock_irqrestore(&led_lock, flags);
 		return 0;
@@ -2019,7 +2019,7 @@ int vt_do_kdskled(int console, int cmd, unsigned long arg, int perm)
 	case KDSETLED:
 		if (!perm)
 			return -EPERM;
-		setledstate(kbd, arg);
+		setledstate(kb, arg);
 		return 0;
         }
         return -ENOIOCTLCMD;
@@ -2027,9 +2027,9 @@ int vt_do_kdskled(int console, int cmd, unsigned long arg, int perm)
 
 int vt_do_kdgkbmode(int console)
 {
-	struct kbd_struct * kbd = kbd_table + console;
+	struct kbd_struct *kb = kbd_table + console;
 	/* This is a spot read so needs no locking */
-	switch (kbd->kbdmode) {
+	switch (kb->kbdmode) {
 	case VC_RAW:
 		return K_RAW;
 	case VC_MEDIUMRAW:
@@ -2051,9 +2051,9 @@ int vt_do_kdgkbmode(int console)
  */
 int vt_do_kdgkbmeta(int console)
 {
-	struct kbd_struct * kbd = kbd_table + console;
+	struct kbd_struct *kb = kbd_table + console;
         /* Again a spot read so no locking */
-	return vc_kbd_mode(kbd, VC_META) ? K_ESCPREFIX : K_METABIT;
+	return vc_kbd_mode(kb, VC_META) ? K_ESCPREFIX : K_METABIT;
 }
 
 /**
@@ -2092,19 +2092,19 @@ int vt_get_shift_state(void)
  */
 void vt_reset_keyboard(int console)
 {
-	struct kbd_struct * kbd = kbd_table + console;
+	struct kbd_struct *kb = kbd_table + console;
 	unsigned long flags;
 
 	spin_lock_irqsave(&kbd_event_lock, flags);
-	set_vc_kbd_mode(kbd, VC_REPEAT);
-	clr_vc_kbd_mode(kbd, VC_CKMODE);
-	clr_vc_kbd_mode(kbd, VC_APPLIC);
-	clr_vc_kbd_mode(kbd, VC_CRLF);
-	kbd->lockstate = 0;
-	kbd->slockstate = 0;
+	set_vc_kbd_mode(kb, VC_REPEAT);
+	clr_vc_kbd_mode(kb, VC_CKMODE);
+	clr_vc_kbd_mode(kb, VC_APPLIC);
+	clr_vc_kbd_mode(kb, VC_CRLF);
+	kb->lockstate = 0;
+	kb->slockstate = 0;
 	spin_lock(&led_lock);
-	kbd->ledmode = LED_SHOW_FLAGS;
-	kbd->ledflagstate = kbd->default_ledflagstate;
+	kb->ledmode = LED_SHOW_FLAGS;
+	kb->ledflagstate = kb->default_ledflagstate;
 	spin_unlock(&led_lock);
 	/* do not do set_leds here because this causes an endless tasklet loop
 	   when the keyboard hasn't been initialized yet */
@@ -2122,8 +2122,8 @@ void vt_reset_keyboard(int console)
 
 int vt_get_kbd_mode_bit(int console, int bit)
 {
-	struct kbd_struct * kbd = kbd_table + console;
-	return vc_kbd_mode(kbd, bit);
+	struct kbd_struct *kb = kbd_table + console;
+	return vc_kbd_mode(kb, bit);
 }
 
 /**
@@ -2137,11 +2137,11 @@ int vt_get_kbd_mode_bit(int console, int bit)
 
 void vt_set_kbd_mode_bit(int console, int bit)
 {
-	struct kbd_struct * kbd = kbd_table + console;
+	struct kbd_struct *kb = kbd_table + console;
 	unsigned long flags;
 
 	spin_lock_irqsave(&kbd_event_lock, flags);
-	set_vc_kbd_mode(kbd, bit);
+	set_vc_kbd_mode(kb, bit);
 	spin_unlock_irqrestore(&kbd_event_lock, flags);
 }
 
@@ -2156,10 +2156,10 @@ void vt_set_kbd_mode_bit(int console, int bit)
 
 void vt_clr_kbd_mode_bit(int console, int bit)
 {
-	struct kbd_struct * kbd = kbd_table + console;
+	struct kbd_struct *kb = kbd_table + console;
 	unsigned long flags;
 
 	spin_lock_irqsave(&kbd_event_lock, flags);
-	clr_vc_kbd_mode(kbd, bit);
+	clr_vc_kbd_mode(kb, bit);
 	spin_unlock_irqrestore(&kbd_event_lock, flags);
 }
-- 
1.9.3

