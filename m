Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324Ab3LBURA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:17:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39150 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab3LBTR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:17:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.12 048/212] rtlwifi: rtl8188ee: Fix smatch warning in rtl8188ee/hw.c
Date: Mon,  2 Dec 2013 11:13:59 -0800
Message-Id: <20131202191253.615483271@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit dab3df5e88b979f8d09860f873ccfaa7a55758d2 upstream.

Smatch lists the following:
  CHECK   drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
drivers/net/wireless/rtlwifi/rtl8188ee/hw.c:149 _rtl88ee_set_fw_clock_on() info: ignoring unreachable code.
drivers/net/wireless/rtlwifi/rtl8188ee/hw.c:149 _rtl88ee_set_fw_clock_on() info: ignoring unreachable code.

This info message is the result of a real error due to a missing break statement
in a "while (1)" loop.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rtlwifi/rtl8188ee/hw.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
@@ -143,6 +143,7 @@ static void _rtl88ee_set_fw_clock_on(str
 		} else {
 			rtlhal->fw_clk_change_in_progress = false;
 			spin_unlock_bh(&rtlpriv->locks.fw_ps_lock);
+			break;
 		}
 	}
 


