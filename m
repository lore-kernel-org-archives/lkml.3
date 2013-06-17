Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab3FQALy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 20:11:54 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:57043 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab3FQALw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 20:11:52 -0400
From: Chad Williamson <chad@dahc.us>
To: gregkh@linuxfoundation.org
Cc: puff65537@bansheeslibrary.com, viro@zeniv.linux.org.uk,
        tulinizer@gmail.com, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chad Williamson <chad@dahc.us>
Subject: [PATCH 2/3] Staging: silicom: move symbol exports beneath definitions in bypass.c
Date: Sun, 16 Jun 2013 19:05:24 -0500
Message-Id: <1371427525-6007-3-git-send-email-chad@dahc.us>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1371427525-6007-1-git-send-email-chad@dahc.us>
References: <1371427525-6007-1-git-send-email-chad@dahc.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the EXPORT_SYMBOL macros in bypass.c beneath the definitions
they refer to, resolving checkpatch.pl warnings. While we're at it, use
EXPORT_SYMBOL rather than EXPORT_SYMBOL_NOVERS.

Signed-off-by: Chad Williamson <chad@dahc.us>
---
 drivers/staging/silicom/bypasslib/bypass.c | 89 +++++++++++++++---------------
 1 file changed, 44 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/silicom/bypasslib/bypass.c b/drivers/staging/silicom/bypasslib/bypass.c
index 9ed2508..ba0d23a 100644
--- a/drivers/staging/silicom/bypasslib/bypass.c
+++ b/drivers/staging/silicom/bypasslib/bypass.c
@@ -188,69 +188,82 @@ static int is_bypass(int if_index)
 		return is_bypass_dev(if_index);
 	return ret;
 }
+EXPORT_SYMBOL(is_bypass);
 
 static int get_bypass_slave(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_bypass_slave, GET_BYPASS_SLAVE, if_index);
 }
+EXPORT_SYMBOL(get_bypass_slave);
 
 static int get_bypass_caps(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_bypass_caps, GET_BYPASS_CAPS, if_index);
 }
+EXPORT_SYMBOL(get_bypass_caps);
 
 static int get_wd_set_caps(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_wd_set_caps, GET_WD_SET_CAPS, if_index);
 }
+EXPORT_SYMBOL(get_wd_set_caps);
 
 static int set_bypass(int if_index, int bypass_mode)
 {
 	DO_BPLIB_SET_ARG_FN(set_bypass, SET_BYPASS, if_index, bypass_mode);
 }
+EXPORT_SYMBOL(set_bypass);
 
 static int get_bypass(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_bypass, GET_BYPASS, if_index);
 }
+EXPORT_SYMBOL(get_bypass);
 
 static int get_bypass_change(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_bypass_change, GET_BYPASS_CHANGE, if_index);
 }
+EXPORT_SYMBOL(get_bypass_change);
 
 static int set_dis_bypass(int if_index, int dis_bypass)
 {
 	DO_BPLIB_SET_ARG_FN(set_dis_bypass, SET_DIS_BYPASS, if_index,
 			    dis_bypass);
 }
+EXPORT_SYMBOL(set_dis_bypass);
 
 static int get_dis_bypass(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_dis_bypass, GET_DIS_BYPASS, if_index);
 }
+EXPORT_SYMBOL(get_dis_bypass);
 
 static int set_bypass_pwoff(int if_index, int bypass_mode)
 {
 	DO_BPLIB_SET_ARG_FN(set_bypass_pwoff, SET_BYPASS_PWOFF, if_index,
 			    bypass_mode);
 }
+EXPORT_SYMBOL(set_bypass_pwoff);
 
 static int get_bypass_pwoff(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_bypass_pwoff, GET_BYPASS_PWOFF, if_index);
 }
+EXPORT_SYMBOL(get_bypass_pwoff);
 
 static int set_bypass_pwup(int if_index, int bypass_mode)
 {
 	DO_BPLIB_SET_ARG_FN(set_bypass_pwup, SET_BYPASS_PWUP, if_index,
 			    bypass_mode);
 }
+EXPORT_SYMBOL(set_bypass_pwup);
 
 static int get_bypass_pwup(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_bypass_pwup, GET_BYPASS_PWUP, if_index);
 }
+EXPORT_SYMBOL(get_bypass_pwup);
 
 static int set_bypass_wd(int if_index, int ms_timeout, int *ms_timeout_set)
 {
@@ -267,6 +280,7 @@ static int set_bypass_wd(int if_index, int ms_timeout, int *ms_timeout_set)
 	}
 	return ret;
 }
+EXPORT_SYMBOL(set_bypass_wd);
 
 static int get_bypass_wd(int if_index, int *ms_timeout_set)
 {
@@ -278,6 +292,7 @@ static int get_bypass_wd(int if_index, int *ms_timeout_set)
 		ret = doit(GET_BYPASS_WD, if_index, data);
 	return ret;
 }
