Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab3I1ANY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 20:13:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36947 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab3I1ANV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 20:13:21 -0400
Message-ID: <52461F0B.5070303@infradead.org>
Date: Fri, 27 Sep 2013 17:12:59 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Drake <dsd@laptop.org>, Jens Frederich <jfrederich@gmail.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: [PATCH] staging/olpc: fix dependencies to fix build errors
References: <20130926231608.CBF2D5A424C@corp2gmr1-2.hot.corp.google.com>
In-Reply-To: <20130926231608.CBF2D5A424C@corp2gmr1-2.hot.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix build errors when GPIO_CS5535=m and FB_OLPC_DCON=y
by preventing that kconfig combination.

These build errors are caused by having a kconfig bool symbol
(FB_OLPC_DCON_1) that depend on a tristate symbol (GPIO_CS5535),
but when the tristate symbol is =m, the bool symbol is =y.

drivers/built-in.o: In function `dcon_read_status_xo_1':
olpc_dcon_xo_1.c:(.text+0x359531): undefined reference to `cs5535_gpio_set'
drivers/built-in.o: In function `dcon_wiggle_xo_1':
olpc_dcon_xo_1.c:(.text+0x35959f): undefined reference to `cs5535_gpio_set'
olpc_dcon_xo_1.c:(.text+0x359610): undefined reference to `cs5535_gpio_clear'
drivers/built-in.o:olpc_dcon_xo_1.c:(.text+0x3596a1): more undefined references to `cs5535_gpio_clear' follow
drivers/built-in.o: In function `dcon_wiggle_xo_1':
olpc_dcon_xo_1.c:(.text+0x359708): undefined reference to `cs5535_gpio_set'
drivers/built-in.o: In function `dcon_init_xo_1':
olpc_dcon_xo_1.c:(.text+0x35989b): undefined reference to `cs5535_gpio_clear'
olpc_dcon_xo_1.c:(.text+0x3598b5): undefined reference to `cs5535_gpio_isset'
olpc_dcon_xo_1.c:(.text+0x359963): undefined reference to `cs5535_gpio_setup_event'
olpc_dcon_xo_1.c:(.text+0x359980): undefined reference to `cs5535_gpio_set_irq'
olpc_dcon_xo_1.c:(.text+0x359a36): undefined reference to `cs5535_gpio_set'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc:	Daniel Drake <dsd@laptop.org>
Cc:	Jens Frederich <jfrederich@gmail.com>
---
This build problem has been around for a long time and is not
specific to mmotm.

 drivers/staging/olpc_dcon/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- mmotm-2013-0926-1615.orig/drivers/staging/olpc_dcon/Kconfig
+++ mmotm-2013-0926-1615/drivers/staging/olpc_dcon/Kconfig
@@ -1,6 +1,7 @@
 config FB_OLPC_DCON
 	tristate "One Laptop Per Child Display CONtroller support"
 	depends on OLPC && FB
+	depends on (GPIO_CS5535 || GPIO_CS5535=n)
 	select I2C
 	select BACKLIGHT_CLASS_DEVICE
 	---help---
