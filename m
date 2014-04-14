Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbaDNQu4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:50:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.131]:49157 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368AbaDNQux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:50:53 -0400
From: Oussama Ghorbel <ghorbel@pivasoftware.com>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Oussama Ghorbel <ghorbel@pivasoftware.com>
Subject: [PATCH] ARM: OMAP2+: free use_gptimer_clksrc variable after boot
Date: Mon, 14 Apr 2014 17:49:30 +0100
Message-Id: <1397494170-3111-1-git-send-email-ghorbel@pivasoftware.com>
X-Mailer: git-send-email 1.8.3.2
X-Provags-ID: V02:K0:xvqINK0ATuCCmA5NqTxgculWBE3mRUQZjckFF4ekmCh
 SYrXE5M0hvgyv7cIjcbNKjV4DKkH/yOurQLlT/PpfD1BuUT8y7
 OPm9A4qZeIajE8WwJA1m874EuQNqA9BiB8exJNwZ66T1iQNGwo
 exqz+e1mv4zgCbQxhnKKplWDy7xu9/vC2NfZPPAueNmVOluvPz
 lob4ud5vEe5duN2qbtLcpDJpI59uv8tRqLJ6vLJKnJzZ9EwKO+
 7ZGXK3/U5XRnwne1Ci3g1XV7f+ZU5/1WUVLe/S/3r/GoHwuj7R
 yhzPpTNHU9lBvxtnkvEqBLh6EGuAMnbzFdDgRvDsAETWEzrUFS
 zJl1M/IJnF8hPwFqCRTcPSgVoNQnLntfqjcxQcIml5RLh/OMZi
 QBKqN49GalMS2mVeaeB+W9omwRCXOqMj0j0Epu9umFDjnjoaDz
 PjGYB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable use_gptimer_clksrc is only used by two __init functions,
So we can freely free it after boot.

Signed-off-by: Oussama Ghorbel <ghorbel@pivasoftware.com>
---
 arch/arm/mach-omap2/timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index 74044aa..d4a6abd 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -361,7 +361,7 @@ static void __init omap2_gp_clockevent_init(int gptimer_id,
 
 /* Clocksource code */
 static struct omap_dm_timer clksrc;
-static bool use_gptimer_clksrc;
+static bool use_gptimer_clksrc __initdata;
 
 /*
  * clocksource
-- 
1.8.3.2

