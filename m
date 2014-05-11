Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933681AbaEKTZA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:25:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48346 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932725AbaEKTYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:24:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Colin Ian King <colin.king@canonical.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.10 36/48] rtlwifi: rtl8188ee: initialize packet_beacon
Date: Sun, 11 May 2014 21:20:10 +0200
Message-Id: <20140511191953.028650844@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191948.079900414@linuxfoundation.org>
References: <20140511191948.079900414@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.king@canonical.com>

commit 328e203fc35f0b4f6df1c4943f74cf553bcc04f8 upstream.

static code analysis from cppcheck reports:

[drivers/net/wireless/rtlwifi/rtl8188ee/trx.c:322]:
  (error) Uninitialized variable: packet_beacon

packet_beacon is not initialized and hence packet_beacon
contains garbage from the stack, so set it to false.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rtlwifi/rtl8188ee/trx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/rtlwifi/rtl8188ee/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/trx.c
@@ -293,7 +293,7 @@ static void _rtl88ee_translate_rx_signal
 	u8 *psaddr;
 	__le16 fc;
 	u16 type, ufc;
-	bool match_bssid, packet_toself, packet_beacon, addr;
+	bool match_bssid, packet_toself, packet_beacon = false, addr;
 
 	tmp_buf = skb->data + pstatus->rx_drvinfo_size + pstatus->rx_bufshift;
 


