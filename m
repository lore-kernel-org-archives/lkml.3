Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275AbbA2JBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:01:15 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752923AbbA2JBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:01:09 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Gary Bisson <bisson.gary@gmail.com>,
        Shawn Guo <shawn.guo@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 123/176] ARM: clk-imx6q: fix video divider for rev T0 1.0
Date: Wed, 28 Jan 2015 15:29:13 +0100
Message-Id: <9b6e9d212a6dc2b585060df6948b7591d2396ca3.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gary Bisson <bisson.gary@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 81ef447950bf0955aca46f4a7617d8ce435cf0ce upstream.

The post dividers do not work on i.MX6Q rev T0 1.0 so they must be fixed
to 1. As the table index was wrong, a divider a of 4 could still be
requested which implied the clock not to be set properly. This is the
root cause of the HDMI not working at high resolution on rev T0 1.0 of
the SoC.

Signed-off-by: Gary Bisson <bisson.gary@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm/mach-imx/clk-imx6q.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/clk-imx6q.c b/arch/arm/mach-imx/clk-imx6q.c
index 689f0cfd9795..2eed3cf8a36f 100644
--- a/arch/arm/mach-imx/clk-imx6q.c
+++ b/arch/arm/mach-imx/clk-imx6q.c
@@ -304,7 +304,7 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
 		post_div_table[1].div = 1;
 		post_div_table[2].div = 1;
 		video_div_table[1].div = 1;
-		video_div_table[2].div = 1;
+		video_div_table[3].div = 1;
 	}
 
 	/*                   type                               name         parent_name  base     div_mask */
-- 
2.2.2

