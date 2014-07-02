Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460AbaGBQwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:52:25 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:51069 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757329AbaGBQwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:52:20 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 24/48] staging: rtl8188eu: rtw_cmd.h: Remove unused structures
Date: Wed,  2 Jul 2014 22:17:20 +0530
Message-Id: <1404319664-8327-24-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/rtw_cmd.h |  216 ---------------------------
 1 file changed, 216 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index 0803742..b8adc05 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -113,27 +113,6 @@ enum RFINTFS {
 };
 
 /*
-Caller Mode: Infra, Ad-HoC(C)
-
-Notes: To enter USB suspend mode
-
-Command Mode
-
-*/
-struct usb_suspend_parm {
-	u32 action;/*  1: sleep, 0:resume */
-};
-
-/*
-Caller Mode: Infra, Ad-HoC
-
-Notes: To join a known BSS.
-
-Command-Event Mode
-
-*/
-
-/*
 Caller Mode: Infra, Ad-Hoc
 
 Notes: To join the specified bss
@@ -321,10 +300,6 @@ struct getbasicrate_parm {
 	u32 rsvd;
 };
 
-struct getbasicrate_rsp {
-	u8 basicrates[NumRates];
-};
-
 /*
 Caller Mode: Any
 
@@ -376,11 +351,6 @@ struct	getphyinfo_parm {
 	u32 rsvd;
 };
 
-struct	getphyinfo_rsp {
-	struct regulatory_class class_sets[NUM_REGULATORYS];
-	u8	status;
-};
-
 /*
 Caller Mode: Any
 
@@ -407,45 +377,6 @@ struct	getphy_parm {
 	u32 rsvd;
 
 };
-struct	getphy_rsp {
-	u8	rfchannel;
-	u8	modem;
-};
-
-struct readBB_parm {
-	u8	offset;
-};
-struct readBB_rsp {
-	u8	value;
-};
-
-struct readTSSI_parm {
-	u8	offset;
-};
-struct readTSSI_rsp {
-	u8	value;
-};
-
-struct writeBB_parm {
-	u8	offset;
-	u8	value;
-};
-
-struct readRF_parm {
-	u8	offset;
-};
-struct readRF_rsp {
-	u32	value;
-};
-
-struct writeRF_parm {
-	u32	offset;
-	u32	value;
-};
-
-struct getrfintfs_parm {
-	u8	rfintfs;
-};
 
 struct Tx_Beacon_param {
 	struct wlan_bssid_ex network;
@@ -509,153 +440,6 @@ struct drvextra_cmd_parm {
 	unsigned char *pbuf;
 };
 
-/*------------------- Below are used for RF/BB tunning ---------------------*/
-
-struct	setantenna_parm {
-	u8	tx_antset;
-	u8	rx_antset;
-	u8	tx_antenna;
-	u8	rx_antenna;
-};
-
-struct	enrateadaptive_parm {
-	u32	en;
-};
-
-struct settxagctbl_parm {
-	u32	txagc[MAX_RATES_LENGTH];
-};
-
-struct gettxagctbl_parm {
-	u32 rsvd;
-};
-struct gettxagctbl_rsp {
-	u32	txagc[MAX_RATES_LENGTH];
-};
-
-struct setagcctrl_parm {
-	u32	agcctrl;		/*  0: pure hw, 1: fw */
-};
-
-struct setssup_parm	{
-	u32	ss_ForceUp[MAX_RATES_LENGTH];
-};
-
-struct getssup_parm	{
-	u32 rsvd;
-};
-
-struct getssup_rsp	{
-	u8	ss_ForceUp[MAX_RATES_LENGTH];
-};
-
-struct setssdlevel_parm	{
-	u8	ss_DLevel[MAX_RATES_LENGTH];
-};
-
-struct getssdlevel_parm	{
-	u32 rsvd;
-};
-
-struct getssdlevel_rsp	{
-	u8	ss_DLevel[MAX_RATES_LENGTH];
-};
-
-struct setssulevel_parm	{
-	u8	ss_ULevel[MAX_RATES_LENGTH];
-};
-
-struct getssulevel_parm	{
-	u32 rsvd;
-};
-
-struct getssulevel_rsp	{
-	u8	ss_ULevel[MAX_RATES_LENGTH];
-};
-
-struct	setcountjudge_parm {
-	u8	count_judge[MAX_RATES_LENGTH];
-};
-
-struct	getcountjudge_parm {
-	u32 rsvd;
-};
-
-struct	getcountjudge_rsp {
-	u8	count_judge[MAX_RATES_LENGTH];
-};
-
-struct getratable_parm {
-	uint rsvd;
-};
-
-/* to get TX,RX retry count */
-
-struct gettxretrycnt_parm {
-	unsigned int rsvd;
-};
-
-struct gettxretrycnt_rsp {
-	unsigned long tx_retrycnt;
-};
-
-struct getrxretrycnt_parm {
-	unsigned int rsvd;
-};
-
-struct getrxretrycnt_rsp {
-	unsigned long rx_retrycnt;
-};
-
-/* to get BCNOK,BCNERR count */
-struct getbcnokcnt_parm {
-	unsigned int rsvd;
-};
-
-struct getbcnokcnt_rsp {
-	unsigned long  bcnokcnt;
-};
-
-struct getbcnerrcnt_parm {
-	unsigned int rsvd;
-};
-
-struct getbcnerrcnt_rsp {
-	unsigned long bcnerrcnt;
-};
-
-/*  to get current TX power level */
-struct getcurtxpwrlevel_parm {
-	unsigned int rsvd;
-};
-struct getcurtxpwrlevel_rspi {
-	unsigned short tx_power;
-};
-
-struct setprobereqextraie_parm {
-	unsigned char e_id;
-	unsigned char ie_len;
-	unsigned char ie[0];
-};
-
-struct setassocreqextraie_parm {
-	unsigned char e_id;
-	unsigned char ie_len;
-	unsigned char ie[0];
-};
-
-struct setproberspextraie_parm {
-	unsigned char e_id;
-	unsigned char ie_len;
-	unsigned char ie[0];
-};
-
-struct setassocrspextraie_parm {
-	unsigned char e_id;
-	unsigned char ie_len;
-	unsigned char ie[0];
-};
-
 struct addBaReq_parm {
 	unsigned int tid;
 	u8	addr[ETH_ALEN];
-- 
1.7.10.4

