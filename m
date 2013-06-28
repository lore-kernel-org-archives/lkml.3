Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab3F1JjA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 05:39:00 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40683 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754950Ab3F1Ji6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 05:38:58 -0400
Date: Fri, 28 Jun 2013 10:38:48 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Luciano Coelho <coelho@ti.com>
Cc: "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-arm@vger.kernel.org" <linux-arm@vger.kernel.org>
Subject: Re: [PATCH] Documentation: dt: bindings: TI WiLink modules
Message-ID: <20130628093848.GA2139@e106331-lin.cambridge.arm.com>
References: <1372149330-24335-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372149330-24335-1-git-send-email-coelho@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 09:35:30AM +0100, Luciano Coelho wrote:
> Add device tree bindings documentation for the TI WiLink modules.
> Currently only the WLAN part of the WiLink6, WiLink7 and WiLink8
> modules is supported.
> 
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---
> 
> I created a new directory under net to contain wireless bindings documentation.
> 
> The actual implementation in the driver will follow separately.
> 
>  .../devicetree/bindings/net/wireless/ti-wilink.txt |   46 ++++++++++++++++++++
>  1 file changed, 46 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/ti-wilink.txt
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/ti-wilink.txt b/Documentation/devicetree/bindings/net/wireless/ti-wilink.txt
> new file mode 100644
> index 0000000..d8e8bfbb
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/wireless/ti-wilink.txt
> @@ -0,0 +1,46 @@
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
> +- refclock: the internal WLAN reference clock frequency (required for
> +  WiLink6 and WiLink7; not used for WiLink8).  Must be one of the
> +  following:
> +	0 = 19.2 MHz
> +	1 = 26.0 MHz
> +	2 = 38.4 MHz
> +	3 = 52.0 MHz
> +	4 = 38.4 MHz, XTAL
> +	5 = 26.0 MHz, XTAL
> +
> +- tcxoclock: the internal WLAN TCXO clock frequency (required for
> +  WiLink7 not used for WiLink6 and WiLink8).  Must be one of the
> +  following:
> +	0 = 19.200 MHz
> +	1 = 26.000 MHz
> +	2 = 38.400 MHz
> +	3 = 52.000 MHz
> +	4 = 16.368 MHz
> +	5 = 32.736 MHz
> +	6 = 16.800 MHz
> +	7 = 33.600 MHz

This looks suspiciously like what we have the common clock bindings for:

refclk {
	compatible = "fixed-clock";
	#clock-cells = <0>;
	clock-frequency = <19200000>;
}

wilink {
	compatible = "ti,wilink7";
	interrupt-parent = <&some_interrupt_controller>;
	interrupts = <0 1 1>;
	clocks = <&refclk>, <&refclk>;
	clock-names = "refclk", "txoclk";
};

Could you not use them?

Thanks,
Mark.
