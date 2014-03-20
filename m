Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760166AbaCTXdi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 19:33:38 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53185 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759420AbaCTXdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 19:33:36 -0400
Date: Fri, 21 Mar 2014 00:33:33 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: berlin: add scu and chipctrl device nodes for
 BG2/BG2Q
Message-ID: <20140320233333.GY12021@piout.net>
References: <1395347986-30203-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1395347986-30203-2-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395347986-30203-2-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/03/2014 at 21:39:45 +0100, Sebastian Hesselbarth wrote :
> This adds scu and general purpose registers device nodes required for
> SMP on Berlin BG2 and BG2Q SoCs. The secondary CPUs will pick their jump
> address from general purpose (SW generic) register 1.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

> ---
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> Cc: Kumar Gala <galak@codeaurora.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Antoine Tenart <antoine.tenart@free-electrons.com>
> Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> Cc: devicetree@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/boot/dts/berlin2.dtsi  | 10 ++++++++++
>  arch/arm/boot/dts/berlin2q.dtsi | 10 ++++++++++
>  2 files changed, 20 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/berlin2.dtsi b/arch/arm/boot/dts/berlin2.dtsi
> index 56a1af2f1052..4d85312dc17a 100644
> --- a/arch/arm/boot/dts/berlin2.dtsi
> +++ b/arch/arm/boot/dts/berlin2.dtsi
> @@ -72,6 +72,11 @@
>  			cache-level = <2>;
>  		};
>  
> +		scu: snoop-control-unit@ad0000 {
> +			compatible = "arm,cortex-a9-scu";
> +			reg = <0xad0000 0x58>;
> +		};
> +
>  		gic: interrupt-controller@ad1000 {
>  			compatible = "arm,cortex-a9-gic";
>  			reg = <0xad1000 0x1000>, <0xad0100 0x0100>;
> @@ -176,6 +181,11 @@
>  			};
>  		};
>  
> +		generic-regs@ea0184 {
> +			compatible = "marvell,berlin-generic-regs", "syscon";
> +			reg = <0xea0184 0x10>;
> +		};
> +
>  		apb@fc0000 {
>  			compatible = "simple-bus";
>  			#address-cells = <1>;
> diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
> index 07452a7483fa..86d8a2c49f38 100644
> --- a/arch/arm/boot/dts/berlin2q.dtsi
> +++ b/arch/arm/boot/dts/berlin2q.dtsi
> @@ -87,6 +87,11 @@
>  			cache-level = <2>;
>  		};
>  
> +		scu: snoop-control-unit@ad0000 {
> +			compatible = "arm,cortex-a9-scu";
> +			reg = <0xad0000 0x58>;
> +		};
> +
>  		local-timer@ad0600 {
>  			compatible = "arm,cortex-a9-twd-timer";
>  			reg = <0xad0600 0x20>;
> @@ -183,6 +188,11 @@
>  			};
>  		};
>  
> +		generic-regs@ea0110 {
> +			compatible = "marvell,berlin-generic-regs", "syscon";
> +			reg = <0xea0110 0x10>;
> +		};
> +
>  		apb@fc0000 {
>  			compatible = "simple-bus";
>  			#address-cells = <1>;
> -- 
> 1.9.0
> 

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
