Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611AbbARH56 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 02:57:58 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:54444 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbbARH54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 02:57:56 -0500
Date: Sat, 17 Jan 2015 23:57:53 -0800
From: Shirish Gajera <gajerashirish@gmail.com>
To: w.d.hubbs@gmail.com, chris@the-brannons.com, kirk@reisers.ca,
        samuel.thibault@ens-lyon.org, gregkh@linuxfoundation.org,
        domagoj.trsan@gmail.com, dan.carpenter@oracle.com,
        roxanagabriela10@gmail.com, dilekuzulmez@gmail.com,
        ben@decadent.org.uk, daeseok.youn@gmail.com, sulamiification@gmail.com,
        aysemelikeyurtoglu@gmail.com, rusty@rustcorp.com.au,
        tapaswenipathak@gmail.com, sasha.levin@oracle.com,
        speakup@linux-speakup.org, devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] staging: speakup: Fix warning of line over 80 characters.
Message-ID: <20150118075753.GA2612@shirish-ThinkPad-Edge-E430>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the checkpatch.pl warning:

WARNING: line over 80 characters

All line over 80 characters in driver/staging/speakup/* are fixed

Signed-off-by: Shirish Gajera <gajerashirish@gmail.com>
---
 drivers/staging/speakup/main.c           | 12 ++++++++----
 drivers/staging/speakup/serialio.h       |  3 ++-
 drivers/staging/speakup/speakup.h        |  6 ++++--
 drivers/staging/speakup/speakup_decext.c |  6 ++++--
 drivers/staging/speakup/speakup_decpc.c  |  6 ++++--
 drivers/staging/speakup/spk_priv.h       |  3 ++-
 drivers/staging/speakup/spk_types.h      |  3 ++-
 drivers/staging/speakup/synth.c          | 10 +++++-----
 8 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/speakup/main.c b/drivers/staging/speakup/main.c
index e9f0c15..141abb7 100644
--- a/drivers/staging/speakup/main.c
+++ b/drivers/staging/speakup/main.c
@@ -422,8 +422,10 @@ static void announce_edge(struct vc_data *vc, int msg_id)
 {
 	if (spk_bleeps & 1)
 		bleep(spk_y);
-	if ((spk_bleeps & 2) && (msg_id < edge_quiet))
-		synth_printf("%s\n", spk_msg_get(MSG_EDGE_MSGS_START + msg_id - 1));
+	if ((spk_bleeps & 2) && (msg_id < edge_quiet)) {
+		synth_printf("%s\n",
+		spk_msg_get(MSG_EDGE_MSGS_START + msg_id - 1));
+	}
 }
 
 static void speak_char(u_char ch)
@@ -1131,7 +1133,8 @@ static void spkup_write(const char *in_buf, int count)
 	if (in_count > 2 && rep_count > 2) {
 		if (last_type & CH_RPT) {
 			synth_printf(" ");
-			synth_printf(spk_msg_get(MSG_REPEAT_DESC2), ++rep_count);
+			synth_printf(spk_msg_get(MSG_REPEAT_DESC2),
+				     ++rep_count);
 			synth_printf(" ");
 		}
 		rep_count = 0;
@@ -1847,7 +1850,8 @@ static void speakup_win_set(struct vc_data *vc)
 			win_right = spk_x;
 		}
 		snprintf(info, sizeof(info), spk_msg_get(MSG_WINDOW_BOUNDARY),
-			 (win_start) ? spk_msg_get(MSG_END) : spk_msg_get(MSG_START),
+			 (win_start) ? spk_msg_get(MSG_END) :
+				       spk_msg_get(MSG_START),
 			 (int)spk_y + 1, (int)spk_x + 1);
 	}
 	synth_printf("%s\n", info);
diff --git a/drivers/staging/speakup/serialio.h b/drivers/staging/speakup/serialio.h
index 317bb84..6e54c3e 100644
--- a/drivers/staging/speakup/serialio.h
+++ b/drivers/staging/speakup/serialio.h
@@ -34,6 +34,7 @@ struct old_serial_port {
 #define SPK_TIMEOUT 100
 #define BOTH_EMPTY (UART_LSR_TEMT | UART_LSR_THRE)
 
-#define spk_serial_tx_busy() ((inb(speakup_info.port_tts + UART_LSR) & BOTH_EMPTY) != BOTH_EMPTY)
+#define spk_serial_tx_busy() \
+((inb(speakup_info.port_tts + UART_LSR) & BOTH_EMPTY) != BOTH_EMPTY)
 
 #endif
diff --git a/drivers/staging/speakup/speakup.h b/drivers/staging/speakup/speakup.h
index 898dce5..d194ebb 100644
--- a/drivers/staging/speakup/speakup.h
+++ b/drivers/staging/speakup/speakup.h
@@ -61,10 +61,12 @@ extern struct st_var_header *spk_get_var_header(enum var_id_t var_id);
 extern struct st_var_header *spk_var_header_by_name(const char *name);
 extern struct punc_var_t *spk_get_punc_var(enum var_id_t var_id);
 extern int spk_set_num_var(int val, struct st_var_header *var, int how);
-extern int spk_set_string_var(const char *page, struct st_var_header *var, int len);
+extern int spk_set_string_var(const char *page, struct st_var_header *var,
+			      int len);
 extern int spk_set_mask_bits(const char *input, const int which, const int how);
 extern special_func spk_special_handler;
-extern int spk_handle_help(struct vc_data *vc, u_char type, u_char ch, u_short key);
+extern int spk_handle_help(struct vc_data *vc, u_char type, u_char ch,
+			   u_short key);
 extern int synth_init(char *name);
 extern void synth_release(void);
 
diff --git a/drivers/staging/speakup/speakup_decext.c b/drivers/staging/speakup/speakup_decext.c
index 5550290..d86a579 100644
--- a/drivers/staging/speakup/speakup_decext.c
+++ b/drivers/staging/speakup/speakup_decext.c
@@ -207,10 +207,12 @@ static void do_catch_up(struct spk_synth *synth)
 			if (time_after_eq(jiffies, jiff_max)) {
 				if (!in_escape)
 					spk_serial_out(PROCSPEECH);
-				spin_lock_irqsave(&speakup_info.spinlock, flags);
+				spin_lock_irqsave(&speakup_info.spinlock,
+						  flags);
 				jiffy_delta_val = jiffy_delta->u.n.value;
 				delay_time_val = delay_time->u.n.value;
-				spin_unlock_irqrestore(&speakup_info.spinlock, flags);
+				spin_unlock_irqrestore(&speakup_info.spinlock,
+						       flags);
 				schedule_timeout(msecs_to_jiffies
 						 (delay_time_val));
 				jiff_max = jiffies + jiffy_delta_val;
diff --git a/drivers/staging/speakup/speakup_decpc.c b/drivers/staging/speakup/speakup_decpc.c
index 7c9c432..b520a76 100644
--- a/drivers/staging/speakup/speakup_decpc.c
+++ b/drivers/staging/speakup/speakup_decpc.c
@@ -423,10 +423,12 @@ static void do_catch_up(struct spk_synth *synth)
 			if (time_after_eq(jiffies, jiff_max)) {
 				if (!in_escape)
 					dt_sendchar(PROCSPEECH);
-				spin_lock_irqsave(&speakup_info.spinlock, flags);
+				spin_lock_irqsave(&speakup_info.spinlock,
+						  flags);
 				jiffy_delta_val = jiffy_delta->u.n.value;
 				delay_time_val = delay_time->u.n.value;
-				spin_unlock_irqrestore(&speakup_info.spinlock, flags);
+				spin_unlock_irqrestore(&speakup_info.spinlock,
+						       flags);
 				schedule_timeout(msecs_to_jiffies
 						 (delay_time_val));
 				jiff_max = jiffies + jiffy_delta_val;
diff --git a/drivers/staging/speakup/spk_priv.h b/drivers/staging/speakup/spk_priv.h
index 637ba67..fb5742e 100644
--- a/drivers/staging/speakup/spk_priv.h
+++ b/drivers/staging/speakup/spk_priv.h
@@ -62,7 +62,8 @@ extern ssize_t spk_var_store(struct kobject *kobj, struct kobj_attribute *attr,
 	const char *buf, size_t count);
 
 extern int spk_serial_synth_probe(struct spk_synth *synth);
-extern const char *spk_synth_immediate(struct spk_synth *synth, const char *buff);
+extern const char *spk_synth_immediate(struct spk_synth *synth,
+				       const char *buff);
 extern void spk_do_catch_up(struct spk_synth *synth);
 extern void spk_synth_flush(struct spk_synth *synth);
 extern int spk_synth_is_alive_nop(struct spk_synth *synth);
diff --git a/drivers/staging/speakup/spk_types.h b/drivers/staging/speakup/spk_types.h
index 8c565c9..d6e30ba 100644
--- a/drivers/staging/speakup/spk_types.h
+++ b/drivers/staging/speakup/spk_types.h
@@ -167,7 +167,8 @@ struct spk_synth {
 	int *default_vol;
 	int (*probe)(struct spk_synth *synth);
 	void (*release)(void);
-	const char *(*synth_immediate)(struct spk_synth *synth, const char *buff);
+	const char *(*synth_immediate)(struct spk_synth *synth,
+				       const char *buff);
 	void (*catch_up)(struct spk_synth *synth);
 	void (*flush)(struct spk_synth *synth);
 	int (*is_alive)(struct spk_synth *synth);
diff --git a/drivers/staging/speakup/synth.c b/drivers/staging/speakup/synth.c
index f3aa423..8d28cc9 100644
--- a/drivers/staging/speakup/synth.c
+++ b/drivers/staging/speakup/synth.c
@@ -30,12 +30,12 @@ struct speakup_info_t speakup_info = {
 	 * must be taken at each kernel->speakup transition and released at
 	 * each corresponding speakup->kernel transition.
 	 *
-	 * The progression thread only interferes with the speakup machinery through
-	 * the synth buffer, so only needs to take the lock while tinkering with
-	 * the buffer.
+	 * The progression thread only interferes with the speakup machinery
+	 * through the synth buffer, so only needs to take the lock while
+	 * tinkering with the buffer.
 	 *
-	 * We use spin_lock/trylock_irqsave and spin_unlock_irqrestore with this
-	 * spinlock because speakup needs to disable the keyboard IRQ.
+	 * We use spin_lock/trylock_irqsave and spin_unlock_irqrestore with
+	 * this spinlock because speakup needs to disable the keyboard IRQ.
 	 */
 	.spinlock = __SPIN_LOCK_UNLOCKED(speakup_info.spinlock),
 	.flushing = 0,
-- 
1.9.1

