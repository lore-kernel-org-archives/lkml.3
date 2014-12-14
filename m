Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbaLNUl4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:41:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53359 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163AbaLNUbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:31:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Catalin Iacob <iacobcatalin@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.18 12/19] rtlwifi: rtl8192ce: Fix editing error that causes silent memory corruption
Date: Sun, 14 Dec 2014 12:21:23 -0800
Message-Id: <20141214201823.893758998@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141214201823.543296369@linuxfoundation.org>
References: <20141214201823.543296369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 99a82f734aa6c6d397e029e6dfa933f04e0fa8c8 upstream.

In the major update of the rtlwifi-family of drivers, there was an editing
mistake. Unfortunately, this particular error leads to memory corruption that
silently leads to failure of the system. This patch is one of three needed to
fix the kernel regression reported at https://bugzilla.kernel.org/show_bug.cgi?id=88951.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported-by: Catalin Iacob <iacobcatalin@gmail.com>
Tested-by: Catalin Iacob <iacobcatalin@gmail.com>
Cc: Catalin Iacob <iacobcatalin@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
@@ -720,16 +720,15 @@ u32 rtl92ce_get_desc(u8 *p_desc, bool is
 			break;
 		}
 	} else {
-		struct rx_desc_92c *pdesc = (struct rx_desc_92c *)p_desc;
 		switch (desc_name) {
 		case HW_DESC_OWN:
-			ret = GET_RX_DESC_OWN(pdesc);
+			ret = GET_RX_DESC_OWN(p_desc);
 			break;
 		case HW_DESC_RXPKT_LEN:
-			ret = GET_RX_DESC_PKT_LEN(pdesc);
+			ret = GET_RX_DESC_PKT_LEN(p_desc);
 			break;
 		case HW_DESC_RXBUFF_ADDR:
-			ret = GET_RX_STATUS_DESC_BUFF_ADDR(pdesc);
+			ret = GET_RX_DESC_BUFF_ADDR(p_desc);
 			break;
 		default:
 			RT_ASSERT(false, "ERR rxdesc :%d not process\n",


