Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbaGHA3n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:29:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55919 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117AbaGGXyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 3.14 78/94] clk: qcom: Fix clk_rcg2_is_enabled() check
Date: Mon,  7 Jul 2014 16:58:08 -0700
Message-Id: <20140707235759.077421906@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235756.780319003@linuxfoundation.org>
References: <20140707235756.780319003@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Boyd <sboyd@codeaurora.org>

commit aa014149ba002155a084ec1e9328e95b70167cbb upstream.

If the bit is set the clock is off so we should be checking for
a clear bit, not a set bit. Invert the logic.

Fixes: bcd61c0f535a (clk: qcom: Add support for root clock generators (RCGs))
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/qcom/clk-rcg2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -55,7 +55,7 @@ static int clk_rcg2_is_enabled(struct cl
 	if (ret)
 		return ret;
 
-	return (cmd & CMD_ROOT_OFF) != 0;
+	return (cmd & CMD_ROOT_OFF) == 0;
 }
 
 static u8 clk_rcg2_get_parent(struct clk_hw *hw)


