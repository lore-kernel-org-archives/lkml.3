Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbaEUOwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 10:52:05 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:61689 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbaEUOwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 10:52:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Cc: dbaryshkov@gmail.com, dwmw2@infradead.org, santosh.shilimkar@ti.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        grant.likely@linaro.org, rdunlap@infradead.org, linux@arm.linux.org.uk,
        grygorii.strashko@ti.com, olof@lixom.net, w-kwok2@ti.com,
        sboyd@codeaurora.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, m-karicheri2@ti.com
Subject: Re: [Patch v4 4/5] ARM: dts: keystone: update reset node to work with reset driver
Date: Wed, 21 May 2014 16:50:55 +0200
Message-ID: <15259908.YoiO6LMEzV@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1400682454-24535-5-git-send-email-ivan.khoronzhuk@ti.com>
References: <1400682454-24535-1-git-send-email-ivan.khoronzhuk@ti.com> <1400682454-24535-5-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:U4OzpCDX/1Fs8wiIB7KyrzUwbNQuvSeJAU9KUS5hWpf
 AHYBOXTtAQ47PZyJCCIKy6GXW1L3XU6Cta05F+fzeARzIpUMrp
 rW1bXDra23vG6BOFMq3uegbcjkr0qnx/l/n3AKb9BBnWpXG9oI
 OD59JWWZRjIUD/F0Rj0RkG4m6lun/ayJ5zQvDteROuCG5haAej
 KnRYFYwFJjUZNsjJJKJZl+SS77R+SDuIECQDMYIsP0xB3SAlmi
 biaPHJtvg1E+ZnbTdJ3o8/xURkTrASF+O67QJxChzhN3Lhx21K
 yHSMosbOl7IYJL1KsItCVocnQhGMwnvaY6iXhYd3nE/OT1VB//
 ZllvZ7x5Xj0vPw8+NDOc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 May 2014 17:27:33 Ivan Khoronzhuk wrote:
> The keystone driver requires the next additional properties:
> 
> "ti,syscon-pll" - syscon register range used to access pll controller
>                   registers in order to use reset control registers.
> "ti,syscon-dev" - syscon register range used to access device state
>                   control registers in order to use mux block
>                   registers for all watchdogs.
> 
> "ti,wdt_list"   - option to declare what watchdog are used to reboot
>                   the SoC, so set "0" WDT as default.
> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>

Same comment as what I had for the binding: it's not a register range
any more, but a phandle for a device.

> ---
>  arch/arm/boot/dts/keystone.dtsi | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/keystone.dtsi b/arch/arm/boot/dts/keystone.dtsi
> index 8b899ba..783da60 100644
> --- a/arch/arm/boot/dts/keystone.dtsi
> +++ b/arch/arm/boot/dts/keystone.dtsi
> @@ -78,7 +78,9 @@
>  
>                 rstctrl: reset-controller {
>                         compatible = "ti,keystone-reset";
> -                       reg = <0x023100e8 4>;   /* pll reset control reg */
> +                       ti,syscon-pll = <&pllctrl>;
> +                       ti,syscon-dev = <&devctrl>;
> +                       ti,wdt_list = <0>;
>                 };
>  

I don't see a definition for the two labels, so this will cause a
build error. It makes sense to add them in the same patch.

	Arnd
