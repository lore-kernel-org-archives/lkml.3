Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041AbaDXKSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:18:50 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:60363 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560AbaDXKNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 06:13:46 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Felipe Balbi <balbi@ti.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH/RFC 4/4] clk: shmobile: mstp: Set CLK_RUNTIME_PM flag
Date: Thu, 24 Apr 2014 12:13:23 +0200
Message-Id: <1398334403-26181-5-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398334403-26181-1-git-send-email-geert+renesas@glider.be>
References: <1398334403-26181-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Renesas MSTP (Module Stop) clocks are suitable for Runtime PM.

Hence set the CLK_RUNTIME_PM flag, to make of_clk enable automatic Runtime
PM management for DT devices that are tied to an MSTP clock.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/clk/shmobile/clk-mstp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/shmobile/clk-mstp.c b/drivers/clk/shmobile/clk-mstp.c
index 2e3c08fff173..6f860bad551e 100644
--- a/drivers/clk/shmobile/clk-mstp.c
+++ b/drivers/clk/shmobile/clk-mstp.c
@@ -139,7 +139,7 @@ cpg_mstp_clock_register(const char *name, const char *parent_name,
 
 	init.name = name;
 	init.ops = &cpg_mstp_clock_ops;
-	init.flags = CLK_IS_BASIC | CLK_SET_RATE_PARENT;
+	init.flags = CLK_IS_BASIC | CLK_SET_RATE_PARENT | CLK_RUNTIME_PM;
 	init.parent_names = &parent_name;
 	init.num_parents = 1;
 
-- 
1.7.9.5

