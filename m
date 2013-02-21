Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab3BUCbw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 21:31:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:44578 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634Ab3BUCbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 21:31:51 -0500
Message-ID: <5125873C.6080307@infradead.org>
Date: Wed, 20 Feb 2013 18:32:28 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] staging: fix all sparse warnings in silicom/bypasslib/
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix all sparse warning in drivers/staging/silicom/bypasslib/,
e.g.:


drivers/staging/silicom/bypasslib/bypass.c:471:21: warning: non-ANSI function declaration of function 'init_lib_module'
drivers/staging/silicom/bypasslib/bypass.c:478:25: warning: non-ANSI function declaration of function 'cleanup_lib_module'
drivers/staging/silicom/bypasslib/bypass.c:137:5: warning: symbol 'is_bypass_dev' was not declared. Should it be static?
drivers/staging/silicom/bypasslib/bypass.c:182:5: warning: symbol 'is_bypass' was not declared. Should it be static?
drivers/staging/silicom/bypasslib/bypass.c:192:5: warning: symbol 'get_bypass_slave' was not declared. Should it be static?
drivers/staging/silicom/bypasslib/bypass.c:197:5: warning: symbol 'get_bypass_caps' was not declared. Should it be static?
drivers/staging/silicom/bypasslib/bypass.c:202:5: warning: symbol 'get_wd_set_caps' was not declared. Should it be static?
etc.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 drivers/staging/silicom/bypasslib/bypass.c |   94 +++++++++----------
 1 file changed, 47 insertions(+), 47 deletions(-)

--- lnx-38.orig/drivers/staging/silicom/bypasslib/bypass.c
+++ lnx-38/drivers/staging/silicom/bypasslib/bypass.c
@@ -134,7 +134,7 @@ static int is_dev_sd(int if_index)
 	return (ret >= 0 ? 1 : 0);
 }
 
-int is_bypass_dev(int if_index)
+static int is_bypass_dev(int if_index)
 {
 	struct pci_dev *pdev = NULL;
 	struct net_device *dev = NULL;
@@ -179,7 +179,7 @@ int is_bypass_dev(int if_index)
 	return (ret < 0 ? -1 : ret);
 }
 
-int is_bypass(int if_index)
+static int is_bypass(int if_index)
 {
 	int ret = 0;
 	SET_BPLIB_INT_FN(is_bypass, int, if_index, ret);
@@ -189,70 +189,70 @@ int is_bypass(int if_index)
 	return ret;
 }
 
-int get_bypass_slave(int if_index)
+static int get_bypass_slave(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_bypass_slave, GET_BYPASS_SLAVE, if_index);
 }
 
-int get_bypass_caps(int if_index)
+static int get_bypass_caps(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_bypass_caps, GET_BYPASS_CAPS, if_index);
 }
 
-int get_wd_set_caps(int if_index)
+static int get_wd_set_caps(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_wd_set_caps, GET_WD_SET_CAPS, if_index);
 }
 
-int set_bypass(int if_index, int bypass_mode)
+static int set_bypass(int if_index, int bypass_mode)
 {
 	DO_BPLIB_SET_ARG_FN(set_bypass, SET_BYPASS, if_index, bypass_mode);
 }
 
-int get_bypass(int if_index)
+static int get_bypass(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_bypass, GET_BYPASS, if_index);
 }
 
-int get_bypass_change(int if_index)
+static int get_bypass_change(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_bypass_change, GET_BYPASS_CHANGE, if_index);
 }
 
-int set_dis_bypass(int if_index, int dis_bypass)
+static int set_dis_bypass(int if_index, int dis_bypass)
 {
 	DO_BPLIB_SET_ARG_FN(set_dis_bypass, SET_DIS_BYPASS, if_index,
 			    dis_bypass);
 }
 
-int get_dis_bypass(int if_index)
+static int get_dis_bypass(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_dis_bypass, GET_DIS_BYPASS, if_index);
 }
 
