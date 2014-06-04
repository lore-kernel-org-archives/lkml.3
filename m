Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbaFDXk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:40:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40789 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960AbaFDXXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:23:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.10 050/103] rtl8192cu: Fix unbalanced irq enable in error path of rtl92cu_hw_init()
Date: Wed,  4 Jun 2014 16:25:13 -0700
Message-Id: <20140604232548.459932457@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232546.704156131@linuxfoundation.org>
References: <20140604232546.704156131@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 3234f5b06fc3094176a86772cc64baf3decc98fc upstream.

Fixes: a53268be0cb9 ('rtlwifi: rtl8192cu: Fix too long disable of IRQs')
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -1001,7 +1001,7 @@ int rtl92cu_hw_init(struct ieee80211_hw
 	err = _rtl92cu_init_mac(hw);
 	if (err) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "init mac failed!\n");
-		return err;
+		goto exit;
 	}
 	err = rtl92c_download_fw(hw);
 	if (err) {


