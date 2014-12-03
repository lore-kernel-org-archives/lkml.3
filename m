Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519AbaLCCY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 21:24:57 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:53086 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbaLCCYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 21:24:54 -0500
Message-ID: <547E7455.6090009@gmail.com>
Date: Tue, 02 Dec 2014 18:24:21 -0800
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Leif Lindholm <leif.lindholm@linaro.org>
CC: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, mark.rutland@arm.com, andrew@lunn.ch,
        s.hauer@pengutronix.de, robh+dt@kernel.org, ijc@debian.org,
        grant.likely@linaro.org, plagnioj@jcrosoft.com, frowand.list@gmail.com
Subject: Re: [PATCH v3 1/3] devicetree: of: Add bindings for chosen node,
 stdout-path
References: <1417110967-16284-1-git-send-email-leif.lindholm@linaro.org> <1417110967-16284-2-git-send-email-leif.lindholm@linaro.org>
In-Reply-To: <1417110967-16284-2-git-send-email-leif.lindholm@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2014 9:56 AM, Leif Lindholm wrote:
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

The code in patch 3/3 adds the extra options feature to the properties:

  stdout-path
  linux,stdout-path
  stdout  [if (IS_ENABLED(CONFIG_PPC) ... ]

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
> 

