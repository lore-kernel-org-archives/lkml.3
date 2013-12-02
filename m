Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab3LBTRA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:17:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38974 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab3LBTQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:16:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Markus Pargmann <mpa@pengutronix.de>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 3.12 002/212] ARM: OMAP2+: irq, AM33XX add missing register check
Date: Mon,  2 Dec 2013 11:13:13 -0800
Message-Id: <20131202191248.841300457@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Pargmann <mpa@pengutronix.de>

commit 0bebda684857f76548ea48c8886785198701d8d3 upstream.

am33xx has a INTC_PENDING_IRQ3 register that is not checked for pending
interrupts. This patch adds AM33XX to the ifdef of SOCs that have to
check this register.

Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-omap2/irq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-omap2/irq.c
+++ b/arch/arm/mach-omap2/irq.c
@@ -233,7 +233,7 @@ static inline void omap_intc_handle_irq(
 			goto out;
 
 		irqnr = readl_relaxed(base_addr + 0xd8);
-#ifdef CONFIG_SOC_TI81XX
+#if IS_ENABLED(CONFIG_SOC_TI81XX) || IS_ENABLED(CONFIG_SOC_AM33XX)
 		if (irqnr)
 			goto out;
 		irqnr = readl_relaxed(base_addr + 0xf8);


