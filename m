Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbaJTNlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 09:41:35 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:65445 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbaJTNlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 09:41:23 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Manuel Lauss <manuel.lauss@gmail.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/8] MIPS: Alchemy: Remove direct access to prepare_count field of struct clk
Date: Mon, 20 Oct 2014 15:40:01 +0200
Message-Id: <1413812442-24956-2-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413812442-24956-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1413812442-24956-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing it with a call to __clk_is_prepared(), which isn't entirely
equivalent but in practice shouldn't matter.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/mips/alchemy/common/clock.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/mips/alchemy/common/clock.c b/arch/mips/alchemy/common/clock.c
index d7557cd..203e440 100644
--- a/arch/mips/alchemy/common/clock.c
+++ b/arch/mips/alchemy/common/clock.c
@@ -37,7 +37,6 @@
 #include <linux/io.h>
 #include <linux/clk-provider.h>
 #include <linux/clkdev.h>
-#include <linux/clk-private.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/types.h>
@@ -397,10 +396,10 @@ static long alchemy_clk_fgcs_detr(struct clk_hw *hw, unsigned long rate,
 			break;
 
 		/* if this parent is currently unused, remember it.
-		 * XXX: I know it's a layering violation, but it works
-		 * so well.. (if (!clk_has_active_children(pc)) )
+		 * XXX: we would actually want clk_has_active_children()
+		 * but this is a good-enough approximation for now.
 		 */
-		if (pc->prepare_count == 0) {
+		if (!__clk_is_prepared(pc)) {
 			if (!free)
 				free = pc;
 		}
-- 
1.9.3

