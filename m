Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759556Ab3GaKfK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 06:35:10 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:44860 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab3GaKfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 06:35:08 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Luciano Coelho <coelho@ti.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        mturquette@linaro.org, mark.rutland@arm.com, balbi@ti.com,
        grant.likely@linaro.org, rob.herring@calxeda.com,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, nm@ti.com
Subject: Re: [PATCH v3] Documentation: dt: bindings: TI WiLink modules
Date: Wed, 31 Jul 2013 12:36:07 +0200
Message-ID: <19103383.PkgSdCFM10@avalon>
User-Agent: KMail/4.10.5 (Linux/3.8.13-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1375215668-29171-1-git-send-email-coelho@ti.com>
References: <1375215668-29171-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luciano,

On Tuesday 30 July 2013 23:21:08 Luciano Coelho wrote:
> Add device tree bindings documentation for the TI WiLink modules.
> Currently only the WLAN part of the WiLink6, WiLink7 and WiLink8
> modules is supported.
> 
> Signed-off-by: Luciano Coelho <coelho@ti.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
> 
> In v3, use IRQ_TYPE_LEVEL_HIGH in the example, as suggested by Laurent.
> 
>  .../devicetree/bindings/net/wireless/ti-wilink.txt | 68
> ++++++++++++++++++++++ 1 file changed, 68 insertions(+)
>  create mode 100644
> Documentation/devicetree/bindings/net/wireless/ti-wilink.txt
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/ti-wilink.txt
> b/Documentation/devicetree/bindings/net/wireless/ti-wilink.txt new file
> mode 100644
> index 0000000..aafebb1
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/wireless/ti-wilink.txt
> @@ -0,0 +1,68 @@
> +TI WiLink Wireless Modules Device Tree Bindings
> +===============================================
> +
> +The WiLink modules provide wireless connectivity, such as WLAN,
> +Bluetooth, FM and NFC.
> +
> +There are several different modules available, which can be grouped by
> +their generation: WiLink6, WiLink7 and WiLink8.  WiLink4 is not
> +currently supported with device tree.
> +
> +Currently, only the WLAN portion of the modules is supported with
> +device tree.
> +
> +Required properties:
> +--------------------
> +
> +- compatible: should be "ti,wilink6", "ti,wilink7" or "ti,wilink8"
> +- interrupt-parent: the interrupt controller
> +- interrupts: out-of-band WLAN interrupt
> +	See the interrupt controller's bindings documentation for
> +	detailed definition.
> +
> +Optional properties:
> +--------------------
> +
> +- clocks: list of clocks needed by the chip as follows:
> +
> +  refclock: the internal WLAN reference clock frequency (required for
> +	WiLink6 and WiLink7; not used for WiLink8).
> +
> +  tcxoclock: the internal WLAN TCXO clock frequency (required for
> +	WiLink7 not used for WiLink6 and WiLink8).
> +
> +  The clocks must be defined and named accordingly.  For example:
> +
> +  clocks = <&refclock>
> +  clock-names = "refclock";
> +
> +  refclock: refclock {
> +		     compatible = "ti,wilink-clock";
> +		     #clock-cells = <0>;
> +		     clock-frequency = <38400000>;
> +	};
> +
> +  Some modules that contain the WiLink chip provide clocks in the
> +  module itself.  In this case, we define a "ti,wilink-clock" as shown
> +  above.  But any other clock could in theory be used, so the proper
> +  clock definition should be used.
> +
> +
> +Example:
> +--------
> +
> +Example definition that can be used in OMAP4 Panda:
> +
> +wlan {
> +	compatible = "ti,wilink6";
> +	interrupt-parent = <&gpio2>;
> +	interrupts = <21 IRQ_TYPE_LEVEL_HIGH>;	/* gpio line 53 */
> +	clocks = <&refclock>;
> +	clock-names = "refclock";
> +
> +	refclock: refclock {
> +		compatible = "ti,wilink-clock";
> +		#clock-cells = <0>;
> +		clock-frequency = <38400000>;
> +	};
> +};
-- 
Regards,

Laurent Pinchart

