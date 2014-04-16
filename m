Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305AbaDPTEE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 15:04:04 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:55018 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051AbaDPTEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 15:04:00 -0400
Message-ID: <534ED41A.3000202@gmail.com>
Date: Wed, 16 Apr 2014 21:03:54 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: berlin: add scu and chipctrl device nodes for
 BG2/BG2Q
References: <1395347986-30203-1-git-send-email-sebastian.hesselbarth@gmail.com> <1395347986-30203-2-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1395347986-30203-2-git-send-email-sebastian.hesselbarth@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2014 09:39 PM, Sebastian Hesselbarth wrote:
> This adds scu and general purpose registers device nodes required for
> SMP on Berlin BG2 and BG2Q SoCs. The secondary CPUs will pick their jump
> address from general purpose (SW generic) register 1.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Applied to berlin/dt.

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
> 

