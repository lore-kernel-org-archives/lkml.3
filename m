Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbaIJW0D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 18:26:03 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:55368 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbaIJW0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 18:26:00 -0400
Date: Wed, 10 Sep 2014 15:25:56 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>, afaerber@suse.de,
        Nick Dyer <nick.dyer@itdev.co.uk>, Yufeng Shen <miletus@chromium.org>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>
Subject: Re: [PATCH v4 1/3] ARM: dts: Add Peach Pit dts entry for Atmel
 touchpad
Message-ID: <20140910222553.GF38736@core.coreip.homeip.net>
References: <1410348691-18317-1-git-send-email-javier.martinez@collabora.co.uk>
 <1410348691-18317-2-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410348691-18317-2-git-send-email-javier.martinez@collabora.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 01:31:29PM +0200, Javier Martinez Canillas wrote:
> From: Sjoerd Simons <sjoerd.simons@collabora.co.uk>
> 
> The Peach Pit board has an Atmel maXTouch trackpad device.
> Add the needed Device Tree nodes to support it.
> 
> This Device Tree change is based on the Chrome OS 3.8 tree
> but adapted to use the mainline Atmel maXTouch DT binding.
> 
> Signed-off-by: Sjoerd Simons <sjoerd.simons@collabora.co.uk>
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

> ---
> 
> Changes since v3:
>  - Use KEY_RESERVED even for not reserved pins with a GPIO not hooked.
>    Suggested by Nick Dyer.
>  - Add a comment to specify the maXTouch chip version so is more clear.
>    Suggested by Nick Dyer.
>  - Omit trailing omit KEY_RESERVED after the GPIO pins. Suggested by Nick Dyer.
> 
> Changes since v2:
>  - Add spaces around '=' on properties. Suggested by Andreas Faerber.
> 
> Changes since v1:
>  - Change trackpad IRQ pad function from 0x0 (GPIO input) to 0xf (GPIO IRQ).
>    suggested by Tomasz Figa.
>  - Remove BTN_TOOL_* from "linux,gpio-keymap" property since those are set
>    by input mt core if INPUT_MT_POINTER is set. Suggested by Nick Dyer.
>  - Use correct values for "linux,gpio-keymap" property. Suggested by Nick Dyer.
>  - Remove support for Peach Pi board since it uses a different Atmel touchpad
>    that requires an Atmel object protocol  (T100) not supported by the driver.
>  - Use IRQ type constants from <dt-bindings/interrupt-controller/irq.h> instead
>    of magic numbers. Suggested by Andreas Faerber.
> 
>  arch/arm/boot/dts/exynos5420-peach-pit.dts | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/exynos5420-peach-pit.dts b/arch/arm/boot/dts/exynos5420-peach-pit.dts
> index f247709..ad56d4c 100644
> --- a/arch/arm/boot/dts/exynos5420-peach-pit.dts
> +++ b/arch/arm/boot/dts/exynos5420-peach-pit.dts
> @@ -507,6 +507,28 @@
>  	};
>  };
>  
> +&hsi2c_8 {
> +	status = "okay";
> +	clock-frequency = <333000>;
> +
> +	/* Atmel mXT336S */
> +	trackpad@4b {
> +		compatible = "atmel,maxtouch";
> +		reg = <0x4b>;
> +		interrupt-parent = <&gpx1>;
> +		interrupts = <1 IRQ_TYPE_EDGE_FALLING>;
> +		wakeup-source;
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&trackpad_irq>;
> +		linux,gpio-keymap = <KEY_RESERVED
> +				     KEY_RESERVED
> +				     KEY_RESERVED	/* GPIO0 */
> +				     KEY_RESERVED	/* GPIO1 */
> +				     KEY_RESERVED	/* GPIO2 */
> +				     BTN_LEFT>; 	/* GPIO3 */

Seems like a single space sneaked between the semicolon and the tab.
Maybe whoever applies could squash it.

Thanks.

-- 
Dmitry
