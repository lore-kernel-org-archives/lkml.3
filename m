Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbbAZKHZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:07:25 -0500
Received: from nasmtp01.atmel.com ([192.199.1.245]:27040 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752657AbbAZKHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:07:22 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <nicolas.ferre@atmel.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <alexandre.belloni@free-electrons.com>, <sylvain.rochet@finsecur.com>,
        <peda@axentia.se>, <wenyou.yang@atmel.com>,
        <Patrice.VILCHEZ@atmel.com>,
        Patrice Vilchez <patrice.vilchez@atmel.com>
Subject: [PATCH 3/7] pm: at91: pm_suspend: MOR register KEY was missing
Date: Mon, 26 Jan 2015 18:06:36 +0800
Message-ID: <1422266796-24523-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1422266617-24381-1-git-send-email-wenyou.yang@atmel.com>
References: <1422266617-24381-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrice Vilchez <patrice.vilchez@atmel.com>

Signed-off-by: Patrice Vilchez <patrice.vilchez@atmel.com>
---
 arch/arm/mach-at91/pm_suspend.S |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-at91/pm_suspend.S b/arch/arm/mach-at91/pm_suspend.S
index e796722..88cf228 100644
--- a/arch/arm/mach-at91/pm_suspend.S
+++ b/arch/arm/mach-at91/pm_suspend.S
@@ -229,6 +229,7 @@ sdr_sr_done:
 	/* Turn off the main oscillator */
 	ldr	tmp1, [pmc, #AT91_CKGR_MOR]
 	bic	tmp1, tmp1, #AT91_PMC_MOSCEN
+	orr	tmp1, tmp1, #AT91_PMC_KEY
 	str	tmp1, [pmc, #AT91_CKGR_MOR]
 
 skip_disable_main_clock:
@@ -241,6 +242,7 @@ skip_disable_main_clock:
 	/* Turn on the main oscillator */
 	ldr	tmp1, [pmc, #AT91_CKGR_MOR]
 	orr	tmp1, tmp1, #AT91_PMC_MOSCEN
+	orr	tmp1, tmp1, #AT91_PMC_KEY
 	str	tmp1, [pmc, #AT91_CKGR_MOR]
 
 	wait_moscrdy
-- 
1.7.9.5

