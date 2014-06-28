Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311AbaF1LYX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 07:24:23 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:63166 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751427AbaF1LYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 07:24:22 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkUHALOkrlNbsk2v/2dsb2JhbABagw2regUBAQEBAQEFAW0BmQKBBxd1hGAjVkQ3iEYBxRoXhWSJIR2ELQWaXYs/iDyCAIFEOy8B
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH 1/1] drivers/staging/rtl8821ae/rtl8821ae/hal_btc.c: remove unnecessary null test before kfree
Date: Sat, 28 Jun 2014 13:22:59 +0200
Message-Id: <1403954579-1927-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning:
WARNING: kfree(NULL) is safe this check is probably not required

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: devel@driverdev.osuosl.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/staging/rtl8821ae/rtl8821ae/hal_btc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8821ae/rtl8821ae/hal_btc.c b/drivers/staging/rtl8821ae/rtl8821ae/hal_btc.c
index 7b1d113..d8e05c8 100644
--- a/drivers/staging/rtl8821ae/rtl8821ae/hal_btc.c
+++ b/drivers/staging/rtl8821ae/rtl8821ae/hal_btc.c
@@ -2059,8 +2059,7 @@ void rtl_8821ae_c2h_command_handle(struct ieee80211_hw *hw)
 		break;
 	}
 
-	if(ptmp_buf)
-		kfree(ptmp_buf);
+	kfree(ptmp_buf);
 
 	rtl_write_byte(rtlpriv, 0x01AF, C2H_EVT_HOST_CLOSE);
 }
-- 
1.8.4.5

