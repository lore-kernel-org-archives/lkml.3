Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438AbaK0SmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 13:42:21 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49588 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751040AbaK0SmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 13:42:19 -0500
Date: Thu, 27 Nov 2014 18:41:33 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "ijc@debian.org" <ijc@debian.org>, "andrew@lunn.ch" <andrew@lunn.ch>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
Subject: Re: [PATCH v3 1/3] devicetree: of: Add bindings for chosen node,
 stdout-path
Message-ID: <20141127184133.GM857@leverpostej>
References: <1417110967-16284-1-git-send-email-leif.lindholm@linaro.org>
 <1417110967-16284-2-git-send-email-leif.lindholm@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417110967-16284-2-git-send-email-leif.lindholm@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 05:56:05PM +0000, Leif Lindholm wrote:
> Add a global binding for the chosen node.
> Include a description of the stdout-path, and an explicit statement on
> its extra options in the context of a UART console.
> 
> Opening description stolen from www.devicetree.org, and part of the
> remaining text provided by Mark Rutland.
> 
> Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
> ---
>  Documentation/devicetree/bindings/chosen.txt |   42 ++++++++++++++++++++++++++
>  1 file changed, 42 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/chosen.txt
> 
> diff --git a/Documentation/devicetree/bindings/chosen.txt b/Documentation/devicetree/bindings/chosen.txt
> new file mode 100644
> index 0000000..9cd74e9
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/chosen.txt
> @@ -0,0 +1,42 @@
> +The chosen node
> +---------------
> +
> +The chosen node does not represent a real device, but serves as a place
> +for passing data between firmware and the operating system, like boot
> +arguments. Data in the chosen node does not represent the hardware.
> +
> +
> +stdout-path property
> +--------------------
> +
> +Device trees may specify the device to be used for boot console output
> +with a stdout-path property under /chosen, as described in ePAPR, e.g.
> +
> +/ {
> +	chosen {
> +		stdout-path = "/serial@f00:115200";
> +	};
> +
> +	serial@f00 {
> +		compatible = "vendor,some-uart";
> +		reg = <0xf00 0x10>;
> +	};
> +};
> +
> +If the character ":" is present in the value, this terminates the path.
> +The meaning of any characters following the ":" is device-specific, and
> +must be specified in the relevant binding documentation.
> +
> +For UART devices, the format supported by uart_parse_options() is the
> +expected one. In this case, the format of the string is:

Please drop the mention of uart_parse_options and just describe the
format. Linux internal details are irrelevant to the contract of the
binding.

Otherwise this looks good to me!

Thanks,
Mark.

> +
> +	<baud>{<parity>{<bits>{<flow>}}}
> +
> +where
> +
> +	baud	- baud rate in decimal
> +	parity	- 'n' (none), 'o', (odd) or 'e' (even)
> +	bits	- number of data bits
> +	flow	- 'r' (rts)
> +
> +For example: 115200n8r
> -- 
> 1.7.10.4
> 
> 
