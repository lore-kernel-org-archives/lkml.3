Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbaCaEgG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 00:36:06 -0400
Received: from ozlabs.org ([203.10.76.45]:38274 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289AbaCaEfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 00:35:23 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        William Hubbs <w.d.hubbs@gmail.com>
Subject: Re: linux-next: build failure after merge of the modules tree
In-Reply-To: <20140325140226.bb363b52de048346cf01a179@canb.auug.org.au>
References: <20140325140226.bb363b52de048346cf01a179@canb.auug.org.au>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Mon, 31 Mar 2014 14:15:06 +1030
Message-ID: <87k3bbowu5.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:
> Hi Rusty,
>
> After merging the modules tree, today's linux-next build (x86_64
> allmodconfig) failed like this:

Hmm, I sent Greg KH a separate patch for staging, which rips these out
altogether.  He said he'd apply it "in a bit".

I see it hasn't hit mainline yet, so here it is.

From: Rusty Russell <rusty@rustcorp.com.au>
Subject: staging: fix up speakup kobject mode

It uses the unnecessary S_IFREG bit which will break when my
stricter-checking-for-mode patch goes in.

Since we're fixing it anyway, the extra level of indirection is
confusing for readers (ROOT_W == rw-r--r-- for example).

Also, many of these are other-writable.  Is that really intended?

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/staging/speakup/kobjects.c       | 62 ++++++++++++++++----------------
 drivers/staging/speakup/speakup.h        |  2 --
 drivers/staging/speakup/speakup_acntpc.c | 22 ++++++------
 drivers/staging/speakup/speakup_acntsa.c | 22 ++++++------
 drivers/staging/speakup/speakup_apollo.c | 24 ++++++-------
 drivers/staging/speakup/speakup_audptr.c | 24 ++++++-------
 drivers/staging/speakup/speakup_bns.c    | 22 ++++++------
 drivers/staging/speakup/speakup_decext.c | 24 ++++++-------
 drivers/staging/speakup/speakup_decpc.c  | 24 ++++++-------
 drivers/staging/speakup/speakup_dectlk.c | 24 ++++++-------
 drivers/staging/speakup/speakup_dtlk.c   | 28 +++++++--------
 drivers/staging/speakup/speakup_dummy.c  | 22 ++++++------
 drivers/staging/speakup/speakup_keypc.c  | 18 +++++-----
 drivers/staging/speakup/speakup_ltlk.c   | 28 +++++++--------
 drivers/staging/speakup/speakup_soft.c   | 30 ++++++++--------
 drivers/staging/speakup/speakup_spkout.c | 24 ++++++-------
 drivers/staging/speakup/speakup_txprt.c  | 22 ++++++------
 17 files changed, 210 insertions(+), 212 deletions(-)

