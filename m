Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933245AbaEGNOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:14:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45567 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933160AbaEGNOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:14:52 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paul Walmsley <paul@pwsan.com>, Roger Quadros <rogerq@ti.com>,
        Keshava Munegowda <keshava_mgowda@ti.com>,
        Partha Basak <parthab@india.ti.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 45/70] ARM: OMAP3: hwmod data: Correct clock domains for USB modules
Date: Wed,  7 May 2014 14:12:48 +0100
Message-Id: <1399468393-10140-46-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
References: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Quadros <rogerq@ti.com>

commit c6c56697ae4bf1226263c19e8353343d7083f40e upstream.

OMAP3 doesn't contain "l3_init_clkdm" clock domain. Use the
proper clock domains for USB Host and USB TLL modules.

Gets rid of the following warnings during boot
 omap_hwmod: usb_host_hs: could not associate to clkdm l3_init_clkdm
 omap_hwmod: usb_tll_hs: could not associate to clkdm l3_init_clkdm

Reported-by: Nishanth Menon <nm@ti.com>
Cc: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
Fixes: de231388cb80a8ef3e779bbfa0564ba0157b7377 ("ARM: OMAP: USB: EHCI and OHCI hwmod structures for OMAP3")
Cc: Keshava Munegowda <keshava_mgowda@ti.com>
Cc: Partha Basak <parthab@india.ti.com>
Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
index 60f2344..857e76c 100644
--- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
@@ -1968,7 +1968,7 @@ static struct omap_hwmod_irq_info omap3xxx_usb_host_hs_irqs[] = {
 static struct omap_hwmod omap3xxx_usb_host_hs_hwmod = {
 	.name		= "usb_host_hs",
 	.class		= &omap3xxx_usb_host_hs_hwmod_class,
-	.clkdm_name	= "l3_init_clkdm",
+	.clkdm_name	= "usbhost_clkdm",
 	.mpu_irqs	= omap3xxx_usb_host_hs_irqs,
 	.main_clk	= "usbhost_48m_fck",
 	.prcm = {
@@ -2053,7 +2053,7 @@ static struct omap_hwmod_irq_info omap3xxx_usb_tll_hs_irqs[] = {
 static struct omap_hwmod omap3xxx_usb_tll_hs_hwmod = {
 	.name		= "usb_tll_hs",
 	.class		= &omap3xxx_usb_tll_hs_hwmod_class,
-	.clkdm_name	= "l3_init_clkdm",
+	.clkdm_name	= "core_l4_clkdm",
 	.mpu_irqs	= omap3xxx_usb_tll_hs_irqs,
 	.main_clk	= "usbtll_fck",
 	.prcm = {
-- 
1.9.1

