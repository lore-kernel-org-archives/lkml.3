Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266AbaIJN6I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 09:58:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54820 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbaIJN6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 09:58:03 -0400
Date: Wed, 10 Sep 2014 06:57:16 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Tobias Klauser <tklauser@distanz.ch>, Alexander Shiyan <shc_work@mail.ru>
Cc: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, jslaby@suse.cz,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] tty: serial: serial_mctrl_gpio: Fix build error for
 !GPIOLIB
Message-ID: <20140910135716.GA23074@kroah.com>
References: <CA+r1ZhjCZBWjkxjoJz=PO-YZg6LbghQV75tGnpiSOrHM9CaygA@mail.gmail.com>
 <20140910080657.GC14260@distanz.ch>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
In-Reply-To: <20140910080657.GC14260@distanz.ch>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 10, 2014 at 10:06:58AM +0200, Tobias Klauser wrote:
> If SERIAL_MCTRL_GPIO is selected but GPIOLIB is not, the noop functions
> from serial_mctrl_gpio.h are pulled in. However, serial_mctrl_gpio.c is
> still compiled, leading to function redefinition build errors. Since all
> drivers that include serial_mctrl_gpio.h also depend on
> SERIAL_MCTRL_GPIO, let it depend on GPIOLIB as well remove the noop
> functions alltogether.
> 
> Reported-by: Jim Davis <jim.epost@gmail.com>
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
> ---
>  drivers/tty/serial/Kconfig             |  1 +
>  drivers/tty/serial/serial_mctrl_gpio.h | 35 ----------------------------------
>  2 files changed, 1 insertion(+), 35 deletions(-)

I fixed this yesterday with commit below from Alexander, which does
things a bit differently than you.  Any objections to it?

thanks,

greg k-h

--OgqxwSJOaUobr8KG
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0004-serial-clps711x-Fix-COMPILE_TEST-build-for-target-wi.patch"

>From efb089517d2f34a58aceb600ab58b0ca3db1fa07 Mon Sep 17 00:00:00 2001
From: Alexander Shiyan <shc_work@mail.ru>
Date: Tue, 9 Sep 2014 08:14:36 +0400
Subject: serial: clps711x: Fix COMPILE_TEST build for target without GPIOLIB
 support

The patch fixes the following build error of CLPS711X serial driver for
targets without GPIOLIB support:

>> drivers/tty/serial/serial_mctrl_gpio.c:44:6: error: redefinition of 'mctrl_gpio_set'
  void mctrl_gpio_set(struct mctrl_gpios *gpios, unsigned int mctrl)
      ^
  In file included from drivers/tty/serial/serial_mctrl_gpio.c:23:0:
  drivers/tty/serial/serial_mctrl_gpio.h:80:6: note: previous definition of 'mctrl_gpio_set' was here
  void mctrl_gpio_set(struct mctrl_gpios *gpios, unsigned int mctrl)
      ^

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 8079f5225575..81f6ee7d4223 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -222,7 +222,7 @@ config SERIAL_CLPS711X
 	tristate "CLPS711X serial port support"
 	depends on ARCH_CLPS711X || COMPILE_TEST
 	select SERIAL_CORE
-	select SERIAL_MCTRL_GPIO
+	select SERIAL_MCTRL_GPIO if GPIOLIB
 	help
 	  This enables the driver for the on-chip UARTs of the Cirrus
 	  Logic EP711x/EP721x/EP731x processors.
-- 
2.1.0


--OgqxwSJOaUobr8KG--
