Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbaCRCkz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 22:40:55 -0400
Received: from nasmtp01.atmel.com ([192.199.1.245]:34836 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753287AbaCRCky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 22:40:54 -0400
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <linux@maxim.org.za>, <nicolas.ferre@atmel.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <wenyou.yang@atmel.com>
Subject: [PATCH 1/3] ARM: at91: pm: add the socs support the DDRC controller
Date: Tue, 18 Mar 2014 10:33:55 +0800
Message-ID: <1395110037-23151-2-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1395110037-23151-1-git-send-email-wenyou.yang@atmel.com>
References: <1395110037-23151-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

socs: at91sam9x5, at91sam9n12, sama5d3

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 arch/arm/mach-at91/pm.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 8bda1ce..7280d09 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -238,7 +238,10 @@ static int at91_pm_enter(suspend_state_t state)
 
 				if (cpu_is_at91rm9200())
 					memctrl = AT91_MEMCTRL_MC;
-				else if (cpu_is_at91sam9g45())
+				else if (cpu_is_at91sam9g45()
+					|| cpu_is_at91sam9x5()
+					|| cpu_is_at91sam9n12()
+					|| cpu_is_sama5d3())
 					memctrl = AT91_MEMCTRL_DDRSDR;
 #ifdef CONFIG_AT91_SLOW_CLOCK
 				/* copy slow_clock handler to SRAM, and call it */
-- 
1.7.9.5

