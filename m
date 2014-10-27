Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbaJ0TJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:09:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52861 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658AbaJ0TEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:04:25 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ludovic Desroches <ludovic.desroches@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 044/105] ARM: at91/PMC: don't forget to write PMC_PCDR register to disable clocks
Date: Mon, 27 Oct 2014 11:56:19 -0700
Message-Id: <1414436240-13879-45-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ludovic Desroches <ludovic.desroches@atmel.com>

commit cfa1950e6c6b72251e80adc736af3c3d2907ab0e upstream.

When introducing support for sama5d3, the write to PMC_PCDR register has
been accidentally removed.

Reported-by: Nathalie Cyrille <nathalie.cyrille@atmel.com>
Signed-off-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/mach-at91/clock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-at91/clock.c b/arch/arm/mach-at91/clock.c
index 6b2630a..0778e54 100644
--- a/arch/arm/mach-at91/clock.c
+++ b/arch/arm/mach-at91/clock.c
@@ -963,6 +963,7 @@ static int __init at91_clock_reset(void)
 	}
 
 	at91_pmc_write(AT91_PMC_SCDR, scdr);
+	at91_pmc_write(AT91_PMC_PCDR, pcdr);
 	if (cpu_is_sama5d3())
 		at91_pmc_write(AT91_PMC_PCDR1, pcdr1);
 
-- 
1.9.1

