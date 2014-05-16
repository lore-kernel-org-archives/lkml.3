Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153AbaEPKko (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 06:40:44 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:58092 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757137AbaEPKkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 06:40:43 -0400
Message-ID: <1400236840.20342.30.camel@x220>
Subject: [PATCH] ARM: pxa: fix typo 'CONFIG_SPI_PXA2XX_MASTER'
From: Paul Bolle <pebolle@tiscali.nl>
To: Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Fri, 16 May 2014 12:40:40 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 May 2014 10:40:41.0119 (UTC) FILETIME=[486842F0:01CF70F3]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_SPI_PXA2XX_MASTER was used were it was surely meant to use
CONFIG_SPI_PXA2XX_MODULE. Use the IS_ENABLED() macro here, as it guards
against typos like this one.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested, and (hardware) testing for the modular case might be needed.
This typo was introduced in v2.6.28.

 arch/arm/mach-pxa/corgi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-pxa/corgi.c b/arch/arm/mach-pxa/corgi.c
index 57d60542f982..ccff8d82cc27 100644
--- a/arch/arm/mach-pxa/corgi.c
+++ b/arch/arm/mach-pxa/corgi.c
@@ -513,7 +513,7 @@ static struct pxa2xx_udc_mach_info udc_info __initdata = {
 	.gpio_pullup		= CORGI_GPIO_USB_PULLUP,
 };
 
-#if defined(CONFIG_SPI_PXA2XX) || defined(CONFIG_SPI_PXA2XX_MASTER)
+#if IS_ENABLED(CONFIG_SPI_PXA2XX)
 static struct pxa2xx_spi_master corgi_spi_info = {
 	.num_chipselect	= 3,
 };
-- 
1.9.0

