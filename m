Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933865Ab3HHI0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 04:26:08 -0400
Received: from 16.mo4.mail-out.ovh.net ([188.165.55.104]:39532 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756454Ab3HHI0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 04:26:00 -0400
X-Greylist: delayed 4122 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Aug 2013 04:25:59 EDT
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Josh Wu <josh.wu@atmel.com>, Richard Genoud <richard.genoud@gmail.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: [PATCH v3 19/19] ARM: at91: add new compatible strings for pmc driver
Date: Thu,  8 Aug 2013 10:19:25 +0200
Message-Id: <1375949965-10586-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375937608-3773-1-git-send-email-b.brezillon@overkiz.com>
References: <1375937608-3773-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 6153042992502569008
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrtdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrtdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new compatible string for PMC node to prepare the
transition to common clk.

These compatible string come from pmc driver in clk subsystem and are
needed to provide new device tree compatibility with old at91 clks
(device tree using common clks will use the new compatible strings).

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/mach-at91/clock.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/mach-at91/clock.c b/arch/arm/mach-at91/clock.c
index 5f02aea..4d4463a 100644
--- a/arch/arm/mach-at91/clock.c
+++ b/arch/arm/mach-at91/clock.c
@@ -884,6 +884,12 @@ static int __init at91_pmc_init(unsigned long main_clock)
 #if defined(CONFIG_OF)
 static struct of_device_id pmc_ids[] = {
 	{ .compatible = "atmel,at91rm9200-pmc" },
+	{ .compatible = "atmel,at91sam9260-pmc" },
+	{ .compatible = "atmel,at91sam9g45-pmc" },
+	{ .compatible = "atmel,at91sam9n12-pmc" },
+	{ .compatible = "atmel,at91sam9x5-pmc" },
+	{ .compatible = "atmel,at91sam9g35-pmc" },
+	{ .compatible = "atmel,sama5d3-pmc" },
 	{ /*sentinel*/ }
 };
 
-- 
1.7.9.5

