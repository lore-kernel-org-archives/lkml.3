Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644Ab3HNOnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 10:43:18 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:44093 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932510Ab3HNOnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 10:43:16 -0400
Message-ID: <520B9780.5000007@baylibre.com>
Date: Wed, 14 Aug 2013 16:43:12 +0200
From: Benoit Cousson <bcousson@baylibre.com>
Organization: BayLibre
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>
CC: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        mturquette@linaro.org, mark.rutland@arm.com, balbi@ti.com,
        grant.likely@linaro.org, rob.herring@calxeda.com,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, nm@ti.com, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v3] Documentation: dt: bindings: TI WiLink modules
References: <1375215668-29171-1-git-send-email-coelho@ti.com>
In-Reply-To: <1375215668-29171-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luca,

On 30/07/2013 22:21, Luciano Coelho wrote:
> Add device tree bindings documentation for the TI WiLink modules.
> Currently only the WLAN part of the WiLink6, WiLink7 and WiLink8
> modules is supported.
>
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---
>
> In v3, use IRQ_TYPE_LEVEL_HIGH in the example, as suggested by Laurent.
>
>   .../devicetree/bindings/net/wireless/ti-wilink.txt | 68 ++++++++++++++++++++++
>   1 file changed, 68 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/net/wireless/ti-wilink.txt
>
> diff --git a/Documentation/devicetree/bindings/net/wireless/ti-wilink.txt b/Documentation/devicetree/bindings/net/wireless/ti-wilink.txt
> new file mode 100644
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

Everything looks good beside the location of the wlan node...

It should not float at the root of the device tree. It is physically 
attached to a SDIO bus and thus must be a child of the MMC controller 
for a proper HW representation. That's moreover the best way to handle 
properly the dependency between the MMC controller and the wilink driver.

Please note that this is easier do say than to do :-)

Regards,
Benoit

