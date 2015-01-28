Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934316AbbA1C03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:26:29 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:38720 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933196AbbA1C01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 21:26:27 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <nicolas.ferre@atmel.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <alexandre.belloni@free-electrons.com>, <sylvain.rochet@finsecur.com>,
        <peda@axentia.se>, <sergei.shtylyov@cogentembedded.com>,
        <linux@maxim.org.za>, <wenyou.yang@atmel.com>,
        Patrice Vilchez <patrice.vilchez@atmel.com>
Subject: [PATCH v2 2/3] pm: at91: pm_suspend: MOR register KEY was missing
Date: Wed, 28 Jan 2015 10:23:22 +0800
Message-ID: <1422411802-13207-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1422411707-10945-1-git-send-email-wenyou.yang@atmel.com>
References: <1422411707-10945-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrice Vilchez <patrice.vilchez@atmel.com>

Because writing the MOR register requires the PASSWD(0x37),
if missed, the write operation will be aborted.

Signed-off-by: Patrice Vilchez <patrice.vilchez@atmel.com>
---
 arch/arm/mach-at91/pm_suspend.S |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-at91/pm_suspend.S b/arch/arm/mach-at91/pm_suspend.S
index aed6903..311cc23 100644
--- a/arch/arm/mach-at91/pm_suspend.S
+++ b/arch/arm/mach-at91/pm_suspend.S
@@ -224,6 +224,7 @@ sdr_sr_done:
 	/* Turn off the main oscillator */
 	ldr	tmp1, [pmc, #AT91_CKGR_MOR]
 	bic	tmp1, tmp1, #AT91_PMC_MOSCEN
+	orr	tmp1, tmp1, #AT91_PMC_KEY
 	str	tmp1, [pmc, #AT91_CKGR_MOR]
 
 skip_disable_main_clock:
@@ -236,6 +237,7 @@ skip_disable_main_clock:
 	/* Turn on the main oscillator */
 	ldr	tmp1, [pmc, #AT91_CKGR_MOR]
 	orr	tmp1, tmp1, #AT91_PMC_MOSCEN
+	orr	tmp1, tmp1, #AT91_PMC_KEY
 	str	tmp1, [pmc, #AT91_CKGR_MOR]
 
 	wait_moscrdy
-- 
1.7.9.5

