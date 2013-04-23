Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab3DWTVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 15:21:17 -0400
Received: from mout.gmx.net ([212.227.15.15]:51108 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757028Ab3DWTVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 15:21:16 -0400
X-Authenticated: #9962044
X-Provags-ID: V01U2FsdGVkX190w4FBkch0g/oxPWJveWBAG/2pFRxKeZk4L26Zgk
	OUMK+DbLtzTvfB
From: Marc Dietrich <marvin24@gmx.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 14/21] staging: nvec: allow modular build
Date: Tue, 23 Apr 2013 21:21:06 +0200
Message-ID: <4082180.JXNz6TsAKc@ax5200p>
User-Agent: KMail/4.8.5 (Linux/3.5.0-21-generic; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1366734653-488286-15-git-send-email-arnd@arndb.de>
References: <1366734653-488286-1-git-send-email-arnd@arndb.de> <1366734653-488286-15-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd,

On Tuesday 23 April 2013 18:30:46 Arnd Bergmann wrote:
> The serio code can be a loadable module, which in turn means that nvec
> also has to be a module, so mark it as "tristate" in Kconfig.

oh, I didn't saw this randconfig error posting. NVEC isn't prepared for 
modularized builds yet (it's on the TODO list though). So better say SERIO=y 
here. Looking a bit closer, there is other stuff which can also be a module 
(GPIOLIB, I2C, ...) so these also need a =y.

Should a post a patch?

Marc
 
> drivers/built-in.o: In function `nvec_mouse_remove':
> drivers/staging/nvec/nvec_ps2.c:136: undefined reference to
> `serio_unregister_port' drivers/built-in.o: In function `nvec_mouse_probe':
> drivers/staging/nvec/nvec_ps2.c:126: undefined reference to
> `__serio_register_port' drivers/built-in.o: In function
> `nvec_ps2_notifier':
> drivers/staging/nvec/nvec_ps2.c:84: undefined reference to `serio_interrupt'
> drivers/staging/nvec/nvec_ps2.c:91: undefined reference to
> `serio_interrupt'
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Marc Dietrich <marvin24@gmx.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/staging/nvec/Kconfig | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/nvec/Kconfig b/drivers/staging/nvec/Kconfig
> index f779fdc..7e61ada 100644
> --- a/drivers/staging/nvec/Kconfig
> +++ b/drivers/staging/nvec/Kconfig
> @@ -1,5 +1,5 @@
>  config MFD_NVEC
> -	bool "NV Tegra Embedded Controller SMBus Interface"
> +	tristate "NV Tegra Embedded Controller SMBus Interface"
>  	depends on I2C && GPIOLIB && ARCH_TEGRA
>  	select MFD_CORE
>  	help
> @@ -7,28 +7,28 @@ config MFD_NVEC
>  	    controller.
> 
>  config KEYBOARD_NVEC
> -	bool "Keyboard on nVidia compliant EC"
> +	tristate "Keyboard on nVidia compliant EC"
>  	depends on MFD_NVEC && INPUT
>  	help
>  	  Say Y here to enable support for a keyboard connected to
>  	  a nVidia compliant embedded controller.
> 
>  config SERIO_NVEC_PS2
> -	bool "PS2 on nVidia EC"
> +	tristate "PS2 on nVidia EC"
>  	depends on MFD_NVEC && SERIO
>  	help
>  	  Say Y here to enable support for a Touchpad / Mouse connected
>  	  to a nVidia compliant embedded controller.
> 
>  config NVEC_POWER
> -	bool "NVEC charger and battery"
> +	tristate "NVEC charger and battery"
>  	depends on MFD_NVEC && POWER_SUPPLY
>  	help
>  	  Say Y to enable support for battery and charger interface for
>  	  nVidia compliant embedded controllers.
> 
>  config NVEC_PAZ00
> -	bool "Support for OEM specific functions on Compal PAZ00 based devices"
> +	tristate "Support for OEM specific functions on Compal PAZ00 based
> devices" depends on MFD_NVEC && LEDS_CLASS
>  	help
>  	  Say Y to enable control of the yellow side leds on Compal PAZ00 based
