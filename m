Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbaIQPoJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 11:44:09 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:41615 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748AbaIQPoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 11:44:05 -0400
Date: Wed, 17 Sep 2014 08:44:00 -0700
From: Lee Jones <lee.jones@linaro.org>
To: Nishanth Menon <nm@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Sebastian Reichel <sre@kernel.org>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/2] Documentation: devicetree: mfd: twl4030-power:
 Use the standard 'ti,system-power-controller' to mark power control
Message-ID: <20140917154400.GE30918@lee--X1>
References: <1410957252-764-1-git-send-email-nm@ti.com>
 <1410957252-764-2-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1410957252-764-2-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2014, Nishanth Menon wrote:

> ti,system-power-controller is more or less the standard way of
> indicating that the PMIC is the system wide power controller and hence
> may be used to switch off the system. Almost ALL TI PMIC drivers and
> many Maxim PMIC drivers follow the same style.
> 
> So support 'ti,system-power-controller' in addition to the usual
> 'ti,use_poweroff' to indicate that the PMIC instance has control for
> switching off the system.
> 
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
> 
> V2: picked up documentation suggestion from Sebastien

It would be good to get Sebastian's Ack.

> V1: https://patchwork.kernel.org/patch/4836381/
> 
>  .../devicetree/bindings/mfd/twl4030-power.txt      |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/mfd/twl4030-power.txt b/Documentation/devicetree/bindings/mfd/twl4030-power.txt
> index b9ee7b9..a7390c7 100644
> --- a/Documentation/devicetree/bindings/mfd/twl4030-power.txt
> +++ b/Documentation/devicetree/bindings/mfd/twl4030-power.txt
> @@ -23,8 +23,13 @@ down during off-idle. Note that this does not work on all boards
>  depending on how the external oscillator is wired.
>  
>  Optional properties:
> -- ti,use_poweroff: With this flag, the chip will initiates an ACTIVE-to-OFF or
> -		   SLEEP-to-OFF transition when the system poweroffs.
> +
> +- ti,system-power-controller: This indicates that TWL4030 is the
> +  power supply master of the system. With this flag, the chip will
> +  initiates an ACTIVE-to-OFF or SLEEP-to-OFF transition when the
> +  system poweroffs.
> +
> +- ti,use_poweroff: Deprecated name for ti,system-power-controller
>  
>  Example:
>  &i2c1 {

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
