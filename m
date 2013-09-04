Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762497Ab3IDXpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 19:45:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762188Ab3IDXpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 19:45:51 -0400
Date: Wed, 4 Sep 2013 19:45:39 -0400
From: Dave Jones <davej@redhat.com>
To: Larry.Finger@lwfinger.net
Cc: gregkh@linuxfoundation.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: staging/rtl8188eu: pass channel list by reference instead of copying
 struct.
Message-ID: <20130904234539.GA11208@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Larry.Finger@lwfinger.net,
	gregkh@linuxfoundation.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
index 8b2ba26..4b2eb8e 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
@@ -1827,13 +1827,13 @@ unsigned int OnAction_back(struct adapter *padapter, union recv_frame *precv_fra
 
 #ifdef CONFIG_88EU_P2P
 
-static int get_reg_classes_full_count(struct p2p_channels channel_list)
+static int get_reg_classes_full_count(struct p2p_channels *channel_list)
 {
 	int cnt = 0;
 	int i;
 
-	for (i = 0; i < channel_list.reg_classes; i++) {
-		cnt += channel_list.reg_class[i].channels;
+	for (i = 0; i < channel_list->reg_classes; i++) {
+		cnt += channel_list->reg_class[i].channels;
 	}
 
 	return cnt;
@@ -2065,7 +2065,7 @@ void issue_p2p_GO_request(struct adapter *padapter, u8 *raddr)
 	/*  + number of channels in all classes */
 	len_channellist_attr = 3
 	   + (1 + 1) * (u16)(pmlmeext->channel_list.reg_classes)
-	   + get_reg_classes_full_count(pmlmeext->channel_list);
+	   + get_reg_classes_full_count(&pmlmeext->channel_list);
 
 	*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(len_channellist_attr);
 	p2pielen += 2;
@@ -2437,7 +2437,7 @@ static void issue_p2p_GO_response(struct adapter *padapter, u8 *raddr, u8 *frame
 	/*  + number of channels in all classes */
 	len_channellist_attr = 3
 	   + (1 + 1) * (u16)pmlmeext->channel_list.reg_classes
-	   + get_reg_classes_full_count(pmlmeext->channel_list);
+	   + get_reg_classes_full_count(&pmlmeext->channel_list);
 
 	*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(len_channellist_attr);
 
@@ -2859,7 +2859,7 @@ void issue_p2p_invitation_request(struct adapter *padapter, u8 *raddr)
 	/*  + number of channels in all classes */
 	len_channellist_attr = 3
 	   + (1 + 1) * (u16)pmlmeext->channel_list.reg_classes
-	   + get_reg_classes_full_count(pmlmeext->channel_list);
+	   + get_reg_classes_full_count(&pmlmeext->channel_list);
 
 	*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(len_channellist_attr);
 
@@ -3120,7 +3120,7 @@ void issue_p2p_invitation_response(struct adapter *padapter, u8 *raddr, u8 dialo
 		/*  + number of channels in all classes */
 		len_channellist_attr = 3
 			+ (1 + 1) * (u16)pmlmeext->channel_list.reg_classes
-			+ get_reg_classes_full_count(pmlmeext->channel_list);
+			+ get_reg_classes_full_count(&pmlmeext->channel_list);
 
 		*(__le16 *)(p2pie + p2pielen) = cpu_to_le16(len_channellist_attr);
 		p2pielen += 2;
