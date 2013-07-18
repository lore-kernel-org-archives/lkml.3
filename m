Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933909Ab3GRTFL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 15:05:11 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59404 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933317Ab3GRTFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:05:08 -0400
Message-ID: <51E83C46.3040000@ti.com>
Date: Thu, 18 Jul 2013 14:04:38 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sricharan R <r.sricharan@ti.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <rnayak@ti.com>, <balbi@ti.com>
Subject: Re: [PATCH 2/3] ARM: dts: DRA: Add crossbar device binding
References: <1374165830-6367-1-git-send-email-r.sricharan@ti.com> <1374165830-6367-3-git-send-email-r.sricharan@ti.com>
In-Reply-To: <1374165830-6367-3-git-send-email-r.sricharan@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 11:43 AM, Sricharan R wrote:
> This adds the irq/dma crossbar device nodes.
>
> There is a IRQ and DMA crossbar device in the soc, which
> maps the irq/dma requests from the peripherals to the
> mpu/dsp/ipu/eve interrupt and sdma/edma controller's inputs.
> The Peripheral irq/dma requests are connected to only one crossbar
> input and the output of the crossbar is connected to only one
> controller's input line. On POR, there are some mappings which
> are done by default. Those peripherals which do not have a
> mapping on POR, should be configured to route its requests
> using the crossbar control registers.
>

What is POR? Plan on Record? I supppose, we just love our TLA?

> The irq/dma mapping for some peripherals are
> added with the crossbar nodes here.
>
> Signed-off-by: Sricharan R <r.sricharan@ti.com>
> ---
>   arch/arm/boot/dts/dra7.dtsi |   19 +++++++++++++++++++
>   1 file changed, 19 insertions(+)
>
> diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
> index a5d9350..e6208b4 100644
> --- a/arch/arm/boot/dts/dra7.dtsi
> +++ b/arch/arm/boot/dts/dra7.dtsi
> @@ -85,6 +85,25 @@
>   		ranges;
>   		ti,hwmods = "l3_main_1", "l3_main_2";
>
> +		crossbar_mpu: mpuirq@4a002a48 {
> +			compatible = "crossbar";
> +			crossbar-name = "mpu-irq";
> +			reg = <0x4a002a48 0x0130>;
> +			reg-width = <16>;
> +			crossbar-lines = "mpu-irq", "rtc-ss-alarm", <0x9f 0xd9 0x12c>,
> +					 "mpu-irq", "mcasp3-arevt", <0x9e 0x96 0x12a>,
> +					 "mpu-irq", "mcasp3-axevt", <0x9d 0x97 0x128>;

a) I'd like to use UART10. oh, let me guess: we dont map all cross bar 
options here.. just "certain ones"
b) I like to use random 6 uarts out of the available 10 uarts on the fly.
c) I'd like to use IRQCROSS bar such that i use all the hardware block 
instances that dont have default GIC IRQ mapping.


> +		};
> +
> +		crossbar_dma: dmareq@4a002b78 {
> +			compatible = "crossbar";
> +			crossbar-name = "dma-req";
> +			reg = <0x4a002b78 0x0100>;
> +			reg-width = <16>;
> +			crossbar-lines = "dma-req", "mcasp3-rx", <0x7e 0x84 0xfc>,
> +					 "dma-req", "mcasp3-tx", <0x7d 0x85 0xfa>;
> +		};
> +
>   		counter32k: counter@4ae04000 {
>   			compatible = "ti,omap-counter32k";
>   			reg = <0x4ae04000 0x40>;
>


-- 
Regards,
Nishanth Menon