-int set_bypass_pwoff(int if_index, int bypass_mode)
+static int set_bypass_pwoff(int if_index, int bypass_mode)
 {
 	DO_BPLIB_SET_ARG_FN(set_bypass_pwoff, SET_BYPASS_PWOFF, if_index,
 			    bypass_mode);
 }
 
-int get_bypass_pwoff(int if_index)
+static int get_bypass_pwoff(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_bypass_pwoff, GET_BYPASS_PWOFF, if_index);
 }
 
-int set_bypass_pwup(int if_index, int bypass_mode)
+static int set_bypass_pwup(int if_index, int bypass_mode)
 {
 	DO_BPLIB_SET_ARG_FN(set_bypass_pwup, SET_BYPASS_PWUP, if_index,
 			    bypass_mode);
 }
 
-int get_bypass_pwup(int if_index)
+static int get_bypass_pwup(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_bypass_pwup, GET_BYPASS_PWUP, if_index);
 }
 
-int set_bypass_wd(int if_index, int ms_timeout, int *ms_timeout_set)
+static int set_bypass_wd(int if_index, int ms_timeout, int *ms_timeout_set)
 {
 	int data = ms_timeout, ret = 0;
 	if (is_dev_sd(if_index))
@@ -268,7 +268,7 @@ int set_bypass_wd(int if_index, int ms_t
 	return ret;
 }
 
-int get_bypass_wd(int if_index, int *ms_timeout_set)
+static int get_bypass_wd(int if_index, int *ms_timeout_set)
 {
 	int *data = ms_timeout_set, ret = 0;
 	if (is_dev_sd(if_index))
@@ -279,7 +279,7 @@ int get_bypass_wd(int if_index, int *ms_
 	return ret;
 }
 
-int get_wd_expire_time(int if_index, int *ms_time_left)
+static int get_wd_expire_time(int if_index, int *ms_time_left)
 {
 	int *data = ms_time_left, ret = 0;
 	if (is_dev_sd(if_index))
@@ -293,144 +293,144 @@ int get_wd_expire_time(int if_index, int
 	return ret;
 }
 
-int reset_bypass_wd_timer(int if_index)
+static int reset_bypass_wd_timer(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(reset_bypass_wd_timer, RESET_BYPASS_WD_TIMER,
 			    if_index);
 }
 
-int set_std_nic(int if_index, int bypass_mode)
+static int set_std_nic(int if_index, int bypass_mode)
 {
 	DO_BPLIB_SET_ARG_FN(set_std_nic, SET_STD_NIC, if_index, bypass_mode);
 }
 
-int get_std_nic(int if_index)
+static int get_std_nic(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_std_nic, GET_STD_NIC, if_index);
 }
 
-int set_tx(int if_index, int tx_state)
+static int set_tx(int if_index, int tx_state)
 {
 	DO_BPLIB_SET_ARG_FN(set_tx, SET_TX, if_index, tx_state);
 }
 
-int get_tx(int if_index)
+static int get_tx(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_tx, GET_TX, if_index);
 }
 
-int set_tap(int if_index, int tap_mode)
+static int set_tap(int if_index, int tap_mode)
 {
 	DO_BPLIB_SET_ARG_FN(set_tap, SET_TAP, if_index, tap_mode);
 }
 
-int get_tap(int if_index)
+static int get_tap(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_tap, GET_TAP, if_index);
 }
 
-int get_tap_change(int if_index)
+static int get_tap_change(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_tap_change, GET_TAP_CHANGE, if_index);
 }
 
-int set_dis_tap(int if_index, int dis_tap)
+static int set_dis_tap(int if_index, int dis_tap)
 {
 	DO_BPLIB_SET_ARG_FN(set_dis_tap, SET_DIS_TAP, if_index, dis_tap);
 }
 
-int get_dis_tap(int if_index)
+static int get_dis_tap(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_dis_tap, GET_DIS_TAP, if_index);
 }
 
-int set_tap_pwup(int if_index, int tap_mode)
+static int set_tap_pwup(int if_index, int tap_mode)
 {
 	DO_BPLIB_SET_ARG_FN(set_tap_pwup, SET_TAP_PWUP, if_index, tap_mode);
 }
 
