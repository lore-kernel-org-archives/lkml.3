Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab3KKS5m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 13:57:42 -0500
Received: from service87.mimecast.com ([91.220.42.44]:54645 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab3KKS5f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 13:57:35 -0500
Message-ID: <528128A8.9060400@arm.com>
Date: Mon, 11 Nov 2013 18:57:44 +0000
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>, Mark Rutland <Mark.Rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
CC: Sudeep.KarkadaNagesha@arm.com,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/7] arm: dt: zynq: Add 'cpus' node
References: <1383945677-29674-1-git-send-email-soren.brinkmann@xilinx.com> <1383945677-29674-3-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1383945677-29674-3-git-send-email-soren.brinkmann@xilinx.com>
X-OriginalArrivalTime: 11 Nov 2013 18:57:31.0085 (UTC) FILETIME=[DFB297D0:01CEDF0F]
X-MC-Unique: 113111118573204401
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/13 21:21, Soren Brinkmann wrote:
> Add a 'cpus' node to describe the CPU cores of Zynq.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> Acked-by: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
> ---
>  arch/arm/boot/dts/zynq-7000.dtsi | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
> index 27ebc1ba9671..37fc04525142 100644
> --- a/arch/arm/boot/dts/zynq-7000.dtsi
> +++ b/arch/arm/boot/dts/zynq-7000.dtsi
> @@ -15,6 +15,33 @@
>  / {
>  	compatible = "xlnx,zynq-7000";
>  
> +	cpus {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		cpu@0 {
> +			compatible = "arm,cortex-a9";
> +			device_type = "cpu";
> +			reg = <0>;
> +			clocks = <&clkc 3>;
> +			i-cache-size = <0x8000>;
> +			i-cache-line-size = <0x20>;
> +			d-cache-size = <0x8000>;
> +			d-cache-line-size = <0x20>;

These cache properties can be identified through CCSIDR(Cache Size ID Registers)
on ARMv7 Cortex implementations. It's better not to have these in DT if they can
be identified runtime.

Regards,
Sudeep