diff --git a/drivers/staging/speakup/kobjects.c b/drivers/staging/speakup/kobjects.c
index e2f597ee6261..1ca91f7092b1 100644
--- a/drivers/staging/speakup/kobjects.c
+++ b/drivers/staging/speakup/kobjects.c
@@ -851,75 +851,75 @@ static ssize_t message_store(struct kobject *kobj, struct kobj_attribute *attr,
  * Declare the attributes.
  */
 static struct kobj_attribute keymap_attribute =
-	__ATTR(keymap, ROOT_W, keymap_show, keymap_store);
+	__ATTR(keymap, S_IWUSR|S_IRUGO, keymap_show, keymap_store);
 static struct kobj_attribute silent_attribute =
-	__ATTR(silent, USER_W, NULL, silent_store);
+	__ATTR(silent, S_IWUGO, NULL, silent_store);
 static struct kobj_attribute synth_attribute =
-	__ATTR(synth, USER_RW, synth_show, synth_store);
+	__ATTR(synth, S_IWUGO|S_IRUGO, synth_show, synth_store);
 static struct kobj_attribute synth_direct_attribute =
-	__ATTR(synth_direct, USER_W, NULL, synth_direct_store);
+	__ATTR(synth_direct, S_IWUGO, NULL, synth_direct_store);
 static struct kobj_attribute version_attribute =
 	__ATTR_RO(version);
 
 static struct kobj_attribute delimiters_attribute =
-	__ATTR(delimiters, USER_RW, punc_show, punc_store);
+	__ATTR(delimiters, S_IWUGO|S_IRUGO, punc_show, punc_store);
 static struct kobj_attribute ex_num_attribute =
-	__ATTR(ex_num, USER_RW, punc_show, punc_store);
+	__ATTR(ex_num, S_IWUGO|S_IRUGO, punc_show, punc_store);
 static struct kobj_attribute punc_all_attribute =
-	__ATTR(punc_all, USER_RW, punc_show, punc_store);
+	__ATTR(punc_all, S_IWUGO|S_IRUGO, punc_show, punc_store);
 static struct kobj_attribute punc_most_attribute =
-	__ATTR(punc_most, USER_RW, punc_show, punc_store);
+	__ATTR(punc_most, S_IWUGO|S_IRUGO, punc_show, punc_store);
 static struct kobj_attribute punc_some_attribute =
-	__ATTR(punc_some, USER_RW, punc_show, punc_store);
+	__ATTR(punc_some, S_IWUGO|S_IRUGO, punc_show, punc_store);
 static struct kobj_attribute repeats_attribute =
-	__ATTR(repeats, USER_RW, punc_show, punc_store);
+	__ATTR(repeats, S_IWUGO|S_IRUGO, punc_show, punc_store);
 
 static struct kobj_attribute attrib_bleep_attribute =
-	__ATTR(attrib_bleep, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(attrib_bleep, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute bell_pos_attribute =
-	__ATTR(bell_pos, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(bell_pos, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute bleep_time_attribute =
-	__ATTR(bleep_time, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(bleep_time, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute bleeps_attribute =
-	__ATTR(bleeps, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(bleeps, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute cursor_time_attribute =
-	__ATTR(cursor_time, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(cursor_time, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute key_echo_attribute =
-	__ATTR(key_echo, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(key_echo, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute no_interrupt_attribute =
-	__ATTR(no_interrupt, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(no_interrupt, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute punc_level_attribute =
-	__ATTR(punc_level, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(punc_level, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute reading_punc_attribute =
-	__ATTR(reading_punc, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(reading_punc, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute say_control_attribute =
-	__ATTR(say_control, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(say_control, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute say_word_ctl_attribute =
-	__ATTR(say_word_ctl, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(say_word_ctl, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute spell_delay_attribute =
-	__ATTR(spell_delay, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(spell_delay, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 
 /*
  * These attributes are i18n related.
  */
 static struct kobj_attribute announcements_attribute =
-	__ATTR(announcements, USER_RW, message_show, message_store);
+	__ATTR(announcements, S_IWUGO|S_IRUGO, message_show, message_store);
 static struct kobj_attribute characters_attribute =
-	__ATTR(characters, USER_RW, chars_chartab_show, chars_chartab_store);
+	__ATTR(characters, S_IWUGO|S_IRUGO, chars_chartab_show, chars_chartab_store);
 static struct kobj_attribute chartab_attribute =
-	__ATTR(chartab, USER_RW, chars_chartab_show, chars_chartab_store);
+	__ATTR(chartab, S_IWUGO|S_IRUGO, chars_chartab_show, chars_chartab_store);
 static struct kobj_attribute ctl_keys_attribute =
-	__ATTR(ctl_keys, USER_RW, message_show, message_store);
+	__ATTR(ctl_keys, S_IWUGO|S_IRUGO, message_show, message_store);
 static struct kobj_attribute colors_attribute =
-	__ATTR(colors, USER_RW, message_show, message_store);
+	__ATTR(colors, S_IWUGO|S_IRUGO, message_show, message_store);
 static struct kobj_attribute formatted_attribute =
-	__ATTR(formatted, USER_RW, message_show, message_store);
+	__ATTR(formatted, S_IWUGO|S_IRUGO, message_show, message_store);
 static struct kobj_attribute function_names_attribute =
-	__ATTR(function_names, USER_RW, message_show, message_store);
+	__ATTR(function_names, S_IWUGO|S_IRUGO, message_show, message_store);
 static struct kobj_attribute key_names_attribute =
-	__ATTR(key_names, USER_RW, message_show, message_store);
+	__ATTR(key_names, S_IWUGO|S_IRUGO, message_show, message_store);
 static struct kobj_attribute states_attribute =
-	__ATTR(states, USER_RW, message_show, message_store);
+	__ATTR(states, S_IWUGO|S_IRUGO, message_show, message_store);
 
 /*
  * Create groups of attributes so that we can create and destroy them all
diff --git a/drivers/staging/speakup/speakup.h b/drivers/staging/speakup/speakup.h
index 0126f714821a..a7bcceec436a 100644
--- a/drivers/staging/speakup/speakup.h
+++ b/drivers/staging/speakup/speakup.h
@@ -12,8 +12,6 @@
 /* proc permissions */
 #define USER_R (S_IFREG|S_IRUGO)
 #define USER_W (S_IFREG|S_IWUGO)
-#define USER_RW (S_IFREG|S_IRUGO|S_IWUGO)
-#define ROOT_W (S_IFREG|S_IRUGO|S_IWUSR)
 
 #define TOGGLE_0 .u.n = {NULL, 0, 0, 1, 0, 0, NULL }
 #define TOGGLE_1 .u.n = {NULL, 1, 0, 1, 0, 0, NULL }
diff --git a/drivers/staging/speakup/speakup_acntpc.c b/drivers/staging/speakup/speakup_acntpc.c
index 1c8a7f4a0ef5..e7dfa434bd96 100644
--- a/drivers/staging/speakup/speakup_acntpc.c
+++ b/drivers/staging/speakup/speakup_acntpc.c
@@ -62,28 +62,28 @@ static struct var_t vars[] = {
  * These attributes will appear in /sys/accessibility/speakup/acntpc.
  */
 static struct kobj_attribute caps_start_attribute =
-	__ATTR(caps_start, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(caps_start, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute caps_stop_attribute =
-	__ATTR(caps_stop, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(caps_stop, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute pitch_attribute =
-	__ATTR(pitch, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(pitch, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute rate_attribute =
-	__ATTR(rate, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(rate, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute tone_attribute =
-	__ATTR(tone, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(tone, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute vol_attribute =
-	__ATTR(vol, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(vol, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 
 static struct kobj_attribute delay_time_attribute =
-	__ATTR(delay_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(delay_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute direct_attribute =
-	__ATTR(direct, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(direct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute full_time_attribute =
-	__ATTR(full_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(full_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute jiffy_delta_attribute =
-	__ATTR(jiffy_delta, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(jiffy_delta, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute trigger_time_attribute =
-	__ATTR(trigger_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(trigger_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 
 /*
  * Create a group of attributes so that we can create and destroy them all
diff --git a/drivers/staging/speakup/speakup_acntsa.c b/drivers/staging/speakup/speakup_acntsa.c
index 22a8b7291098..c7f014ed9628 100644
--- a/drivers/staging/speakup/speakup_acntsa.c
+++ b/drivers/staging/speakup/speakup_acntsa.c
@@ -47,28 +47,28 @@ static struct var_t vars[] = {
  * These attributes will appear in /sys/accessibility/speakup/acntsa.
  */
 static struct kobj_attribute caps_start_attribute =
-	__ATTR(caps_start, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(caps_start, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute caps_stop_attribute =
-	__ATTR(caps_stop, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(caps_stop, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute pitch_attribute =
-	__ATTR(pitch, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(pitch, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute rate_attribute =
-	__ATTR(rate, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(rate, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute tone_attribute =
-	__ATTR(tone, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(tone, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute vol_attribute =
-	__ATTR(vol, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(vol, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 
 static struct kobj_attribute delay_time_attribute =
-	__ATTR(delay_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(delay_time, S_IRUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute direct_attribute =
-	__ATTR(direct, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(direct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute full_time_attribute =
-	__ATTR(full_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(full_time, S_IRUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute jiffy_delta_attribute =
-	__ATTR(jiffy_delta, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(jiffy_delta, S_IRUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute trigger_time_attribute =
-	__ATTR(trigger_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(trigger_time, S_IRUSR|S_IRUGO, spk_var_show, spk_var_store);
 
 /*
  * Create a group of attributes so that we can create and destroy them all
diff --git a/drivers/staging/speakup/speakup_apollo.c b/drivers/staging/speakup/speakup_apollo.c
index 70cf1591676a..38c8c2221e4e 100644
--- a/drivers/staging/speakup/speakup_apollo.c
+++ b/drivers/staging/speakup/speakup_apollo.c
@@ -53,30 +53,30 @@ static struct var_t vars[] = {
  * These attributes will appear in /sys/accessibility/speakup/apollo.
  */
 static struct kobj_attribute caps_start_attribute =
-	__ATTR(caps_start, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(caps_start, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute caps_stop_attribute =
-	__ATTR(caps_stop, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(caps_stop, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute lang_attribute =
-	__ATTR(lang, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(lang, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute pitch_attribute =
-	__ATTR(pitch, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(pitch, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute rate_attribute =
-	__ATTR(rate, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(rate, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute voice_attribute =
-	__ATTR(voice, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(voice, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute vol_attribute =
-	__ATTR(vol, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(vol, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 
 static struct kobj_attribute delay_time_attribute =
-	__ATTR(delay_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(delay_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute direct_attribute =
-	__ATTR(direct, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(direct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute full_time_attribute =
-	__ATTR(full_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(full_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute jiffy_delta_attribute =
-	__ATTR(jiffy_delta, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(jiffy_delta, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute trigger_time_attribute =
-	__ATTR(trigger_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(trigger_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 
 /*
  * Create a group of attributes so that we can create and destroy them all
diff --git a/drivers/staging/speakup/speakup_audptr.c b/drivers/staging/speakup/speakup_audptr.c
index 61a3ceeb0d3a..de5b4a5f43b6 100644
--- a/drivers/staging/speakup/speakup_audptr.c
+++ b/drivers/staging/speakup/speakup_audptr.c
@@ -49,30 +49,30 @@ static struct var_t vars[] = {
  * These attributes will appear in /sys/accessibility/speakup/audptr.
  */
 static struct kobj_attribute caps_start_attribute =
-	__ATTR(caps_start, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(caps_start, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute caps_stop_attribute =
-	__ATTR(caps_stop, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(caps_stop, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute pitch_attribute =
-	__ATTR(pitch, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(pitch, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute punct_attribute =
-	__ATTR(punct, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(punct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute rate_attribute =
-	__ATTR(rate, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(rate, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute tone_attribute =
-	__ATTR(tone, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(tone, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute vol_attribute =
-	__ATTR(vol, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(vol, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 
 static struct kobj_attribute delay_time_attribute =
-	__ATTR(delay_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(delay_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute direct_attribute =
-	__ATTR(direct, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(direct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute full_time_attribute =
-	__ATTR(full_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(full_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute jiffy_delta_attribute =
-	__ATTR(jiffy_delta, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(jiffy_delta, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute trigger_time_attribute =
-	__ATTR(trigger_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(trigger_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 
 /*
  * Create a group of attributes so that we can create and destroy them all
diff --git a/drivers/staging/speakup/speakup_bns.c b/drivers/staging/speakup/speakup_bns.c
index 4bfe3d458dc0..4939e8c7272e 100644
--- a/drivers/staging/speakup/speakup_bns.c
+++ b/drivers/staging/speakup/speakup_bns.c
@@ -44,28 +44,28 @@ static struct var_t vars[] = {
  * These attributes will appear in /sys/accessibility/speakup/bns.
  */
 static struct kobj_attribute caps_start_attribute =
-	__ATTR(caps_start, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(caps_start, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute caps_stop_attribute =
-	__ATTR(caps_stop, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(caps_stop, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute pitch_attribute =
-	__ATTR(pitch, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(pitch, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute rate_attribute =
-	__ATTR(rate, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(rate, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute tone_attribute =
-	__ATTR(tone, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(tone, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute vol_attribute =
-	__ATTR(vol, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(vol, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 
 static struct kobj_attribute delay_time_attribute =
-	__ATTR(delay_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(delay_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute direct_attribute =
-	__ATTR(direct, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(direct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute full_time_attribute =
-	__ATTR(full_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(full_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute jiffy_delta_attribute =
-	__ATTR(jiffy_delta, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(jiffy_delta, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute trigger_time_attribute =
-	__ATTR(trigger_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(trigger_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 
 /*
  * Create a group of attributes so that we can create and destroy them all
diff --git a/drivers/staging/speakup/speakup_decext.c b/drivers/staging/speakup/speakup_decext.c
index d306e010d3ea..b17af9803929 100644
--- a/drivers/staging/speakup/speakup_decext.c
+++ b/drivers/staging/speakup/speakup_decext.c
@@ -70,30 +70,30 @@ static struct var_t vars[] = {
  * These attributes will appear in /sys/accessibility/speakup/decext.
  */
 static struct kobj_attribute caps_start_attribute =
-	__ATTR(caps_start, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(caps_start, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute caps_stop_attribute =
-	__ATTR(caps_stop, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(caps_stop, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute pitch_attribute =
-	__ATTR(pitch, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(pitch, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute punct_attribute =
-	__ATTR(punct, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(punct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute rate_attribute =
-	__ATTR(rate, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(rate, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute voice_attribute =
-	__ATTR(voice, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(voice, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute vol_attribute =
-	__ATTR(vol, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(vol, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 
 static struct kobj_attribute delay_time_attribute =
-	__ATTR(delay_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(delay_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute direct_attribute =
-	__ATTR(direct, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(direct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute full_time_attribute =
-	__ATTR(full_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(full_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute jiffy_delta_attribute =
-	__ATTR(jiffy_delta, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(jiffy_delta, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute trigger_time_attribute =
-	__ATTR(trigger_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(trigger_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 
 /*
  * Create a group of attributes so that we can create and destroy them all
diff --git a/drivers/staging/speakup/speakup_decpc.c b/drivers/staging/speakup/speakup_decpc.c
index ea6b72d40b31..cfa4bc032358 100644
--- a/drivers/staging/speakup/speakup_decpc.c
+++ b/drivers/staging/speakup/speakup_decpc.c
@@ -164,30 +164,30 @@ static struct var_t vars[] = {
  * These attributes will appear in /sys/accessibility/speakup/decpc.
  */
 static struct kobj_attribute caps_start_attribute =
-	__ATTR(caps_start, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(caps_start, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute caps_stop_attribute =
-	__ATTR(caps_stop, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(caps_stop, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute pitch_attribute =
-	__ATTR(pitch, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(pitch, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute punct_attribute =
-	__ATTR(punct, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(punct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute rate_attribute =
-	__ATTR(rate, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(rate, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute voice_attribute =
-	__ATTR(voice, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(voice, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute vol_attribute =
-	__ATTR(vol, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(vol, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 
 static struct kobj_attribute delay_time_attribute =
-	__ATTR(delay_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(delay_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute direct_attribute =
-	__ATTR(direct, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(direct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute full_time_attribute =
-	__ATTR(full_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(full_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute jiffy_delta_attribute =
-	__ATTR(jiffy_delta, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(jiffy_delta, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute trigger_time_attribute =
-	__ATTR(trigger_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(trigger_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 
 /*
  * Create a group of attributes so that we can create and destroy them all
diff --git a/drivers/staging/speakup/speakup_dectlk.c b/drivers/staging/speakup/speakup_dectlk.c
index 15fdec323a70..0a27c8f32bb9 100644
--- a/drivers/staging/speakup/speakup_dectlk.c
+++ b/drivers/staging/speakup/speakup_dectlk.c
@@ -70,30 +70,30 @@ static struct var_t vars[] = {
  * These attributes will appear in /sys/accessibility/speakup/dectlk.
  */
 static struct kobj_attribute caps_start_attribute =
-	__ATTR(caps_start, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(caps_start, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute caps_stop_attribute =
-	__ATTR(caps_stop, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(caps_stop, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute pitch_attribute =
-	__ATTR(pitch, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(pitch, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute punct_attribute =
-	__ATTR(punct, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(punct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute rate_attribute =
-	__ATTR(rate, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(rate, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute voice_attribute =
-	__ATTR(voice, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(voice, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute vol_attribute =
-	__ATTR(vol, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(vol, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 
 static struct kobj_attribute delay_time_attribute =
-	__ATTR(delay_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(delay_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute direct_attribute =
-	__ATTR(direct, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(direct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute full_time_attribute =
-	__ATTR(full_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(full_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute jiffy_delta_attribute =
-	__ATTR(jiffy_delta, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(jiffy_delta, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute trigger_time_attribute =
-	__ATTR(trigger_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(trigger_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 
 /*
  * Create a group of attributes so that we can create and destroy them all
diff --git a/drivers/staging/speakup/speakup_dtlk.c b/drivers/staging/speakup/speakup_dtlk.c
index 1feb0fba1b43..5c6c34191e8d 100644
--- a/drivers/staging/speakup/speakup_dtlk.c
+++ b/drivers/staging/speakup/speakup_dtlk.c
@@ -67,34 +67,34 @@ static struct var_t vars[] = {
  * These attributes will appear in /sys/accessibility/speakup/dtlk.
  */
 static struct kobj_attribute caps_start_attribute =
-	__ATTR(caps_start, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(caps_start, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute caps_stop_attribute =
-	__ATTR(caps_stop, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(caps_stop, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute freq_attribute =
-	__ATTR(freq, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(freq, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute pitch_attribute =
-	__ATTR(pitch, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(pitch, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute punct_attribute =
-	__ATTR(punct, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(punct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute rate_attribute =
-	__ATTR(rate, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(rate, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute tone_attribute =
-	__ATTR(tone, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(tone, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute voice_attribute =
-	__ATTR(voice, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(voice, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute vol_attribute =
-	__ATTR(vol, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(vol, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 
 static struct kobj_attribute delay_time_attribute =
-	__ATTR(delay_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(delay_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute direct_attribute =
-	__ATTR(direct, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(direct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute full_time_attribute =
-	__ATTR(full_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(full_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute jiffy_delta_attribute =
-	__ATTR(jiffy_delta, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(jiffy_delta, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute trigger_time_attribute =
-	__ATTR(trigger_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(trigger_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 
 /*
  * Create a group of attributes so that we can create and destroy them all
diff --git a/drivers/staging/speakup/speakup_dummy.c b/drivers/staging/speakup/speakup_dummy.c
index 4a24b9c1e8e3..e19e9994bbb5 100644
--- a/drivers/staging/speakup/speakup_dummy.c
+++ b/drivers/staging/speakup/speakup_dummy.c
@@ -46,28 +46,28 @@ static struct var_t vars[] = {
  * These attributes will appear in /sys/accessibility/speakup/dummy.
  */
 static struct kobj_attribute caps_start_attribute =
-	__ATTR(caps_start, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(caps_start, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute caps_stop_attribute =
-	__ATTR(caps_stop, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(caps_stop, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute pitch_attribute =
-	__ATTR(pitch, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(pitch, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute rate_attribute =
-	__ATTR(rate, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(rate, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute tone_attribute =
-	__ATTR(tone, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(tone, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute vol_attribute =
-	__ATTR(vol, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(vol, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 
 static struct kobj_attribute delay_time_attribute =
-	__ATTR(delay_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(delay_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute direct_attribute =
-	__ATTR(direct, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(direct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute full_time_attribute =
-	__ATTR(full_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(full_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute jiffy_delta_attribute =
-	__ATTR(jiffy_delta, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(jiffy_delta, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute trigger_time_attribute =
-	__ATTR(trigger_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(trigger_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 
 /*
  * Create a group of attributes so that we can create and destroy them all
diff --git a/drivers/staging/speakup/speakup_keypc.c b/drivers/staging/speakup/speakup_keypc.c
index 2f2fe5eeff63..9c246d701a95 100644
--- a/drivers/staging/speakup/speakup_keypc.c
+++ b/drivers/staging/speakup/speakup_keypc.c
@@ -59,24 +59,24 @@ static struct var_t vars[] = {
  * These attributes will appear in /sys/accessibility/speakup/keypc.
  */
 static struct kobj_attribute caps_start_attribute =
-	__ATTR(caps_start, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(caps_start, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute caps_stop_attribute =
-	__ATTR(caps_stop, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(caps_stop, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute pitch_attribute =
-	__ATTR(pitch, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(pitch, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute rate_attribute =
-	__ATTR(rate, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(rate, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 
 static struct kobj_attribute delay_time_attribute =
-	__ATTR(delay_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(delay_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute direct_attribute =
-	__ATTR(direct, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(direct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute full_time_attribute =
-	__ATTR(full_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(full_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute jiffy_delta_attribute =
-	__ATTR(jiffy_delta, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(jiffy_delta, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute trigger_time_attribute =
-	__ATTR(trigger_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(trigger_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 
 /*
  * Create a group of attributes so that we can create and destroy them all
diff --git a/drivers/staging/speakup/speakup_ltlk.c b/drivers/staging/speakup/speakup_ltlk.c
index 326f94d6b079..c9be6f52c254 100644
--- a/drivers/staging/speakup/speakup_ltlk.c
+++ b/drivers/staging/speakup/speakup_ltlk.c
@@ -50,34 +50,34 @@ static struct var_t vars[] = {
  * These attributes will appear in /sys/accessibility/speakup/ltlk.
  */
 static struct kobj_attribute caps_start_attribute =
-	__ATTR(caps_start, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(caps_start, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute caps_stop_attribute =
-	__ATTR(caps_stop, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(caps_stop, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute freq_attribute =
-	__ATTR(freq, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(freq, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute pitch_attribute =
-	__ATTR(pitch, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(pitch, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute punct_attribute =
-	__ATTR(punct, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(punct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute rate_attribute =
-	__ATTR(rate, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(rate, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute tone_attribute =
-	__ATTR(tone, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(tone, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute voice_attribute =
-	__ATTR(voice, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(voice, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute vol_attribute =
-	__ATTR(vol, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(vol, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 
 static struct kobj_attribute delay_time_attribute =
-	__ATTR(delay_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(delay_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute direct_attribute =
-	__ATTR(direct, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(direct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute full_time_attribute =
-	__ATTR(full_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(full_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute jiffy_delta_attribute =
-	__ATTR(jiffy_delta, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(jiffy_delta, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute trigger_time_attribute =
-	__ATTR(trigger_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(trigger_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 
 /*
  * Create a group of attributes so that we can create and destroy them all
diff --git a/drivers/staging/speakup/speakup_soft.c b/drivers/staging/speakup/speakup_soft.c
index 243c3d52fe5e..ee6089502a96 100644
--- a/drivers/staging/speakup/speakup_soft.c
+++ b/drivers/staging/speakup/speakup_soft.c
@@ -61,41 +61,41 @@ static struct var_t vars[] = {
  * These attributes will appear in /sys/accessibility/speakup/soft.
  */
 static struct kobj_attribute caps_start_attribute =
-	__ATTR(caps_start, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(caps_start, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute caps_stop_attribute =
-	__ATTR(caps_stop, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(caps_stop, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute freq_attribute =
-	__ATTR(freq, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(freq, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute pitch_attribute =
-	__ATTR(pitch, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(pitch, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute punct_attribute =
-	__ATTR(punct, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(punct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute rate_attribute =
-	__ATTR(rate, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(rate, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute tone_attribute =
-	__ATTR(tone, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(tone, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute voice_attribute =
-	__ATTR(voice, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(voice, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute vol_attribute =
-	__ATTR(vol, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(vol, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 
 /*
  * We should uncomment the following definition, when we agree on a
  * method of passing a language designation to the software synthesizer.
  * static struct kobj_attribute lang_attribute =
- *	__ATTR(lang, USER_RW, spk_var_show, spk_var_store);
+ *	__ATTR(lang, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
  */
 
 static struct kobj_attribute delay_time_attribute =
-	__ATTR(delay_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(delay_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute direct_attribute =
-	__ATTR(direct, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(direct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute full_time_attribute =
-	__ATTR(full_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(full_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute jiffy_delta_attribute =
-	__ATTR(jiffy_delta, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(jiffy_delta, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute trigger_time_attribute =
-	__ATTR(trigger_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(trigger_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 
 /*
  * Create a group of attributes so that we can create and destroy them all
diff --git a/drivers/staging/speakup/speakup_spkout.c b/drivers/staging/speakup/speakup_spkout.c
index e74f85620c68..711cf114df83 100644
--- a/drivers/staging/speakup/speakup_spkout.c
+++ b/drivers/staging/speakup/speakup_spkout.c
@@ -48,30 +48,30 @@ static struct var_t vars[] = {
  * These attributes will appear in /sys/accessibility/speakup/spkout.
  */
 static struct kobj_attribute caps_start_attribute =
-	__ATTR(caps_start, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(caps_start, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute caps_stop_attribute =
-	__ATTR(caps_stop, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(caps_stop, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute pitch_attribute =
-	__ATTR(pitch, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(pitch, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute punct_attribute =
-	__ATTR(punct, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(punct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute rate_attribute =
-	__ATTR(rate, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(rate, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute tone_attribute =
-	__ATTR(tone, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(tone, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute vol_attribute =
-	__ATTR(vol, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(vol, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 
 static struct kobj_attribute delay_time_attribute =
-	__ATTR(delay_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(delay_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute direct_attribute =
-	__ATTR(direct, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(direct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute full_time_attribute =
-	__ATTR(full_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(full_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute jiffy_delta_attribute =
-	__ATTR(jiffy_delta, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(jiffy_delta, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute trigger_time_attribute =
-	__ATTR(trigger_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(trigger_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 
 /*
  * Create a group of attributes so that we can create and destroy them all
diff --git a/drivers/staging/speakup/speakup_txprt.c b/drivers/staging/speakup/speakup_txprt.c
index 5a29b9fcc930..3f0be04df071 100644
--- a/drivers/staging/speakup/speakup_txprt.c
+++ b/drivers/staging/speakup/speakup_txprt.c
@@ -44,28 +44,28 @@ static struct var_t vars[] = {
  * These attributes will appear in /sys/accessibility/speakup/txprt.
  */
 static struct kobj_attribute caps_start_attribute =
-	__ATTR(caps_start, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(caps_start, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute caps_stop_attribute =
-	__ATTR(caps_stop, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(caps_stop, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute pitch_attribute =
-	__ATTR(pitch, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(pitch, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute rate_attribute =
-	__ATTR(rate, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(rate, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute tone_attribute =
-	__ATTR(tone, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(tone, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute vol_attribute =
-	__ATTR(vol, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(vol, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 
 static struct kobj_attribute delay_time_attribute =
-	__ATTR(delay_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(delay_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute direct_attribute =
-	__ATTR(direct, USER_RW, spk_var_show, spk_var_store);
+	__ATTR(direct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute full_time_attribute =
-	__ATTR(full_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(full_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute jiffy_delta_attribute =
-	__ATTR(jiffy_delta, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(jiffy_delta, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute trigger_time_attribute =
-	__ATTR(trigger_time, ROOT_W, spk_var_show, spk_var_store);
+	__ATTR(trigger_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 
 /*
  * Create a group of attributes so that we can create and destroy them all
