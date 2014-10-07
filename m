Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383AbaJGPvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 11:51:36 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:35806 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754308AbaJGPv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 11:51:29 -0400
Date: Tue, 7 Oct 2014 17:50:44 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, linux-m32r-ja@ml.linux-m32r.org,
        linux-mips@linux-mips.org, linux-efi@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux-xtensa@linux-xtensa.org,
        Mark Rutland <mark.rutland@arm.com>, devel@driverdev.osuosl.org,
        linux-s390@vger.kernel.org, lguest@lists.ozlabs.org,
        linux-c6x-dev@linux-c6x.org, linux-hexagon@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-acpi@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>, xen-devel@lists.xenproject.org,
        devicetree@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net, linux-pm@vger.kernel.org,
        adi-buildroot-devel@lists.sourceforge.net, linux-m68k@vger.kernel.org,
        linux-am33-list@redhat.com, linux-tegra@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net, linux-metag@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
        linux-cris-kernel@axis.com, Rob Herring <robh+dt@kernel.org>,
        linux-alpha@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 06/44] gpio-poweroff: Drop reference to pm_power_off from
 devicetree bindings
Message-ID: <20141007155044.GA19005@lunn.ch>
References: <1412659726-29957-1-git-send-email-linux@roeck-us.net>
 <1412659726-29957-7-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412659726-29957-7-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 10:28:08PM -0700, Guenter Roeck wrote:
> pm_power_off is an implementation detail. Replace it with a more generic
> description of the driver's functionality.
> 
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Acked-by: Andrew Lunn <andrew@lunn.ch>

Thanks
	Andrew
> ---
>  Documentation/devicetree/bindings/gpio/gpio-poweroff.txt | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/gpio/gpio-poweroff.txt b/Documentation/devicetree/bindings/gpio/gpio-poweroff.txt
> index d4eab92..c95a1a6 100644
> --- a/Documentation/devicetree/bindings/gpio/gpio-poweroff.txt
> +++ b/Documentation/devicetree/bindings/gpio/gpio-poweroff.txt
> @@ -2,12 +2,12 @@ Driver a GPIO line that can be used to turn the power off.
>  
>  The driver supports both level triggered and edge triggered power off.
>  At driver load time, the driver will request the given gpio line and
> -install a pm_power_off handler. If the optional properties 'input' is
> -not found, the GPIO line will be driven in the inactive
> +install a handler to power off the system. If the optional properties
> +'input' is not found, the GPIO line will be driven in the inactive
>  state. Otherwise its configured as an input.
>  
> -When the pm_power_off is called, the gpio is configured as an output,
> -and drive active, so triggering a level triggered power off
> +When the the poweroff handler is called, the gpio is configured as an
> +output, and drive active, so triggering a level triggered power off
>  condition. This will also cause an inactive->active edge condition, so
>  triggering positive edge triggered power off. After a delay of 100ms,
>  the GPIO is set to inactive, thus causing an active->inactive edge,
> @@ -24,7 +24,7 @@ Required properties:
>  
>  Optional properties:
>  - input : Initially configure the GPIO line as an input. Only reconfigure
> -  it to an output when the pm_power_off function is called. If this optional
> +  it to an output when the poweroff handler is called. If this optional
>    property is not specified, the GPIO is initialized as an output in its
>    inactive state.
>  
> -- 
> 1.9.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
