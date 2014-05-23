Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbaEWLUx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 07:20:53 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35898 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640AbaEWLUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 07:20:51 -0400
Message-ID: <537F2F2C.3070202@ti.com>
Date: Fri, 23 May 2014 14:21:16 +0300
From: Tero Kristo <t-kristo@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>,
        =?ISO-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Mike Turquette <mturquette@linaro.org>, Paul <paul@pwsan.com>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 0/3] ARM: OMAP5+: Support Duty Cycle Correction(DCC)
References: <1400237160-25125-1-git-send-email-nm@ti.com>
In-Reply-To: <1400237160-25125-1-git-send-email-nm@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2014 01:45 PM, Nishanth Menon wrote:
> Hi,
>
> This patch series has been carried over in vendor kernel for quiet
> few years now.
>
> Unfortunately, it was very recently re-discovered and upstream kernel
> is noticed to be broken for OMAP5 1.5GHz - at least we are operating
> DPLL at frequency higher than what it was intended to be when CPUFreq
> is enabled. Thankfully, with nominal voltage(we dont use AVS yet in
> upstream for the mentioned platforms) and margins in trimming, we
> have so far not crashed - but I strongly suspect this might be some
> boundary case survival.
>
> Verified on the following impacted platforms using 3.15-rc4 based
> vendor kernel.
>
> Before:
> OMAP5432: http://slexy.org/view/s20cs0qQFg
> DRA72x: http://slexy.org/view/s2TXtSa6mH (refused to lock)
> DRA75x: http://slexy.org/view/s20AW8MU5c
> After:
> OMAP5432: http://slexy.org/view/s21iAfWxpu
> DRA72x: http://slexy.org/view/s2hwsvGLmC (locks properly)
> DRA75x: http://slexy.org/view/s21ehw8WQn
>
> Hopefully, we can get these into some kernel revision in some form.

Thanks, queued for 3.16/ti-clk-drv. Anybody on the delivery feel free to 
yell if you got any complaints.

-Tero

>
> NOTE: Support for 4470(which is the only other platform requiring
> DCC) is not present in upstream kernel and there are no plans to
> support that SoC, even if it is added at a later point, support can be
> extended as needed.
>
> Series based on v3.15-rc5 tag.
> Also available on my tree:
> 	https://github.com/nmenon/linux-2.6-playground/
> 	branch:  push/clock/dcc
> 	
> 	weblink: https://github.com/nmenon/linux-2.6-playground/commits/push/clock/dcc
>
> Verification:
> 3.15-rc4 based kernel - DRA75x-evm, 72x-evm, OMAP5uevm
> 3.15-rc5 - OMAP5uEVM(only one supporting 1.5GHz atm)
>
> Andrii Tseglytskyi (1):
>    ARM: OMAP5+: dpll: support Duty Cycle Correction(DCC)
>
> Nishanth Menon (2):
>    clk: dpll: support OMAP5 MPU DPLL that need special handling for
>      higher frequencies
>    ARM: dts: OMAP5/DRA7: use omap5-mpu-dpll-clock capable of dealing
>      with higher frequencies
>
>   .../devicetree/bindings/clock/ti/dpll.txt          |    1 +
>   arch/arm/boot/dts/dra7xx-clocks.dtsi               |    2 +-
>   arch/arm/boot/dts/omap54xx-clocks.dtsi             |    2 +-
>   arch/arm/mach-omap2/dpll3xxx.c                     |    9 +++++++++
>   drivers/clk/ti/dpll.c                              |   21 ++++++++++++++++++++
>   include/linux/clk/ti.h                             |    4 ++++
>   6 files changed, 37 insertions(+), 2 deletions(-)
>
> Regards,
> Nishanth Menon
>

