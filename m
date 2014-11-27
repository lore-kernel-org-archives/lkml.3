Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342AbaK0P6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 10:58:25 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:50071 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbaK0P6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 10:58:23 -0500
MIME-Version: 1.0
Reply-To: cw00.choi@samsung.com
In-Reply-To: <3844465.a5d3AtOSOo@wuerfel>
References: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
	<2150099.t3m9xROUE3@wuerfel>
	<CAGTfZH1C28s7trTh9+PhrnLnmJ9vpsKtAA61ASK-LA_1d_cihg@mail.gmail.com>
	<3844465.a5d3AtOSOo@wuerfel>
Date: Fri, 28 Nov 2014 00:58:22 +0900
Message-ID: <CAGTfZH1fXVVT0594wRRKerrRmXRp6weWTkZymErAnbP3ntdMug@mail.gmail.com>
Subject: Re: [PATCH 11/19] clk: samsung: exynos5433: Add clocks for
 CMU_BUS{0|1|2} domains
From: Chanwoo Choi <cwchoi00@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "inki.dae@samsung.com" <inki.dae@samsung.com>,
        "chanho61.park@samsung.com" <chanho61.park@samsung.com>,
        "geunsik.lim@samsung.com" <geunsik.lim@samsung.com>,
        "sw0312.kim@samsung.com" <sw0312.kim@samsung.com>,
        "jh80.chung@samsung.com" <jh80.chung@samsung.com>,
        "a.kesavan@samsung.com" <a.kesavan@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 12:51 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 28 November 2014 00:44:07 Chanwoo Choi wrote:
>> >
>> >> +#define bus_div_clks(num)                        \
>> >> +static struct samsung_div_clock bus##num_div_clks[] __initdata = {    \
>> >> +    /* DIV_BUS */                            \
>> >> +    DIV(CLK_DIV_PCLK_BUS##num_133, "div_pclk_bus"#num"_133",    \
>> >> +            "aclk_bus"#num"_400", DIV_BUS##num, 0, 3),    \
>> >> +};                                    \
>> >
>> > To illustrate my point further: CLK_DIV_PCLK_BUS0/1/2 are all the
>> > same, and so are DIV_BUS0/1/2, so you should not need to duplicate
>> > the definitions at all but just call them 'CLK_DIV_PCLK_BUS'
>> > and 'DIV_BUS'.
>>
>> CLK_DIV_PCLK_BUS0/1/2 is not all the same.
>> Each CLK_DIV_PCLK_BUS0/1/2 must need the unique clock number.
>> Because some device may need some clocks by using unique clock number.
>
> This is from your original patch:
>
> +/* CMU_BUS0 */
> +#define CLK_DIV_PCLK_BUS0_133                          1
> +
> +#define CLK_ACLK_AHB2APB_BUS0P                         2
> +#define CLK_ACLK_BUS0NP_133                            3
> +#define CLK_ACLK_BUS0ND_400                            4
> +#define CLK_PCLK_BUS0SRVND_133                         5
> +#define CLK_PCLK_PMU_BUS0                              6
> +#define CLK_PCLK_SYSREG_BUS0                           7
> +
> +#define BUS0_NR_CLK                                    8
> +
> +/* CMU_BUS1 */
> +#define CLK_DIV_PCLK_BUS1_133                          1
> +
> +#define CLK_ACLK_AHB2APB_BUS1P                         2
> +#define CLK_ACLK_BUS1NP_133                            3
> +#define CLK_ACLK_BUS1ND_400                            4
> +#define CLK_PCLK_BUS1SRVND_133                         5
> +#define CLK_PCLK_PMU_BUS1                              6
> +#define CLK_PCLK_SYSREG_BUS1                           7
> +
> +#define BUS1_NR_CLK                                    8
> +
> +/* CMU_BUS2 */
> +#define CLK_MOUT_ACLK_BUS2_400_USER                    1
> +
> +#define CLK_DIV_PCLK_BUS2_133                          2
> +
> +#define CLK_ACLK_AHB2APB_BUS2P                         3
> +#define CLK_ACLK_BUS2NP_133                            4
> +#define CLK_ACLK_BUS2BEND_400                          5
> +#define CLK_ACLK_BUS2RTND_400                          6
> +#define CLK_PCLK_BUS2SRVND_133                         7
> +#define CLK_PCLK_PMU_BUS2                              8
> +#define CLK_PCLK_SYSREG_BUS2                           9
> +
> +#define BUS2_NR_CLK                                    10
>
>
> The numbers are arbitrarily assigned, but for bus0 and bus1,
> they are all identical, while bus2 uses a lightly different
> numbering, which you could easily change, e.g. by using the
> numbers you have for bus2 on bus0 and bus1 as well.

OK, I'll remove duplicate clock number due to the same on other clock domain.

If use only CLK_DIV_PCLK_BUS instead of CLK_DIV_PCLK_BUS0/1/2,
I think I have to use three compatible string for each CMU_BUSx domain
as following:.

clocks = <&cmu_bus0 CLK_DIV_PCLK_BUS>;
clocks = <&cmu_bus1 CLK_DIV_PCLK_BUS>;
clocks = <&cmu_bus2 CLK_DIV_PCLK_BUS>;

>
> + * Register offset definitions for CMU_BUS0
> + */
> +#define DIV_BUS0                       0x0600
> +#define DIV_STAT_BUS0                  0x0700
> +#define ENABLE_ACLK_BUS0               0x0800
> +#define ENABLE_PCLK_BUS0               0x0900
> +#define ENABLE_IP_BUS0                 0x0b00
> +#define ENABLE_IP_BUS1                 0x0b04
> +
>
> +/*
> + * Register offset definitions for CMU_BUS1
> + */
> +#define DIV_BUS1                       0x0600
> +#define DIV_STAT_BUS1                  0x0700
> +#define ENABLE_ACLK_BUS1               0x0800
> +#define ENABLE_PCLK_BUS1               0x0900
> +#define ENABLE_IP_BUS10                        0x0b00
> +#define ENABLE_IP_BUS11                        0x0b04
>
> +/*
> + * Register offset definitions for CMU_BUS2
> + */
> +#define MUX_SEL_BUS2                   0x0200
> +#define MUX_ENABLE_BUS2                        0x0300
> +#define MUX_STAT_BUS2                  0x0400
> +#define DIV_BUS2                       0x0600
> +#define DIV_STAT_BUS2                  0x0700
> +#define ENABLE_ACLK_BUS2               0x0800
> +#define ENABLE_PCLK_BUS2               0x0900
> +#define ENABLE_IP_BUS20                        0x0b00
> +#define ENABLE_IP_BUS21                        0x0b04
>
> More importantly, the register offsets are all identical, except that
> bus2 has the additional MUX_SEL and MUX_ENABLE definitions. It's very
> obvious that this is the same hardware block in multiple instances.

You're right. I'll remove duplicate offset definition.

Best Regards,
Chanwoo Choi
