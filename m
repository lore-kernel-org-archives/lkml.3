Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845Ab3JKLvh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 07:51:37 -0400
Received: from mo1.mail-out.ovh.net ([178.32.228.1]:41919 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab3JKLvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 07:51:35 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Josh Wu <josh.wu@atmel.com>, Richard Genoud <richard.genoud@gmail.com>
Cc: Boris BREZILLON <b.brezillon@overkiz.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Subject: [PATCH v4 17/17] ARM: at91: add new compatible strings for pmc driver
Date: Fri, 11 Oct 2013 13:49:10 +0200
Message-Id: <1381492150-14842-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381477081-6041-1-git-send-email-b.brezillon@overkiz.com>
References: <1381477081-6041-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 16564239431526349024
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrvdefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrvdefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new compatible string for PMC node to prepare the
transition to common clk.

These compatible string come from pmc driver in clk subsystem and are
needed to provide new device tree compatibility with old at91 clks
(device tree using common clks will use the new compatible strings).

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/clock.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/mach-at91/clock.c b/arch/arm/mach-at91/clock.c
index 5f02aea..72b2579 100644
--- a/arch/arm/mach-at91/clock.c
+++ b/arch/arm/mach-at91/clock.c
@@ -884,6 +884,11 @@ static int __init at91_pmc_init(unsigned long main_clock)
 #if defined(CONFIG_OF)
 static struct of_device_id pmc_ids[] = {
 	{ .compatible = "atmel,at91rm9200-pmc" },
+	{ .compatible = "atmel,at91sam9260-pmc" },
+	{ .compatible = "atmel,at91sam9g45-pmc" },
+	{ .compatible = "atmel,at91sam9n12-pmc" },
+	{ .compatible = "atmel,at91sam9x5-pmc" },
+	{ .compatible = "atmel,sama5d3-pmc" },
 	{ /*sentinel*/ }
 };
 
-- 
1.7.9.5

