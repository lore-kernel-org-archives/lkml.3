Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091AbaDFXlV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 19:41:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59436 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754673AbaDFXjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 19:39:06 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org
Date: Mon, 07 Apr 2014 00:35:48 +0100
Message-ID: <lsq.1396827348.741115479@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 03/18] staging: speakup: Prefix set_mask_bits() symbol
In-Reply-To: <lsq.1396827347.462803115@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.2.102
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.57-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

This is part of commit ca2beaf84d96 ('staging: speakup: Prefix
externally-visible symbols') upstream.  It is required as preparation
for commit 00a1a053ebe5 ('ext4: atomically set inode->i_flags in
ext4_set_inode_flags()').

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/staging/speakup/kobjects.c
+++ b/drivers/staging/speakup/kobjects.c
@@ -521,9 +521,9 @@ static ssize_t punc_store(struct kobject
 	spk_lock(flags);
 
 	if (*punc_buf == 'd' || *punc_buf == 'r')
-		x = set_mask_bits(0, var->value, 3);
+		x = spk_set_mask_bits(0, var->value, 3);
 	else
-		x = set_mask_bits(punc_buf, var->value, 3);
+		x = spk_set_mask_bits(punc_buf, var->value, 3);
 
 	spk_unlock(flags);
 	return count;
--- a/drivers/staging/speakup/main.c
+++ b/drivers/staging/speakup/main.c
@@ -2265,7 +2265,7 @@ static int __init speakup_init(void)
 	     (var->var_id >= 0) && (var->var_id < MAXVARS); var++)
 		speakup_register_var(var);
 	for (i = 1; punc_info[i].mask != 0; i++)
-		set_mask_bits(0, i, 2);
+		spk_set_mask_bits(0, i, 2);
 
 	set_key_info(key_defaults, key_buf);
 	if (quiet_boot)
--- a/drivers/staging/speakup/speakup.h
+++ b/drivers/staging/speakup/speakup.h
@@ -71,7 +71,7 @@ extern struct st_var_header *var_header_
 extern struct punc_var_t *get_punc_var(enum var_id_t var_id);
 extern int set_num_var(int val, struct st_var_header *var, int how);
 extern int set_string_var(const char *page, struct st_var_header *var, int len);
-extern int set_mask_bits(const char *input, const int which, const int how);
+extern int spk_set_mask_bits(const char *input, const int which, const int how);
 extern special_func special_handler;
 extern int handle_help(struct vc_data *vc, u_char type, u_char ch, u_short key);
 extern int synth_init(char *name);
--- a/drivers/staging/speakup/varhandlers.c
+++ b/drivers/staging/speakup/varhandlers.c
@@ -267,11 +267,11 @@ int set_string_var(const char *page, str
 	return ret;
 }
 
-/* set_mask_bits sets or clears the punc/delim/repeat bits,
+/* spk_set_mask_bits sets or clears the punc/delim/repeat bits,
  * if input is null uses the defaults.
  * values for how: 0 clears bits of chars supplied,
  * 1 clears allk, 2 sets bits for chars */
-int set_mask_bits(const char *input, const int which, const int how)
+int spk_set_mask_bits(const char *input, const int which, const int how)
 {
 	u_char *cp;
 	short mask = punc_info[which].mask;

