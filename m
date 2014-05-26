Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801AbaEZGbp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 02:31:45 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49327 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512AbaEZGbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 02:31:43 -0400
Message-ID: <5382DFE8.1080104@ti.com>
Date: Mon, 26 May 2014 09:32:08 +0300
From: Tero Kristo <t-kristo@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>, Nishanth Menon <nm@ti.com>,
        =?UTF-8?B?QmVub8OudCBDb3Vzc29u?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>, Paul <paul@pwsan.com>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 0/3] ARM: OMAP5+: Support Duty Cycle Correction(DCC)
References: <1400237160-25125-1-git-send-email-nm@ti.com> <20140523210720.23136.65858@quantum>
In-Reply-To: <20140523210720.23136.65858@quantum>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2014 12:07 AM, Mike Turquette wrote:
> Quoting Nishanth Menon (2014-05-16 03:45:57)
>> Hi,
>>
>> This patch series has been carried over in vendor kernel for quiet
>> few years now.
>>
>> Unfortunately, it was very recently re-discovered and upstream kernel
>> is noticed to be broken for OMAP5 1.5GHz - at least we are operating
>> DPLL at frequency higher than what it was intended to be when CPUFreq
>> is enabled. Thankfully, with nominal voltage(we dont use AVS yet in
>> upstream for the mentioned platforms) and margins in trimming, we
>> have so far not crashed - but I strongly suspect this might be some
>> boundary case survival.
>
> DCC also exists in OMAP4. In some cases customers used it, in other
> cases we just ran the PLL way out of spec and the mpu_clk would divide
> by 2.
>
> Is this broken for OMAP4 as well?

Yes, its broken. This series does not address the OMAP4 needs for it, 
but can be expanded later by just defining a proper clock type with 
OMAP4 specific DCC rate limits etc. for it. We would need properly 
functioning DVFS for OMAP4 panda first though I guess... (support for 
the TPS regulator.)

-Tero

>
> Regards,
> Mike
>
>>
>> Verified on the following impacted platforms using 3.15-rc4 based
>> vendor kernel.
>>
>> Before:
>> OMAP5432: http://slexy.org/view/s20cs0qQFg
>> DRA72x: http://slexy.org/view/s2TXtSa6mH (refused to lock)
>> DRA75x: http://slexy.org/view/s20AW8MU5c
>> After:
>> OMAP5432: http://slexy.org/view/s21iAfWxpu
>> DRA72x: http://slexy.org/view/s2hwsvGLmC (locks properly)
>> DRA75x: http://slexy.org/view/s21ehw8WQn
>>
>> Hopefully, we can get these into some kernel revision in some form.
>>
>> NOTE: Support for 4470(which is the only other platform requiring
>> DCC) is not present in upstream kernel and there are no plans to
>> support that SoC, even if it is added at a later point, support can be
>> extended as needed.
>>
>> Series based on v3.15-rc5 tag.
>> Also available on my tree:
>>          https://github.com/nmenon/linux-2.6-playground/
>>          branch:  push/clock/dcc
>>
>>          weblink: https://github.com/nmenon/linux-2.6-playground/commits/push/clock/dcc
>>
>> Verification:
>> 3.15-rc4 based kernel - DRA75x-evm, 72x-evm, OMAP5uevm
>> 3.15-rc5 - OMAP5uEVM(only one supporting 1.5GHz atm)
>>
>> Andrii Tseglytskyi (1):
>>    ARM: OMAP5+: dpll: support Duty Cycle Correction(DCC)
>>
>> Nishanth Menon (2):
>>    clk: dpll: support OMAP5 MPU DPLL that need special handling for
>>      higher frequencies
>>    ARM: dts: OMAP5/DRA7: use omap5-mpu-dpll-clock capable of dealing
>>      with higher frequencies
>>
>>   .../devicetree/bindings/clock/ti/dpll.txt          |    1 +
>>   arch/arm/boot/dts/dra7xx-clocks.dtsi               |    2 +-
>>   arch/arm/boot/dts/omap54xx-clocks.dtsi             |    2 +-
>>   arch/arm/mach-omap2/dpll3xxx.c                     |    9 +++++++++
>>   drivers/clk/ti/dpll.c                              |   21 ++++++++++++++++++++
>>   include/linux/clk/ti.h                             |    4 ++++
>>   6 files changed, 37 insertions(+), 2 deletions(-)
>>
>> Regards,
>> Nishanth Menon
>> --
>> 1.7.9.5
>>

