Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab3EFPjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 11:39:25 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:41581 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210Ab3EFPjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 11:39:23 -0400
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Vincent=20Stehl=C3=A9?= <v-stehle@ti.com>,
        trivial@kernel.org
Subject: [PATCH] ARM: omap2: gpmc: fix compilation warning
Date: Mon,  6 May 2013 17:38:49 +0200
Message-Id: <1367854729-11416-1-git-send-email-vincent.stehle@laposte.net>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vincent Stehlé <v-stehle@ti.com>

Fix the following compilation warning:

  arch/arm/mach-omap2/gpmc.c: In function 'gpmc_probe_generic_child':
  arch/arm/mach-omap2/gpmc.c:1477:4: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'resource_size_t' [-Wformat]

Signed-off-by: Vincent Stehlé <v-stehle@ti.com>
Cc: trivial@kernel.org
---

(This is a resend.)

 arch/arm/mach-omap2/gpmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index ed946df..3cd7074 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -1474,7 +1474,7 @@ static int gpmc_probe_generic_child(struct platform_device *pdev,
 	ret = gpmc_cs_remap(cs, res.start);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "cannot remap GPMC CS %d to 0x%x\n",
-			cs, res.start);
+			cs, (unsigned)res.start);
 		goto err;
 	}
 
-- 
1.7.10.4

