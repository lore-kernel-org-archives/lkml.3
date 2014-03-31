Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbaCaRFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 13:05:04 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:52586 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753014AbaCaRFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 13:05:02 -0400
Message-ID: <5339A036.6090703@codethink.co.uk>
Date: Mon, 31 Mar 2014 18:04:54 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.3.0
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org, gregkh@linuxfoundation.org,
        mturquette@linaro.org, linux@arm.linux.org.uk, robh+dt@kernel.org,
        grant.likely@linaro.org, mark.rutland@arm.com, galak@codeaurora.org,
        kyungmin.park@samsung.com, sw0312.kim@samsung.com,
        m.szyprowski@samsung.com, t.figa@samsung.com,
        laurent.pinchart@ideasonboard.com, s.hauer@pengutronix.de
Subject: Re: [PATCH RFC v4 2/2] clk: Add handling of clk parent and rate assigned
 from DT
References: <1396284116-19178-1-git-send-email-s.nawrocki@samsung.com> <1396284116-19178-3-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1396284116-19178-3-git-send-email-s.nawrocki@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/03/14 17:41, Sylwester Nawrocki wrote:
> This function adds a helper function to configure clock parents and rates
> as specified in clock-parents, clock-rates DT properties for a consumer
> device and a call to it before driver is bound to a device.

[snip]

tree/bindings/clock/clock-bindings.txt 
b/Documentation/devicetree/bindings/clock/clock-bindings.txt
> index 700e7aa..59fbb4e 100644
> --- a/Documentation/devicetree/bindings/clock/clock-bindings.txt
> +++ b/Documentation/devicetree/bindings/clock/clock-bindings.txt
> @@ -132,3 +132,45 @@ clock signal, and a UART.
>     ("pll" and "pll-switched").
>   * The UART has its baud clock connected the external oscillator and its
>     register clock connected to the PLL clock (the "pll-switched" signal)
> +
> +==Assigned clock parents and rates==
> +
> +Some platforms require static initial configuration of parts of the clocks
> +controller. Such a configuration can be specified in a clock consumer node
> +through clock-parents and clock-rates DT properties. The former should
> +contain a list of parent clocks in form of phandle and clock specifier pairs,
> +the latter the list of assigned clock frequency values (one cell each).
> +
> +    uart@a000 {
> +        compatible = "fsl,imx-uart";
> +        reg = <0xa000 0x1000>;
> +        ...
> +        clocks = <&clkcon 0>, <&clkcon 3>;
> +        clock-names = "baud", "mux";
> +
> +        clock-parents = <0>, <&pll 1>;
> +        clock-rates = <460800>;
> +    };
> +
> +In this example the pll is set as parent of "mux" clock and frequency of "baud"
> +clock is specified as 460800 Hz.
> +
> +Configuring a clock parent and rate through the device node that uses
> +the clock can be done only for clocks that have a single user. Specifying
> +conflicting parent or rate configuration in multiple consumer nodes for
> +a shared clock is forbidden.
> +
> +Configuration of common clocks, which affect multiple consumer devices
> +can be specified in a dedicated 'assigned-clocks' subnode of a clock
> +provider node, e.g.:
> +
> +    clkcon {
> +        ...
> +        #clock-cells = <1>;
> +
> +        assigned-clocks {
> +            clocks = <&clkcon 16>, <&clkcon 17>;
> +            clock-parents = <0>, <&clkcon 1>;
> +            clock-rates = <200000>;
> +        };
> +    };

How do you support not-setting a rate for a clock?

[snip code]

-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
