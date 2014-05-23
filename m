Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499AbaEWBf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 21:35:59 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:45908 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbaEWBf5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 21:35:57 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1400520171-6698-3-git-send-email-s.nawrocki@samsung.com>
Cc: linux@arm.linux.org.uk, robh+dt@kernel.org, grant.likely@linaro.org,
        mark.rutland@arm.com, galak@codeaurora.org, pawel.moll@arm.com,
        kyungmin.park@samsung.com, sw0312.kim@samsung.com,
        m.szyprowski@samsung.com, t.figa@samsung.com,
        linux-kernel@vger.kernel.org,
        "Sylwester Nawrocki" <s.nawrocki@samsung.com>
References: <1400520171-6698-1-git-send-email-s.nawrocki@samsung.com>
 <1400520171-6698-3-git-send-email-s.nawrocki@samsung.com>
Message-ID: <20140523013546.9521.55361@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH/RFC V6 2/2] clk: Add handling of clk parent and rate assigned
 from DT
Date: Thu, 22 May 2014 18:35:46 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sylwester Nawrocki (2014-05-19 10:22:51)
> diff --git a/Documentation/devicetree/bindings/clock/clock-bindings.txt b/Documentation/devicetree/bindings/clock/clock-bindings.txt
> index 700e7aa..bee649b 100644
> --- a/Documentation/devicetree/bindings/clock/clock-bindings.txt
> +++ b/Documentation/devicetree/bindings/clock/clock-bindings.txt
> @@ -132,3 +132,35 @@ clock signal, and a UART.
>    ("pll" and "pll-switched").
>  * The UART has its baud clock connected the external oscillator and its
>    register clock connected to the PLL clock (the "pll-switched" signal)
> +
> +==Assigned clock parents and rates==
> +
> +Some platforms require static initial configuration of default parent clocks
> +and clock frequecies. Such a configuration can be specified in a device node

s/frequecies/frequencies/

> +through clock-parents and clock-rates DT properties. The former should contain
> +a list of parent clocks in form of phandle and clock specifier pairs, the
> +latter the list of assigned clock frequency values (one cell each).
> +To skip setting parent or rate of a clock its corresponding entry should be
> +set to 0, or can be omitted if it is not followed by any non-zero entry.
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
> +In this example the pll is set as parent of "mux" clock and frequency of
> +"baud" clock is specified as 460800 Hz.
> +
> +Configuring a clock's parent and rate through the device node that consumes
> +the clock can be done only for clocks that have a single user. Specifying
> +conflicting parent or rate configuration in multiple consumer nodes for
> +a shared clock is forbidden.
> +
> +Configuration of common clocks, which affect multiple consumer devices can
> +be similarly specified in the clock provider node.

Is it worthwhile to show an example of this? I guess the outcome will
depend on whether or not we support "assigned-clocks" property, which I
just revisited in the V5 thread.

Regards,
Mike
