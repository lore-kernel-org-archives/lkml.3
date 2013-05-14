Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160Ab3ENRVI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 13:21:08 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:38997 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971Ab3ENRVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 13:21:06 -0400
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Vincent=20Stehl=C3=A9?= <v-stehle@ti.com>,
        trivial@kernel.org
Subject: [PATCH, v2] ARM: omap2: gpmc: fix compilation warning
Date: Tue, 14 May 2013 19:20:43 +0200
Message-Id: <1368552043-3764-1-git-send-email-vincent.stehle@laposte.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20130508222639.GM32546@atomide.com>
References: <20130508222639.GM32546@atomide.com>
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

Tony wrote:
> You should just change the format for dev_err instead of the casting.

Hi,

Sorry for the late answer; it seems this is a bit more complicated after all,
as res.start can be 32b or 64b in LPAE. The common solution seems to be: cast
to long long in all cases and print accordingly. Would you like this better?

Best regards,

V.


 arch/arm/mach-omap2/gpmc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index 6c4da12..e74501e 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -1473,8 +1473,8 @@ static int gpmc_probe_generic_child(struct platform_device *pdev,
 	 */
 	ret = gpmc_cs_remap(cs, res.start);
 	if (ret < 0) {
-		dev_err(&pdev->dev, "cannot remap GPMC CS %d to 0x%x\n",
-			cs, res.start);
+		dev_err(&pdev->dev, "cannot remap GPMC CS %d to 0x%llx\n",
+			cs, (long long)res.start);
 		goto err;
 	}
 
-- 
1.7.10.4

