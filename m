Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362AbaAGPOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 10:14:16 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:56329 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaAGPOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 10:14:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/4] ARM: dts: OMAP5: Add 60MHz clock reference to USB Host module
Date: Tue, 7 Jan 2014 16:13:38 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Roger Quadros <rogerq@ti.com>, bcousson@baylibre.com, tony@atomide.com,
        devicetree@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, linux-omap@vger.kernel.org
References: <1389096889-22179-1-git-send-email-rogerq@ti.com> <1389096889-22179-2-git-send-email-rogerq@ti.com>
In-Reply-To: <1389096889-22179-2-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401071613.39245.arnd@arndb.de>
X-Provags-ID: V02:K0:PtEy0oNToLR3VkfLNjqfIFEE8AoQ6TvGo6ekE72GLmd
 7JZTg3Uv4MoDLd5XSipHrtgQt8KXnrCuG4lL/8hkED/zU4S6zw
 oWN3NixwBLZy0y83juI4b3XMnwKBK5TJ0ckbMZSV/k+kJGzhhz
 4CsMUmkUcJOCl51lns32zbnc5jxoPUVqngslF8aDsvtkUottbP
 MHj7h8DIor2VEv+yQz9gA0brt2uU5BoD1Oc37xcIRLIvwnfTwB
 J9fMXjmPSfiirj/G0Sx2iHP5E22z9rl3xw4BcsMI081Ir55mPu
 E012PdwdXDmahbfPGl+S1xFRUd3ULYRC7V4Nv8mkSDD9AV38oA
 3b96xxdWMQ4K0SVW0sfI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 January 2014, Roger Quadros wrote:
> USB Host driver (drivers/mfd/omap-usb-host.c) expects the 60MHz
> reference clock to be named "init_60m_fclk". Provide this
> information.
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  arch/arm/boot/dts/omap5.dtsi | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
> index 2f12a47..e0ab379 100644
> --- a/arch/arm/boot/dts/omap5.dtsi
> +++ b/arch/arm/boot/dts/omap5.dtsi
> @@ -765,6 +765,8 @@
>                         #address-cells = <1>;
>                         #size-cells = <1>;
>                         ranges;
> +                       clocks = <&l3init_60m_fclk>;
> +                       clock-names = "init_60m_fclk";
>  
>                         usbhsohci: ohci@4a064800 {
>                                 compatible = "ti,ohci-omap3", "usb-ohci";

The bindings/mfd/omap-usb-host.txt file doesn't document any clocks.
Please create another patch to document the clock names in this binding
before you start putting them into the dtsi file. So far the clock
names are an implementation detail of Linux as they are not part
of the binding, and with your patch it becomes part of the ABI.

	Arnd