-int get_tap_pwup(int if_index)
+static int get_tap_pwup(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_tap_pwup, GET_TAP_PWUP, if_index);
 }
 
-int set_bp_disc(int if_index, int disc_mode)
+static int set_bp_disc(int if_index, int disc_mode)
 {
 	DO_BPLIB_SET_ARG_FN(set_bp_disc, SET_DISC, if_index, disc_mode);
 }
 
-int get_bp_disc(int if_index)
+static int get_bp_disc(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_bp_disc, GET_DISC, if_index);
 }
 
-int get_bp_disc_change(int if_index)
+static int get_bp_disc_change(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_bp_disc_change, GET_DISC_CHANGE, if_index);
 }
 
-int set_bp_dis_disc(int if_index, int dis_disc)
+static int set_bp_dis_disc(int if_index, int dis_disc)
 {
 	DO_BPLIB_SET_ARG_FN(set_bp_dis_disc, SET_DIS_DISC, if_index, dis_disc);
 }
 
-int get_bp_dis_disc(int if_index)
+static int get_bp_dis_disc(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_bp_dis_disc, GET_DIS_DISC, if_index);
 }
 
-int set_bp_disc_pwup(int if_index, int disc_mode)
+static int set_bp_disc_pwup(int if_index, int disc_mode)
 {
 	DO_BPLIB_SET_ARG_FN(set_bp_disc_pwup, SET_DISC_PWUP, if_index,
 			    disc_mode);
 }
 
-int get_bp_disc_pwup(int if_index)
+static int get_bp_disc_pwup(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_bp_disc_pwup, GET_DISC_PWUP, if_index);
 }
 
-int set_wd_exp_mode(int if_index, int mode)
+static int set_wd_exp_mode(int if_index, int mode)
 {
 	DO_BPLIB_SET_ARG_FN(set_wd_exp_mode, SET_WD_EXP_MODE, if_index, mode);
 }
 
-int get_wd_exp_mode(int if_index)
+static int get_wd_exp_mode(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_wd_exp_mode, GET_WD_EXP_MODE, if_index);
 }
 
-int set_wd_autoreset(int if_index, int time)
+static int set_wd_autoreset(int if_index, int time)
 {
 	DO_BPLIB_SET_ARG_FN(set_wd_autoreset, SET_WD_AUTORESET, if_index, time);
 }
 
-int get_wd_autoreset(int if_index)
+static int get_wd_autoreset(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_wd_autoreset, GET_WD_AUTORESET, if_index);
 }
 
-int set_tpl(int if_index, int tpl_mode)
+static int set_tpl(int if_index, int tpl_mode)
 {
 	DO_BPLIB_SET_ARG_FN(set_tpl, SET_TPL, if_index, tpl_mode);
 }
 
-int get_tpl(int if_index)
+static int get_tpl(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_tpl, GET_TPL, if_index);
 }
 
-int set_bp_hw_reset(int if_index, int mode)
+static int set_bp_hw_reset(int if_index, int mode)
 {
 	DO_BPLIB_SET_ARG_FN(set_tpl, SET_BP_HW_RESET, if_index, mode);
 }
 
-int get_bp_hw_reset(int if_index)
+static int get_bp_hw_reset(int if_index)
 {
 	DO_BPLIB_GET_ARG_FN(get_tpl, GET_BP_HW_RESET, if_index);
 }
 
-int get_bypass_info(int if_index, struct bp_info *bp_info)
+static int get_bypass_info(int if_index, struct bp_info *bp_info)
 {
 	int ret = 0;
 	if (is_dev_sd(if_index)) {
@@ -468,14 +468,14 @@ int get_bypass_info(int if_index, struct
 	return ret;
 }
 
-int init_lib_module()
+int init_lib_module(void)
 {
 
 	printk(VERSION);
 	return 0;
 }
 
-void cleanup_lib_module()
+void cleanup_lib_module(void)
 {
 }
 
