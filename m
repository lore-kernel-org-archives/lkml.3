Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933747AbbA1CI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:08:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41108 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759915AbbA1B2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:28:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gavin Li <gavinli@thegavinli.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 3.18 36/61] irqchip: atmel-aic-common: Prevent clobbering of priority when changing IRQ type
Date: Tue, 27 Jan 2015 17:26:48 -0800
Message-Id: <20150128012640.860886461@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012636.936333725@linuxfoundation.org>
References: <20150128012636.936333725@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gavin Li <git@thegavinli.com>

commit 91d1179212161f220938198b742c328ad38fd0a3 upstream.

This patch makes the bitmask for AIC_SRCTYPE consistent
with that of its valid values, and prevents the priority
field at bits 2:0 from being clobbered by an incorrect
AND with the AIC_SRCTYPE mask.

Signed-off-by: Gavin Li <gavinli@thegavinli.com>
Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Link: https://lkml.kernel.org/r/1420598843-8409-1-git-send-email-gavinli@thegavinli.com
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/irqchip/irq-atmel-aic-common.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/irqchip/irq-atmel-aic-common.c
+++ b/drivers/irqchip/irq-atmel-aic-common.c
@@ -28,7 +28,7 @@
 #define AT91_AIC_IRQ_MIN_PRIORITY	0
 #define AT91_AIC_IRQ_MAX_PRIORITY	7
 
-#define AT91_AIC_SRCTYPE		GENMASK(7, 6)
+#define AT91_AIC_SRCTYPE		GENMASK(6, 5)
 #define AT91_AIC_SRCTYPE_LOW		(0 << 5)
 #define AT91_AIC_SRCTYPE_FALLING	(1 << 5)
 #define AT91_AIC_SRCTYPE_HIGH		(2 << 5)
@@ -74,7 +74,7 @@ int aic_common_set_type(struct irq_data
 		return -EINVAL;
 	}
 
-	*val &= AT91_AIC_SRCTYPE;
+	*val &= ~AT91_AIC_SRCTYPE;
 	*val |= aic_type;
 
 	return 0;


