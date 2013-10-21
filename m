Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab3JUJLJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:11:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39670 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754009Ab3JUIwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:52:01 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Larry Finger" <Larry.Finger@lwfinger.net>,
        "Jason Andrews" <jasona@cadence.com>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.860738344@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 090/149] rtlwifi: Align private space in rtl_priv struct
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/rtlwifi/wifi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -1630,7 +1630,7 @@ struct rtl_priv {
 	   that it points to the data allocated
 	   beyond  this structure like:
 	   rtl_pci_priv or rtl_usb_priv */
-	u8 priv[0];
+	u8 priv[0] __aligned(sizeof(void *));
 };
 
 #define rtl_priv(hw)		(((struct rtl_priv *)(hw)->priv))

