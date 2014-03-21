Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967054AbaCUBTw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:19:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36571 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760437AbaCUADq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:03:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andrea Adami <andrea.adami@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 3.13 059/149] ARM: 7991/1: sa1100: fix compile problem on Collie
Date: Thu, 20 Mar 2014 17:03:42 -0700
Message-Id: <20140321000439.007994112@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

commit 052450fdc55894a39fbae93d9bbe43947956f663 upstream.

Due to a problem in the MFD Kconfig it was not possible to
compile the UCB battery driver for the Collie SA1100 system,
in turn making it impossible to compile in the battery driver.
(See patch "mfd: include all drivers in subsystem menu".)

After fixing the MFD Kconfig (separate patch) a compile error
appears in the Collie battery driver due to the <mach/collie.h>
implicitly requiring <mach/hardware.h> through <linux/gpio.h>
via <mach/gpio.h> prior to commit
40ca061b "ARM: 7841/1: sa1100: remove complex GPIO interface".

Fix this up by including the required header into
<mach/collie.h>.

Cc: Andrea Adami <andrea.adami@gmail.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-sa1100/include/mach/collie.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm/mach-sa1100/include/mach/collie.h
+++ b/arch/arm/mach-sa1100/include/mach/collie.h
@@ -13,6 +13,8 @@
 #ifndef __ASM_ARCH_COLLIE_H
 #define __ASM_ARCH_COLLIE_H
 
+#include "hardware.h" /* Gives GPIO_MAX */
+
 extern void locomolcd_power(int on);
 
 #define COLLIE_SCOOP_GPIO_BASE	(GPIO_MAX + 1)


