Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbaEOKj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 06:39:59 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:57668 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751278AbaEOKj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 06:39:57 -0400
Message-ID: <1400150395.9119.3.camel@x220>
Subject: [PATCH] ARM: msm: remove check for CONFIG_MSM_SERIAL_DEBUGGER
From: Paul Bolle <pebolle@tiscali.nl>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Thu, 15 May 2014 12:39:55 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 May 2014 10:39:55.0583 (UTC) FILETIME=[02DA44F0:01CF702A]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An (optional) check for CONFIG_MSM_SERIAL_DEBUGGER was added in v2.6.35.
But the related Kconfig symbol was never added to the tree. This check
will always evaluate to false. Remove it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

There's another check for CONFIG_MSM_SERIAL_DEBUGGER in
board-mahimahi.c. But I submitted a patch to drop that entire board file
in https://lkml.org/lkml/2014/5/14/631 .

 arch/arm/mach-msm/board-msm7x30.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-msm/board-msm7x30.c b/arch/arm/mach-msm/board-msm7x30.c
index 46de789ad3ae..e3c646cc7765 100644
--- a/arch/arm/mach-msm/board-msm7x30.c
+++ b/arch/arm/mach-msm/board-msm7x30.c
@@ -125,7 +125,7 @@ struct msm_gpiomux_config msm_gpiomux_configs[GPIOMUX_NGPIOS] = {
 static struct platform_device *devices[] __initdata = {
 	&msm_clock_7x30,
 	&msm_device_gpio_7x30,
-#if defined(CONFIG_SERIAL_MSM) || defined(CONFIG_MSM_SERIAL_DEBUGGER)
+#if defined(CONFIG_SERIAL_MSM)
         &msm_device_uart2,
 #endif
 	&msm_device_smd,
-- 
1.9.0

