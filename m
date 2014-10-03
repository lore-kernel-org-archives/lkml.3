Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141AbaJCWRs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:17:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47163 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758071AbaJCWQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:16:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH 3.14 238/238] clk: qcom: mdp_lut_clk is a child of mdp_src
Date: Fri,  3 Oct 2014 14:32:33 -0700
Message-Id: <20141003212921.284991732@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Boyd <sboyd@codeaurora.org>

commit f87dfcabc6f173cc811d185d33327f50a8c88399 upstream.

The mdp_lut_clk isn't a child of the mdp_clk. Instead it's the
child of the mdp_src clock. Fix it.

Fixes: 6d00b56fe "clk: qcom: Add support for MSM8960's multimedia clock controller (MMCC)"
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/qcom/mmcc-msm8960.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/qcom/mmcc-msm8960.c
+++ b/drivers/clk/qcom/mmcc-msm8960.c
@@ -1116,7 +1116,7 @@ static struct clk_branch mdp_lut_clk = {
 		.enable_reg = 0x016c,
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
-			.parent_names = (const char *[]){ "mdp_clk" },
+			.parent_names = (const char *[]){ "mdp_src" },
 			.num_parents = 1,
 			.name = "mdp_lut_clk",
 			.ops = &clk_branch_ops,


