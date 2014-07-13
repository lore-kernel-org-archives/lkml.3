Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbaGMVy5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 17:54:57 -0400
Received: from hermes.sybcom.net ([213.147.0.30]:40547 "EHLO hermes.sybcom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043AbaGMVyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 17:54:52 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Jul 2014 17:54:51 EDT
X-Spam-Check-By: hermes.sybcom.net
From: "Joerg C. Meyer" <joerg@meyer.homedns.org>
To: gregkh@linuxfoundation.org, chenweilong@huawei.com, davem@davemloft.net,
        sachin.kamat@linaro.org, dingtianhong@huawei.com,
        joerg@meyer.homedns.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: rtl8821ae: fix coding style issues in cam.c Fix all coding style error and warnings in cam.c reported by checkpatch.pl
Date: Sun, 13 Jul 2014 23:47:57 +0200
Message-Id: <1405288077-25513-1-git-send-email-joerg@meyer.homedns.org>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg C. Meyer <joerg@meyer.homedns.org>
---
 drivers/staging/rtl8821ae/cam.c | 57 +++++++++++++++++++----------------------
 1 file changed, 27 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/rtl8821ae/cam.c b/drivers/staging/rtl8821ae/cam.c
index 3bc6b3d..835bc3b 100644
--- a/drivers/staging/rtl8821ae/cam.c
+++ b/drivers/staging/rtl8821ae/cam.c
@@ -68,12 +68,12 @@ static void rtl_cam_program_entry(struct ieee80211_hw *hw, u32 entry_no,
 					target_command);
 
 			RT_TRACE(COMP_SEC, DBG_LOUD,
-				 ("WRITE %x: %x \n",
+				 ("WRITE %x: %x\n",
 				  rtlpriv->cfg->maps[WCAMI], target_content));
 			RT_TRACE(COMP_SEC, DBG_LOUD,
 				 ("The Key ID is %d\n", entry_no));
 			RT_TRACE(COMP_SEC, DBG_LOUD,
-				 ("WRITE %x: %x \n",
+				 ("WRITE %x: %x\n",
 				  rtlpriv->cfg->maps[RWCAM], target_command));
 
 		} else if (entry_i == 1) {
@@ -89,9 +89,9 @@ static void rtl_cam_program_entry(struct ieee80211_hw *hw, u32 entry_no,
 					target_command);
 
 			RT_TRACE(COMP_SEC, DBG_LOUD,
-				 ("WRITE A4: %x \n", target_content));
+				 ("WRITE A4: %x\n", target_content));
 			RT_TRACE(COMP_SEC, DBG_LOUD,
-				 ("WRITE A0: %x \n", target_command));
+				 ("WRITE A0: %x\n", target_command));
 
 		} else {
 
@@ -109,9 +109,9 @@ static void rtl_cam_program_entry(struct ieee80211_hw *hw, u32 entry_no,
 			udelay(100);
 
 			RT_TRACE(COMP_SEC, DBG_LOUD,
-				 ("WRITE A4: %x \n", target_content));
+				 ("WRITE A4: %x\n", target_content));
 			RT_TRACE(COMP_SEC, DBG_LOUD,
-				 ("WRITE A0: %x \n", target_command));
+				 ("WRITE A0: %x\n", target_command));
 		}
 	}
 
@@ -127,8 +127,7 @@ u8 rtl_cam_add_one_entry(struct ieee80211_hw *hw, u8 *mac_addr,
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
 	RT_TRACE(COMP_SEC, DBG_DMESG,
-		 ("EntryNo:%x, ulKeyId=%x, ulEncAlg=%x, "
-		  "ulUseDK=%x MacAddr %pM\n",
+	("EntryNo:%x, ulKeyId=%x, ulEncAlg=%x, ulUseDK=%x MacAddr %pM\n",
 		  ul_entry_idx, ul_key_id, ul_enc_alg,
 		  ul_default_key, mac_addr));
 
@@ -138,21 +137,20 @@ u8 rtl_cam_add_one_entry(struct ieee80211_hw *hw, u8 *mac_addr,
 		return 0;
 	}
 
-	if (ul_default_key == 1) {
+	if (ul_default_key == 1)
 		us_config = CFG_VALID | ((u16) (ul_enc_alg) << 2);
-	} else {
+	else
 		us_config = CFG_VALID | ((ul_enc_alg) << 2) | ul_key_id;
-	}
 
 	rtl_cam_program_entry(hw, ul_entry_idx, mac_addr,
 			      (u8 *) key_content, us_config);
 
-	RT_TRACE(COMP_SEC, DBG_DMESG, ("end \n"));
+	RT_TRACE(COMP_SEC, DBG_DMESG, ("end\n"));
 
 	return 1;
 
 }
-//EXPORT_SYMBOL(rtl_cam_add_one_entry);
+/* EXPORT_SYMBOL(rtl_cam_add_one_entry); */
 
 int rtl_cam_delete_one_entry(struct ieee80211_hw *hw,
 			     u8 *mac_addr, u32 ul_key_id)
@@ -169,14 +167,14 @@ int rtl_cam_delete_one_entry(struct ieee80211_hw *hw,
 	rtl_write_dword(rtlpriv, rtlpriv->cfg->maps[RWCAM], ul_command);
 
 	RT_TRACE(COMP_SEC, DBG_DMESG,
-		 ("rtl_cam_delete_one_entry(): WRITE A4: %x \n", 0));
+		 ("rtl_cam_delete_one_entry(): WRITE A4: %x\n", 0));
 	RT_TRACE(COMP_SEC, DBG_DMESG,
-		 ("rtl_cam_delete_one_entry(): WRITE A0: %x \n", ul_command));
+		 ("rtl_cam_delete_one_entry(): WRITE A0: %x\n", ul_command));
 
 	return 0;
 
 }
