Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab3DWVXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 17:23:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:65227 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071Ab3DWVXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:23:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Subject: [PATCH] ARM: OMAP: remove unused variable
Date: Tue, 23 Apr 2013 23:23:27 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Tony Lindgren <tony@atomide.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-sh@vger.kernel.org
References: <1363818875-15978-1-git-send-email-robherring2@gmail.com>
In-Reply-To: <1363818875-15978-1-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304232323.27751.arnd@arndb.de>
X-Provags-ID: V02:K0:5ZCZFPk4rPW3/cuLiC3KWgTZ6AFQKJFESBqRuDQGF4O
 VYBh+FoogR5Ge89petYWQkUo798KikET2Vj6jNIBYJ05CnhSh+
 R1DqBeRy8RMMYT9fewxkDJ0p1iaL/vhr0cwUMVk+HUTnTDX+dU
 pb13/9lsfA5VoTemSyRySnFDm4LMTZD4ELHEHXcvwPM8Is+lex
 bWoP9kWzwTMeCL1qlRzapl3l4bNTZ/Jcc5igqz4sFP1xyrtRJU
 GdjjJhG4jbvGHqfhTZOrGCVga1N+XE6cuiFOyy1Qmu4vwSD63X
 fX9Ng1z19zcMe1DP3u+8T2djxGoeiJPIcSOorcwX8QjbQg895l
 sOfE++aTxHLiCHBDYQak=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM: OMAP: remove unused variable
    
Commit 0583fe478a7 "ARM: convert arm/arm64 arch timer to use CLKSRC_OF init"
has left the omap5_realtime_timer_init() function with a stale variable and
broken whitespace. This fixes both.
    
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
I've applied this patch on top of the timer cleanup series

diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index 7dd6453..686e498 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -618,12 +618,10 @@ OMAP_SYS_32K_TIMER_INIT(5, 1, OMAP4_32K_SOURCE, "ti,timer-alwon",
 			2, OMAP4_MPU_SOURCE);
 void __init omap5_realtime_timer_init(void)
 {
-	int err;
-
 	omap5_sync32k_timer_init();
 	realtime_counter_init();
 
-        clocksource_of_init();
+	clocksource_of_init();
 }
 #endif /* CONFIG_SOC_OMAP5 */
 
