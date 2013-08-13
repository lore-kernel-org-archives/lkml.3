Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780Ab3HMP6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 11:58:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13725 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758674Ab3HMP6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:58:31 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=cK38rhTS7CAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=I_AX1pvMDNYA:10 a=8b9GpE9nAAAA:8 a=J1Y8HTJGAAAA:8 a=FcIYvSPAO1LtH-puApQA:9 a=RUNXi7WdHkcA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155826.472406244@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:57:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [18/88] net: phy: fix a bug when verify the EEE support
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0018-net-phy-fix-a-bug-when-verify-the-EEE-support.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>

[ Upstream commit 9a9c56cb34e65000d1f0a4b7553399bfcf7c5a52 ]

The phy_init_eee has to exit with an error when the
local device and its link partner both do not support EEE.
So this patch fixes a problem when verify this.

Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/phy/phy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 7ca2ff9..ec95660 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -1152,7 +1152,7 @@ int phy_init_eee(struct phy_device *phydev, bool clk_stop_enable)
 		adv = phy_eee_to_adv(eee_adv);
 		lp = phy_eee_to_adv(eee_lp);
 		idx = phy_find_setting(phydev->speed, phydev->duplex);
-		if ((lp & adv & settings[idx].setting))
+		if (!(lp & adv & settings[idx].setting))
 			goto eee_exit;
 
 		if (clk_stop_enable) {
-- 
1.7.10.4


