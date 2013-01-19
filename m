Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab3ASW04 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 17:26:56 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:34392 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751965Ab3ASW0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 17:26:53 -0500
Message-ID: <50FB1DFE.6090805@metafoo.de>
Date: Sat, 19 Jan 2013 23:28:14 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Icedove/3.0.11
MIME-Version: 1.0
To: "Patil, Rachna" <rachna@ti.com>
CC: linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Rob Herring <rob.herring@calxeda.com>,
        Jonathan Cameron <jic23@cam.ac.uk>, Tony Lindgren <tony@atomide.com>,
        Benit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v3 4/8] MFD: ti_am335x_tscadc: add device tree binding
 information
References: <cover.1358502134.git.rachna@ti.com> <daf18b4779ac3c6b69b1e7e2d1a4abd18b13fee5.1358502134.git.rachna@ti.com>
In-Reply-To: <daf18b4779ac3c6b69b1e7e2d1a4abd18b13fee5.1358502134.git.rachna@ti.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 01/18/2013 11:48 AM, Patil, Rachna wrote:
> From: "Patil, Rachna" <rachna@ti.com>
> 
> Signed-off-by: Patil, Rachna <rachna@ti.com>
> ---
>  .../devicetree/bindings/mfd/ti_am335x_tscadc.txt   |   35 ++++++++++++++++++++
>  1 file changed, 35 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mfd/ti_am335x_tscadc.txt
> 
> diff --git a/Documentation/devicetree/bindings/mfd/ti_am335x_tscadc.txt b/Documentation/devicetree/bindings/mfd/ti_am335x_tscadc.txt
> new file mode 100644
> index 0000000..c13c492
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/ti_am335x_tscadc.txt
> @@ -0,0 +1,35 @@
> +Texas Instruments - TSC / ADC multi-functional device
> +
> +ti_tscadc is a multi-function device with touchscreen and ADC on chip.
> +This document describes the binding for mfd device.
> +
> +Required properties:
> +- compatible: "ti,ti-tscadc"
> +- reg: Specifies the address of MFD block
> +- interrupts: IRQ line connected to the main SoC
> +- interrupt-parent: The parent interrupt controller

The subnodes and their properties also need documentation.

> +
> +Optional properties:
> +- ti,hwmods: Hardware information related to TSC/ADC MFD device
> +
> +Example:
> +
> +	tscadc: tscadc@44e0d000 {
> +		compatible = "ti,ti-tscadc";
> +		reg = <0x44e0d000 0x1000>;
> +
> +		interrupt-parent = <&intc>;
> +		interrupts = <16>;
> +		ti,hwmods = "adc_tsc";
> +
> +		tsc {
> +			wires = <4>;
> +			x-plate-resistance = <200>;
> +			steps-to-configure = <5>;
> +			wire-config = <0x00 0x11 0x22 0x33>;

Non-standard properties should have a vendor prefix.

> +		};
> +
> +		adc {
> +			adc-channels = <4>;
> +		};
> +	};

