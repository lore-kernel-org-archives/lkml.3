Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758642AbbA0MTW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:19:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35264 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932402AbbA0MTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:19:05 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gary Bisson <bisson.gary@gmail.com>, Shawn Guo <shawn.guo@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 080/126] ARM: clk-imx6q: fix video divider for rev T0 1.0
Date: Tue, 27 Jan 2015 12:16:25 +0000
Message-Id: <1422361031-19364-81-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gary Bisson <bisson.gary@gmail.com>

commit 81ef447950bf0955aca46f4a7617d8ce435cf0ce upstream.

The post dividers do not work on i.MX6Q rev T0 1.0 so they must be fixed
to 1. As the table index was wrong, a divider a of 4 could still be
requested which implied the clock not to be set properly. This is the
root cause of the HDMI not working at high resolution on rev T0 1.0 of
the SoC.

Signed-off-by: Gary Bisson <bisson.gary@gmail.com>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-imx/clk-imx6q.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/clk-imx6q.c b/arch/arm/mach-imx/clk-imx6q.c
index e9f8dbc360f6..3433b10ca968 100644
--- a/arch/arm/mach-imx/clk-imx6q.c
+++ b/arch/arm/mach-imx/clk-imx6q.c
@@ -163,7 +163,7 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
 		post_div_table[1].div = 1;
 		post_div_table[2].div = 1;
 		video_div_table[1].div = 1;
-		video_div_table[2].div = 1;
+		video_div_table[3].div = 1;
 	}
 
 	/*                   type                               name         parent_name  base     div_mask */
-- 
2.1.4