+EXPORT_SYMBOL(get_bypass_wd);
 
 static int get_wd_expire_time(int if_index, int *ms_time_left)
 {
@@ -292,143 +307,171 @@ static int get_wd_expire_time(int if_index, int *ms_time_left)
 	}
 	return ret;
 }
+EXPORT_SYMBOL(get_wd_expire_time);
 
 static int reset_bypass_wd_timer(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(reset_bypass_wd_timer, RESET_BYPASS_WD_TIMER,
 			    if_index);
 }
+EXPORT_SYMBOL(reset_bypass_wd_timer);
 
 static int set_std_nic(int if_index, int bypass_mode)
 {
 	DO_BPLIB_SET_ARG_FN(set_std_nic, SET_STD_NIC, if_index, bypass_mode);
 }
+EXPORT_SYMBOL(set_std_nic);
 
 static int get_std_nic(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_std_nic, GET_STD_NIC, if_index);
 }
+EXPORT_SYMBOL(get_std_nic);
 
 static int set_tx(int if_index, int tx_state)
 {
 	DO_BPLIB_SET_ARG_FN(set_tx, SET_TX, if_index, tx_state);
 }
+EXPORT_SYMBOL(set_tx);
 
 static int get_tx(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_tx, GET_TX, if_index);
 }
+EXPORT_SYMBOL(get_tx);
 
 static int set_tap(int if_index, int tap_mode)
 {
 	DO_BPLIB_SET_ARG_FN(set_tap, SET_TAP, if_index, tap_mode);
 }
+EXPORT_SYMBOL(set_tap);
 
 static int get_tap(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_tap, GET_TAP, if_index);
 }
+EXPORT_SYMBOL(get_tap);
 
 static int get_tap_change(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_tap_change, GET_TAP_CHANGE, if_index);
 }
+EXPORT_SYMBOL(get_tap_change);
 
 static int set_dis_tap(int if_index, int dis_tap)
 {
 	DO_BPLIB_SET_ARG_FN(set_dis_tap, SET_DIS_TAP, if_index, dis_tap);
 }
+EXPORT_SYMBOL(set_dis_tap);
 
 static int get_dis_tap(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_dis_tap, GET_DIS_TAP, if_index);
 }
+EXPORT_SYMBOL(get_dis_tap);
 
 static int set_tap_pwup(int if_index, int tap_mode)
 {
 	DO_BPLIB_SET_ARG_FN(set_tap_pwup, SET_TAP_PWUP, if_index, tap_mode);
 }
+EXPORT_SYMBOL(set_tap_pwup);
 
 static int get_tap_pwup(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_tap_pwup, GET_TAP_PWUP, if_index);
 }
+EXPORT_SYMBOL(get_tap_pwup);
 
 static int set_bp_disc(int if_index, int disc_mode)
 {
 	DO_BPLIB_SET_ARG_FN(set_bp_disc, SET_DISC, if_index, disc_mode);
 }
+EXPORT_SYMBOL(set_bp_disc);
 
 static int get_bp_disc(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_bp_disc, GET_DISC, if_index);
 }
+EXPORT_SYMBOL(get_bp_disc);
 
 static int get_bp_disc_change(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_bp_disc_change, GET_DISC_CHANGE, if_index);
 }
+EXPORT_SYMBOL(get_bp_disc_change);
 
 static int set_bp_dis_disc(int if_index, int dis_disc)
 {
 	DO_BPLIB_SET_ARG_FN(set_bp_dis_disc, SET_DIS_DISC, if_index, dis_disc);
 }
+EXPORT_SYMBOL(set_bp_dis_disc);
 
 static int get_bp_dis_disc(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_bp_dis_disc, GET_DIS_DISC, if_index);
 }
+EXPORT_SYMBOL(get_bp_dis_disc);
 
 static int set_bp_disc_pwup(int if_index, int disc_mode)
 {
 	DO_BPLIB_SET_ARG_FN(set_bp_disc_pwup, SET_DISC_PWUP, if_index,
 			    disc_mode);
 }
+EXPORT_SYMBOL(set_bp_disc_pwup);
 
 static int get_bp_disc_pwup(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_bp_disc_pwup, GET_DISC_PWUP, if_index);
 }
+EXPORT_SYMBOL(get_bp_disc_pwup);
 
 static int set_wd_exp_mode(int if_index, int mode)
 {
 	DO_BPLIB_SET_ARG_FN(set_wd_exp_mode, SET_WD_EXP_MODE, if_index, mode);
 }
+EXPORT_SYMBOL(set_wd_exp_mode);
 
 static int get_wd_exp_mode(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_wd_exp_mode, GET_WD_EXP_MODE, if_index);
 }
+EXPORT_SYMBOL(get_wd_exp_mode);
 
 static int set_wd_autoreset(int if_index, int time)
 {
 	DO_BPLIB_SET_ARG_FN(set_wd_autoreset, SET_WD_AUTORESET, if_index, time);
 }
