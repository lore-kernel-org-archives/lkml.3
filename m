Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751276AbaEQTXs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 15:23:48 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:62693 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbaEQTXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 15:23:46 -0400
From: Konrad Zapalowicz <bergo.torino@gmail.com>
To: gregkh@linuxfoundation.org
Cc: standby24x7@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Konrad Zapalowicz <bergo.torino@gmail.com>
Subject: [PATCH 2/2] staging: rtl8821ae: fix not declared symbols should be static in sw.c
Date: Sat, 17 May 2014 21:23:38 +0200
Message-Id: <1400354618-13471-3-git-send-email-bergo.torino@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1400354618-13471-2-git-send-email-bergo.torino@gmail.com>
References: <1400354618-13471-1-git-send-email-bergo.torino@gmail.com>
 <1400354618-13471-2-git-send-email-bergo.torino@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit fixes the following sparse warnings:

drivers/staging/rtl8821ae/rtl8821ae/sw.c:
    - 48:6: warning: symbol 'rtl8821ae_init_aspm_vars' was not declared.
      Should it be static?
    - 228:5: warning: symbol 'rtl8812ae_rx_command_packet_handler' was
      not declared. Should it be static?
    - 263:20: warning: symbol 'rtl8821ae_hal_ops' was not declared.
      Should it be static?
    - 314:23: warning: symbol 'rtl8821ae_mod_params' was not declared.
      Should it be static?
    - 321:20: warning: symbol 'rtl8821ae_hal_cfg' was not declared.
      Should it be static?

All of this symbols are local, that is there are no references to them
in the other files from this driver.

Signed-off-by: Konrad Zapalowicz <bergo.torino@gmail.com>
---
 drivers/staging/rtl8821ae/rtl8821ae/sw.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8821ae/rtl8821ae/sw.c b/drivers/staging/rtl8821ae/rtl8821ae/sw.c
index c24d426..e90806e 100644
--- a/drivers/staging/rtl8821ae/rtl8821ae/sw.c
+++ b/drivers/staging/rtl8821ae/rtl8821ae/sw.c
@@ -45,7 +45,7 @@
 #include "hal_btc.h"
 #include "../btcoexist/rtl_btc.h"
 
-void rtl8821ae_init_aspm_vars(struct ieee80211_hw *hw)
+static void rtl8821ae_init_aspm_vars(struct ieee80211_hw *hw)
 {
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 
@@ -225,7 +225,7 @@ void rtl8821ae_deinit_sw_vars(struct ieee80211_hw *hw)
 	//printk("<=========rtl8821ae_deinit_sw_vars().\n");
 }
 
-u32 rtl8812ae_rx_command_packet_handler(
+static u32 rtl8812ae_rx_command_packet_handler(
 	struct ieee80211_hw *hw,
 	struct rtl_stats status,
 	struct sk_buff *skb
@@ -260,7 +260,7 @@ bool rtl8821ae_get_btc_status(void)
 	return true;
 }
 
-struct rtl_hal_ops rtl8821ae_hal_ops = {
+static struct rtl_hal_ops rtl8821ae_hal_ops = {
 	.init_sw_vars = rtl8821ae_init_sw_vars,
 	.deinit_sw_vars = rtl8821ae_deinit_sw_vars,
 	.read_eeprom_info = rtl8821ae_read_eeprom_info,
@@ -311,14 +311,14 @@ struct rtl_hal_ops rtl8821ae_hal_ops = {
 	.rx_command_packet_handler = rtl8812ae_rx_command_packet_handler,
 };
 
-struct rtl_mod_params rtl8821ae_mod_params = {
+static struct rtl_mod_params rtl8821ae_mod_params = {
 	.sw_crypto = false,
 	.b_inactiveps = false,//true,
 	.b_swctrl_lps = false,
 	.b_fwctrl_lps = false, //true,
 };
 
-struct rtl_hal_cfg rtl8821ae_hal_cfg = {
+static struct rtl_hal_cfg rtl8821ae_hal_cfg = {
 	.bar_id = 2,
 	.write_readback = true,
 	.name = "rtl8821ae_pci",
-- 
1.8.1.2