-//EXPORT_SYMBOL(rtl_cam_delete_one_entry);
+/* EXPORT_SYMBOL(rtl_cam_delete_one_entry); */
 
 void rtl_cam_reset_all_entry(struct ieee80211_hw *hw)
 {
@@ -186,7 +184,7 @@ void rtl_cam_reset_all_entry(struct ieee80211_hw *hw)
 	ul_command = BIT(31) | BIT(30);
 	rtl_write_dword(rtlpriv, rtlpriv->cfg->maps[RWCAM], ul_command);
 }
-//EXPORT_SYMBOL(rtl_cam_reset_all_entry);
+/* EXPORT_SYMBOL(rtl_cam_reset_all_entry); */
 
 void rtl_cam_mark_invalid(struct ieee80211_hw *hw, u8 uc_index)
 {
@@ -223,11 +221,11 @@ void rtl_cam_mark_invalid(struct ieee80211_hw *hw, u8 uc_index)
 	rtl_write_dword(rtlpriv, rtlpriv->cfg->maps[RWCAM], ul_command);
 
 	RT_TRACE(COMP_SEC, DBG_DMESG,
-		 ("rtl_cam_mark_invalid(): WRITE A4: %x \n", ul_content));
+		 ("rtl_cam_mark_invalid(): WRITE A4: %x\n", ul_content));
 	RT_TRACE(COMP_SEC, DBG_DMESG,
-		 ("rtl_cam_mark_invalid(): WRITE A0: %x \n", ul_command));
+		 ("rtl_cam_mark_invalid(): WRITE A0: %x\n", ul_command));
 }
-//EXPORT_SYMBOL(rtl_cam_mark_invalid);
+/* EXPORT_SYMBOL(rtl_cam_mark_invalid); */
 
 void rtl_cam_empty_entry(struct ieee80211_hw *hw, u8 uc_index)
 {
@@ -273,15 +271,15 @@ void rtl_cam_empty_entry(struct ieee80211_hw *hw, u8 uc_index)
 		rtl_write_dword(rtlpriv, rtlpriv->cfg->maps[RWCAM], ul_command);
 
 		RT_TRACE(COMP_SEC, DBG_LOUD,
-			 ("rtl_cam_empty_entry(): WRITE A4: %x \n",
+			 ("rtl_cam_empty_entry(): WRITE A4: %x\n",
 			  ul_content));
 		RT_TRACE(COMP_SEC, DBG_LOUD,
-			 ("rtl_cam_empty_entry(): WRITE A0: %x \n",
+			 ("rtl_cam_empty_entry(): WRITE A0: %x\n",
 			  ul_command));
 	}
 
 }
-//EXPORT_SYMBOL(rtl_cam_empty_entry);
+/* EXPORT_SYMBOL(rtl_cam_empty_entry); */
 
 u8 rtl_cam_get_free_entry(struct ieee80211_hw *hw, u8 *sta_addr)
 {
@@ -298,7 +296,7 @@ u8 rtl_cam_get_free_entry(struct ieee80211_hw *hw, u8 *sta_addr)
 	/* Does STA already exist? */
 	for (i = 4; i < TOTAL_CAM_ENTRY; i++) {
 		addr = rtlpriv->sec.hwsec_cam_sta_addr[i];
-		if(memcmp(addr, sta_addr, ETH_ALEN) == 0)
+		if (memcmp(addr, sta_addr, ETH_ALEN) == 0)
 			return i;
 	}
 	/* Get a free CAM entry. */
@@ -312,11 +310,11 @@ u8 rtl_cam_get_free_entry(struct ieee80211_hw *hw, u8 *sta_addr)
 			       sta_addr, ETH_ALEN);
 			return entry_idx;
 		}
-		bitmap = bitmap >>1;
+		bitmap = bitmap>>1;
 	}
 	return TOTAL_CAM_ENTRY;
 }
-//EXPORT_SYMBOL(rtl_cam_get_free_entry);
+/* EXPORT_SYMBOL(rtl_cam_get_free_entry); */
 
 void rtl_cam_del_entry(struct ieee80211_hw *hw, u8 *sta_addr)
 {
@@ -329,7 +327,7 @@ void rtl_cam_del_entry(struct ieee80211_hw *hw, u8 *sta_addr)
 			("sta_addr is NULL.\n"));
 	}
 
-	if ((sta_addr[0]|sta_addr[1]|sta_addr[2]|sta_addr[3]|\
+	if ((sta_addr[0]|sta_addr[1]|sta_addr[2]|sta_addr[3]|
 				sta_addr[4]|sta_addr[5]) == 0) {
 		RT_TRACE(COMP_SEC, DBG_EMERG,
 			("sta_addr is 00:00:00:00:00:00.\n"));
@@ -344,9 +342,8 @@ void rtl_cam_del_entry(struct ieee80211_hw *hw, u8 *sta_addr)
 			/* Remove from HW Security CAM */
 			memset(rtlpriv->sec.hwsec_cam_sta_addr[i], 0, ETH_ALEN);
 			rtlpriv->sec.hwsec_cam_bitmap &= ~(BIT(0) << i);
-			printk("&&&&&&&&&del entry %d\n",i);
+			pr_info("&&&&&&&&&del entry %d\n", i);
 		}
 	}
-	return;
 }
-//EXPORT_SYMBOL(rtl_cam_del_entry);
+/* EXPORT_SYMBOL(rtl_cam_del_entry); */
-- 
2.0.1

