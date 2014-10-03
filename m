Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759911AbaJCXTx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:19:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46742 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757826AbaJCWNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:13:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nishanth Menon <nm@ti.com>, Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 3.16 347/357] clk: ti: dra7-atl: Provide error check for incoming parameters in set_rate
Date: Fri,  3 Oct 2014 14:32:13 -0700
Message-Id: <20141003212943.880414471@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nishanth Menon <nm@ti.com>

commit 20411dad75ece9a613af715df4489e60990c4017 upstream.

Check for valid parameters in check rate. Else, we end up getting
errors.

This occurs as part of the inital clock tree update of child clock
nodes where new_rate could be 0 for non functional clocks.

Fixes: 9ac33b0ce81fa48 (" CLK: TI: Driver for DRA7 ATL (Audio Tracking Logic)")
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Tero Kristo <t-kristo@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/ti/clk-dra7-atl.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/clk/ti/clk-dra7-atl.c
+++ b/drivers/clk/ti/clk-dra7-atl.c
@@ -139,9 +139,13 @@ static long atl_clk_round_rate(struct cl
 static int atl_clk_set_rate(struct clk_hw *hw, unsigned long rate,
 			    unsigned long parent_rate)
 {
-	struct dra7_atl_desc *cdesc = to_atl_desc(hw);
+	struct dra7_atl_desc *cdesc;
 	u32 divider;
 
+	if (!hw || !rate)
+		return -EINVAL;
+
+	cdesc = to_atl_desc(hw);
 	divider = ((parent_rate + rate / 2) / rate) - 1;
 	if (divider > DRA7_ATL_DIVIDER_MASK)
 		divider = DRA7_ATL_DIVIDER_MASK;


