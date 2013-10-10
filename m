Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab3JJPqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:46:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52730 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586Ab3JJPqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:46:34 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 086/104] rtlwifi: Align private space in rtl_priv struct
Date: Thu, 10 Oct 2013 08:42:14 -0700
Message-Id: <1381419752-29733-87-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 60ce314d1750fef843e9db70050e09e49f838b69 upstream.

The private array at the end of the rtl_priv struct is not aligned.
On ARM architecture, this causes an alignment trap and is fixed by aligning
that array with __align(sizeof(void *)). That should properly align that
space according to the requirements of all architectures.

Reported-by: Jason Andrews <jasona@cadence.com>
Tested-by: Jason Andrews <jasona@cadence.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/rtlwifi/wifi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index 21a5f4f..a382f95 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -1871,7 +1871,7 @@ struct rtl_priv {
 	   that it points to the data allocated
 	   beyond  this structure like:
 	   rtl_pci_priv or rtl_usb_priv */
-	u8 priv[0];
+	u8 priv[0] __aligned(sizeof(void *));
 };
 
 #define rtl_priv(hw)		(((struct rtl_priv *)(hw)->priv))
-- 
1.8.1.2