+EXPORT_SYMBOL(set_wd_autoreset);
 
 static int get_wd_autoreset(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_wd_autoreset, GET_WD_AUTORESET, if_index);
 }
+EXPORT_SYMBOL(get_wd_autoreset);
 
 static int set_tpl(int if_index, int tpl_mode)
 {
 	DO_BPLIB_SET_ARG_FN(set_tpl, SET_TPL, if_index, tpl_mode);
 }
+EXPORT_SYMBOL(set_tpl);
 
 static int get_tpl(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_tpl, GET_TPL, if_index);
 }
+EXPORT_SYMBOL(get_tpl);
 
 static int set_bp_hw_reset(int if_index, int mode)
 {
 	DO_BPLIB_SET_ARG_FN(set_tpl, SET_BP_HW_RESET, if_index, mode);
 }
+EXPORT_SYMBOL(set_bp_hw_reset);
 
 static int get_bp_hw_reset(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_tpl, GET_BP_HW_RESET, if_index);
 }
+EXPORT_SYMBOL(get_bp_hw_reset);
 
 static int get_bypass_info(int if_index, struct bp_info *bp_info)
 {
@@ -467,6 +510,7 @@ static int get_bypass_info(int if_index, struct bp_info *bp_info)
 	}
 	return ret;
 }
+EXPORT_SYMBOL(get_bypass_info);
 
 int init_lib_module(void)
 {
@@ -479,50 +523,5 @@ void cleanup_lib_module(void)
 {
 }
 
-EXPORT_SYMBOL_NOVERS(is_bypass);
-EXPORT_SYMBOL_NOVERS(get_bypass_slave);
-EXPORT_SYMBOL_NOVERS(get_bypass_caps);
-EXPORT_SYMBOL_NOVERS(get_wd_set_caps);
-EXPORT_SYMBOL_NOVERS(set_bypass);
-EXPORT_SYMBOL_NOVERS(get_bypass);
-EXPORT_SYMBOL_NOVERS(get_bypass_change);
-EXPORT_SYMBOL_NOVERS(set_dis_bypass);
-EXPORT_SYMBOL_NOVERS(get_dis_bypass);
-EXPORT_SYMBOL_NOVERS(set_bypass_pwoff);
-EXPORT_SYMBOL_NOVERS(get_bypass_pwoff);
-EXPORT_SYMBOL_NOVERS(set_bypass_pwup);
-EXPORT_SYMBOL_NOVERS(get_bypass_pwup);
-EXPORT_SYMBOL_NOVERS(set_bypass_wd);
-EXPORT_SYMBOL_NOVERS(get_bypass_wd);
-EXPORT_SYMBOL_NOVERS(get_wd_expire_time);
-EXPORT_SYMBOL_NOVERS(reset_bypass_wd_timer);
-EXPORT_SYMBOL_NOVERS(set_std_nic);
-EXPORT_SYMBOL_NOVERS(get_std_nic);
-EXPORT_SYMBOL_NOVERS(set_tx);
-EXPORT_SYMBOL_NOVERS(get_tx);
-EXPORT_SYMBOL_NOVERS(set_tap);
-EXPORT_SYMBOL_NOVERS(get_tap);
-EXPORT_SYMBOL_NOVERS(get_tap_change);
-EXPORT_SYMBOL_NOVERS(set_dis_tap);
-EXPORT_SYMBOL_NOVERS(get_dis_tap);
-EXPORT_SYMBOL_NOVERS(set_tap_pwup);
-EXPORT_SYMBOL_NOVERS(get_tap_pwup);
-EXPORT_SYMBOL_NOVERS(set_bp_disc);
-EXPORT_SYMBOL_NOVERS(get_bp_disc);
-EXPORT_SYMBOL_NOVERS(get_bp_disc_change);
-EXPORT_SYMBOL_NOVERS(set_bp_dis_disc);
-EXPORT_SYMBOL_NOVERS(get_bp_dis_disc);
-EXPORT_SYMBOL_NOVERS(set_bp_disc_pwup);
-EXPORT_SYMBOL_NOVERS(get_bp_disc_pwup);
-EXPORT_SYMBOL_NOVERS(set_wd_exp_mode);
-EXPORT_SYMBOL_NOVERS(get_wd_exp_mode);
-EXPORT_SYMBOL_NOVERS(set_wd_autoreset);
-EXPORT_SYMBOL_NOVERS(get_wd_autoreset);
-EXPORT_SYMBOL_NOVERS(set_tpl);
-EXPORT_SYMBOL_NOVERS(get_tpl);
-EXPORT_SYMBOL_NOVERS(set_bp_hw_reset);
-EXPORT_SYMBOL_NOVERS(get_bp_hw_reset);
-EXPORT_SYMBOL_NOVERS(get_bypass_info);
-
 module_init(init_lib_module);
 module_exit(cleanup_lib_module);
-- 
1.8.1.4

