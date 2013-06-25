Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab3FYVOv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 17:14:51 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:12552
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751594Ab3FYVOt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 17:14:49 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dIc89bh1432I4015Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh906i1155h192ch)
Date: Tue, 25 Jun 2013 14:14:43 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
CC: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stuart Menefy <stuart.menefy@st.com>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robherring2@gmail.com>, Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v6] clocksource:arm_global_timer: Add ARM global timer
 support.
References: <1372152678-29530-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1372152678-29530-1-git-send-email-srinivas.kandagatla@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <96d7573f-0991-4bda-8f4e-d1f36b743f95@VA3EHSMHS021.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Srinivas,

On Tue, Jun 25, 2013 at 10:31:18AM +0100, Srinivas KANDAGATLA wrote:
> From: Stuart Menefy <stuart.menefy@st.com>
> 
> This is a simple driver for the global timer module found in the Cortex
> A9-MP cores from revision r1p0 onwards. This should be able to perform
> the functions of the system timer and the local timer in an SMP system.
> 
> The global timer has the following features:
>     The global timer is a 64-bit incrementing counter with an
> auto-incrementing feature. It continues incrementing after sending
> interrupts. The global timer is memory mapped in the private memory
> region.
>     The global timer is accessible to all Cortex-A9 processors in the
> cluster. Each Cortex-A9 processor has a private 64-bit comparator that
> is used to assert a private interrupt when the global timer has reached
> the comparator value. All the Cortex-A9 processors in a design use the
> banked ID, ID27, for this interrupt. ID27 is sent to the Interrupt
> Controller as a Private Peripheral Interrupt. The global timer is
> clocked by PERIPHCLK.
> 
> Signed-off-by: Stuart Menefy <stuart.menefy@st.com>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
> CC: Arnd Bergmann <arnd@arndb.de>
> CC: Rob Herring <robherring2@gmail.com>
> CC: Linus Walleij <linus.walleij@linaro.org>
> CC: Will Deacon <will.deacon@arm.com>
> ---
> 
> Thankyou for reveiwing the v5 patch.
> This patch is split out of the orignal 10 patches submitted for Stixxxx SOC
> support to arm-kernel mailing list. This patch has undergone few cycles of
> reviews in arm-kernel mailing list.
> 
> This patch is generated on top of timers/core branch.
> 
> Arnd already picked up SOC support patches [4-10] and merged them via arm-soc
> tree for 3.11.
> 
> If its not too late can this patch be considered for 3.11 via clocksource tree?
> This patch has no build dependencies.
> 
> Thanks,
> srini
> 
> Changes since v5:
> 	- moved to using cpu notifiers as suggested by Stephen Boyd.
> 	- removed un-necessary headers as suggested by Stephen Boyd.
> 	- patch rebased on top of timers/core.
> 
> Changes since v4:
> 	All the comments are from Thomas G.
> 	- disabled irq and comp enable bits while setting one-shot mode.
> 	- remove double pointer usage of clock_event_device structure.
> 	- remove spaces from device name.
> 	- remove few un-necessary comments.
> 	- Fix error checks and error case handling in global_timer_of_register
> 
> Changes since v3:
> 	- Arnd suggested to replaced all __raw_readl/__raw_writel with
> 	readl/writel or readl_relaxed/writel_relaxed(for optimized path)
> 	as __raw* apis are not Endian safe.
> 
> Changes since v2:
> 	- cleaned up arm-global-timer code for non-dt as suggested by Linus W and
> 	- fixed minmum clock tick setting pointed by Linus W.
> 
> Changes since RFC:
> 	Most of the comments are suggested by Linus W.
> 	- moved to drivers/clocksource.
> 	- added revision check in driver.
> 	- removed unused header file.
> 	- moved to u64 from union gt_counter
> 	- comments added in get_counter
> 	- removed leftover debug code.
> 	- moved code to use __raw_readl/writel.
> 	- used DIV_ROUND_CLOSEST
> 	- added check in interrupt handler.
> 	- expanded CE and CS acronyms usage.
> 	- Fixed minimum clock ticks value.
> 	- move to use clocksource_register_hz
> 	- added arch sched_clock support.
> 	- added ERRATA 740657 workaround.
> 
>  .../devicetree/bindings/arm/global_timer.txt       |   21 ++
>  drivers/clocksource/Kconfig                        |   13 +
>  drivers/clocksource/Makefile                       |    1 +
>  drivers/clocksource/arm_global_timer.c             |  325 ++++++++++++++++++++
>  4 files changed, 360 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/arm/global_timer.txt
>  create mode 100644 drivers/clocksource/arm_global_timer.c
> 
> diff --git a/Documentation/devicetree/bindings/arm/global_timer.txt b/Documentation/devicetree/bindings/arm/global_timer.txt
> new file mode 100644
> index 0000000..b64abac
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/global_timer.txt
> @@ -0,0 +1,21 @@
> +
> +* ARM Global Timer
> +	Cortex-A9 are often associated with a per-core Global timer.
> +
> +** Timer node required properties:
> +
> +- compatible : Should be "arm,cortex-a9-global-timer"
> +		Driver supports versions r2p0 and above.
> +
> +- interrupts : One interrupt to each core
> +
> +- reg : Specify the base address and the size of the GT timer
> +	register window.
> +
> +Example:
> +
> +	timer@2c000600 {
> +		compatible = "arm,cortex-a9-global-timer";
> +		reg = <0x2c000600 0x20>;
> +		interrupts = <1 13 0xf01>;
> +	};
Isn't a 'clocks' entry missing here?

	Sören


