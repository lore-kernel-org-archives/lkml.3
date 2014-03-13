Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbaCMR0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 13:26:20 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55183 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754122AbaCMR0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 13:26:13 -0400
Date: Thu, 13 Mar 2014 17:25:46 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Antoine =?utf-8?Q?T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
Cc: "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "zmxu@marvell.com" <zmxu@marvell.com>,
        "jszhang@marvell.com" <jszhang@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] ARM: dts: berlin2q: add the Marvell Armada 1500
 pro
Message-ID: <20140313172546.GB25870@e106331-lin.cambridge.arm.com>
References: <1394719607-25018-1-git-send-email-antoine.tenart@free-electrons.com>
 <1394719607-25018-2-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1394719607-25018-2-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 02:06:45PM +0000, Antoine Ténart wrote:
> Adds initial support for the Marvell Armada 1500 pro (BG2Q) SoC (Berlin family).
> The SoC has nodes for cpu, l2 cache controller, interrupt controllers, local
> timer, apb timers and uarts for now.
> 
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  arch/arm/boot/dts/berlin2q.dtsi | 167 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 167 insertions(+)
>  create mode 100644 arch/arm/boot/dts/berlin2q.dtsi
> 
> diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
> new file mode 100644
> index 000000000000..1cb76031dfe6
> --- /dev/null
> +++ b/arch/arm/boot/dts/berlin2q.dtsi
> @@ -0,0 +1,167 @@
> +/*
> + * Copyright (C) 2014 Antoine Ténart <antoine.tenart@free-electrons.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2. This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#include <dt-bindings/interrupt-controller/arm-gic.h>
> +
> +#include "skeleton.dtsi"
> +
> +/ {
> +	model = "Marvell Armada 1500 pro (BG2-Q) SoC";
> +	compatible = "marvell,berlin2q", "marvell,berlin";
> +
> +	cpus {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		cpu@0 {
> +			compatible = "arm,cortex-a9";
> +			device_type = "cpu";
> +			next-level-cache = <&l2>;
> +			reg = <0>;
> +		};
> +
> +		cpu@1 {
> +			compatible = "arm,cortex-a9";
> +			device_type = "cpu";
> +			next-level-cache = <&l2>;
> +			reg = <1>;
> +		};
> +
> +		cpu@2 {
> +			compatible = "arm,cortex-a9";
> +			device_type = "cpu";
> +			next-level-cache = <&l2>;
> +			reg = <2>;
> +		};
> +
> +		cpu@3 {
> +			compatible = "arm,cortex-a9";
> +			device_type = "cpu";
> +			next-level-cache = <&l2>;
> +			reg = <3>;
> +		};
> +	};
> +
> +	clocks {
> +		#address-cells = <0>;
> +		#size-cells = <0>;
> +
> +		smclk: sysmgr-clock {
> +			compatible = "fixed-clock";
> +			#clock-cells = <0>;
> +			clock-frequency = <25000000>;
> +		};
> +
> +		sysclk: system-clock {
> +			compatible = "fixed-clock";
> +			#clock-cells = <0>;
> +			clock-frequency = <400000000>;
> +		};
> +	};

I am very much not keen on having container nodes like this.

A "clocks" container is non-standard, and not guarantee to probe. The
fact these clocks probe currently is an artifact of the current
organisation of Linux rather than any conscious decision.

The #address-cells and #size-cells properties are useless, as no
address space is defined. The node is not a simple-bus, has no ranges,
and doesn't have a compatible string that implies an address space.

Is there any reason you need to use a clocks container here and can't
put these directly under the root?

> +
> +	soc {
> +		compatible = "simple-bus";
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +
> +		ranges = <0 0xf7000000 0x1000000>;
> +		interrupt-parent = <&gic>;
> +
> +		l2: l2-cache-controller@ac0000 {
> +			compatible = "arm,pl310-cache";
> +			reg = <0xac0000 0x1000>;
> +			cache-level = <2>;
> +		};
> +
> +		local-timer@ad0600 {
> +			compatible = "arm,cortex-a9-twd-timer";
> +			reg = <0xad0600 0x20>;
> +			clocks = <&sysclk>;
> +			interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_HIGH>;
> +			status = "okay";

Given that nodes are assumed by default to be okay, this can be dropped.

I think it only makes sense to have a status property in a common dtsi
where the value is "disabled".

Otherwise, this dtsi looks sane to me.

Thanks,
Mark.
