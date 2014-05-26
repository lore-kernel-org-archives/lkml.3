Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbaEZPE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:04:29 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:64088 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbaEZPE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:04:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Jean Delvare <jdelvare@suse.de>, Alexandre Courbot <gnurou@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] gpio: pch: include linux/slab.h
Date: Mon, 26 May 2014 17:04:24 +0200
Message-ID: <8665687.jWqf6bo4lM@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:njbDZkAw8HzK1L/5/86Z9jpwlmwmYDOUMsXhitzjesD
 MGvkjmd6tU9fADnPrY9O3Hyh1uoEL+BhypJUNSJ8AzD3Tjt9C+
 6GZuIss7tmSvaLcoJL3GDEE75NUwUAT9C9XC2hDmELlGyygKd8
 ElkBMZ40N4pk1oUS8Tef7c1cjpif2Rli2XRP3NwxUM4r9V5Ogc
 HYXpCUihrKqZdGKcu5ZIm9y3nMevYMWvZh4FJK4g389TurrM5N
 RMZUuXTxcKGAnx/5XGna/YeHFQX6rpCepZ/RfBVVUJZxpkcAba
 1KAwD97X66TwTsSYHytluEl5KsN50QMbpj3ETZxw8z9pdo/qpN
 acYH8ojGzytnjRBa8QgM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The gpio-pch driver was recently enabled for compile-tests,
which revealed that it is missing an include for linux/slab.h,
which on ARM is not implied by any of the other headers.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/gpio/gpio-pch.c b/drivers/gpio/gpio-pch.c
index 83a1563..d6eac9b 100644
--- a/drivers/gpio/gpio-pch.c
+++ b/drivers/gpio/gpio-pch.c
@@ -20,6 +20,7 @@
 #include <linux/gpio.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
+#include <linux/slab.h>
 
 #define PCH_EDGE_FALLING	0
 #define PCH_EDGE_RISING		BIT(0)

