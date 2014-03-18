Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbaCRC0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 22:26:44 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:18930 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753108AbaCRC0m convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 22:26:42 -0400
Date: Tue, 18 Mar 2014 10:24:35 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Antoine =?UTF-8?B?VMOpbmFydA==?= 
	<antoine.tenart@free-electrons.com>
CC: "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        Jimmy Xu <zmxu@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 1/3] ARM: dts: berlin2q: add the Marvell Armada 1500
 pro
Message-ID: <20140318102435.2d29abc7@xhacker>
In-Reply-To: <1395068788-19786-2-git-send-email-antoine.tenart@free-electrons.com>
References: <1395068788-19786-1-git-send-email-antoine.tenart@free-electrons.com>
	<1395068788-19786-2-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-03-18_01:2014-03-17,2014-03-18,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=2
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1403170180
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Antoine,

On Mon, 17 Mar 2014 08:06:26 -0700
Antoine Ténart <antoine.tenart@free-electrons.com> wrote:

> Adds initial support for the Marvell Armada 1500 pro (BG2Q) SoC (Berlin
> family). The SoC has nodes for cpu, l2 cache controller, interrupt
> controllers, local timer, apb timers and uarts for now.
> 
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  arch/arm/boot/dts/berlin2q.dtsi | 210
> ++++++++++++++++++++++++++++++++++++++++ 1 file changed, 210 insertions(+)
>  create mode 100644 arch/arm/boot/dts/berlin2q.dtsi
> 
> diff --git a/arch/arm/boot/dts/berlin2q.dtsi
> b/arch/arm/boot/dts/berlin2q.dtsi new file mode 100644
> index 000000000000..7a50267b1044
> --- /dev/null
> +++ b/arch/arm/boot/dts/berlin2q.dtsi
> @@ -0,0 +1,210 @@
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
> +	smclk: sysmgr-clock {
> +		compatible = "fixed-clock";
> +		#clock-cells = <0>;
> +		clock-frequency = <25000000>;
> +	};
> +
> +	cpuclk: cpu-clock {
> +		compatible = "fixed-clock";
> +		#clock-cells = <0>;
> +		clock-frequency = <1200000000>;
> +	};
> +
> +	sysclk: system-clock {
> +		compatible = "fixed-factor-clock";
> +		#clock-cells = <0>;
> +		clocks = <&cpuclk>;
> +		clock-multi = <1>;
> +		clock-div = <3>;
> +	};

Can you please name it as twdclk to avoid confusion? On Berlin, sysclk is another
clk rather than the clk for twd. 
