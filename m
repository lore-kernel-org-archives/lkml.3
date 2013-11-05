Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab3KEJPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 04:15:52 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:59738 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab3KEJPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 04:15:47 -0500
X-AuditID: cbfec7f4-b7f0a6d000007b1b-4f-5278b741c142
Message-id: <5278B73F.1090508@samsung.com>
Date: Tue, 05 Nov 2013 13:15:43 +0400
From: Tarek Dakhran <t.dakhran@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.0
MIME-version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>
Cc: linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Mike Turquette <mturquette@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Heiko Stuebner <heiko@sntech.de>,
        Naour Romain <romain.naour@openwide.fr>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v2 2/4] clk: exynos5410: register clocks using common clock
 framework
References: <1381763305-7085-1-git-send-email-v.tyrtov@samsung.com>
 <1381763305-7085-3-git-send-email-v.tyrtov@samsung.com>
 <1421095.b3lQaz2kV9@flatron>
In-reply-to: <1421095.b3lQaz2kV9@flatron>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t/xK7qO2yuCDFb18FlMWneAyWLeZ1mL
	+UfOsVr8f/Sa1eLcq5WMFr0LrrJZbHp8jdViYdsSFovLu+awWcw4v4/J4vZlXoul1y8yWTyd
	cJHNYsL0tSwWh1cAzVj3cjqLxZafHYwWrw62sVhs3jSV2WLVrj+MFlNn/GB3EPVYM28No0dL
	cw+bx4LPV9g9/q56weyxc9Zddo+Vy7+webxaPZPV4861PWwe786dY/fYvKTe49U1Fo++LasY
	PbZfm8fs8XmTnMfGuaEB/FFcNimpOZllqUX6dglcGZ93v2Ir2Ctc8eHtM+YGxs/8XYycHBIC
	JhJ/V35lg7DFJC7cWw9kc3EICSxllJj26T4rhPOeUeLBh+UsIFW8AloSZ2dvYASxWQRUJa5+
	fcnexcjBwSagLbFlhxdIWFQgTOJo009WiHJBiR+T74G1iggES+zYuYoZZCazwHFWiUedz9lA
	eoUFoiXm3OCG2DWHUWL3io9MIA2cApoSiw/uYQexmQWsJVZO2sYIYctLbF7zlnkCo8AsJDtm
	ISmbhaRsASPzKkbR1NLkguKk9FxDveLE3OLSvHS95PzcTYyQaP6yg3HxMatDjAIcjEo8vA/O
	lgcJsSaWFVfmHmKU4GBWEuGtqawIEuJNSaysSi3Kjy8qzUktPsTIxMEp1cAobfp1zvurLF77
	C7/qOfGdetGtuHfqRee1WUfDk24e87yflMAXZi0d92FWys+ow9pTqgKcw9Ln3nT0zKpfsHbD
	6QNbds6rfFku8E6m5SyT2qInn0OLuReeP+LguO7hBct9WwUua+qziv56nNF6RWhDIu+hLc+d
	Jr+06PON+Hg7wbTU4OXfkDe7lFiKMxINtZiLihMBhKTU0MQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 01.11.2013 20:58, Tomasz Figa wrote:
> Hi,
>
> On Monday 14 of October 2013 19:08:23 Vyacheslav Tyrtov wrote:
>> From: Tarek Dakhran <t.dakhran@samsung.com>
>>
>> The EXYNOS5410 clocks are statically listed and registered
>> using the Samsung specific common clock helper functions.
>>
>> Signed-off-by: Tarek Dakhran <t.dakhran@samsung.com>
>> Signed-off-by: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
>> ---
>>   .../devicetree/bindings/clock/exynos5410-clock.txt |  37 +++
>>   drivers/clk/samsung/Makefile                       |   1 +
>>   drivers/clk/samsung/clk-exynos5410.c               | 251
>> +++++++++++++++++++++ include/dt-bindings/clock/exynos5410.h
>>   | 175 ++++++++++++++ 4 files changed, 464 insertions(+)
>>   create mode 100644
>> Documentation/devicetree/bindings/clock/exynos5410-clock.txt create
>> mode 100644 drivers/clk/samsung/clk-exynos5410.c
>>   create mode 100644 include/dt-bindings/clock/exynos5410.h
> The driver looks pretty good now, thanks for addressing my comments to
> previous version. There are still few issues remaining, though. Please see
> my comments inline.
>
> [snip]
>> diff --git a/drivers/clk/samsung/clk-exynos5410.c
>> b/drivers/clk/samsung/clk-exynos5410.c new file mode 100644
>> index 0000000..c5eba08
>> --- /dev/null
>> +++ b/drivers/clk/samsung/clk-exynos5410.c
> [snip]
>> +static struct of_device_id ext_clk_match[] __initdata = {
>> +	{ .compatible = "samsung,clock-oscclk", .data = (void *)0, },
>> +	{ },
>> +};
> I don't see anything in binding documentation mentioning this compatible
> value. Anyway, since there is already a generic binding for fixed rate
> clocks, this shouldn't be needed at all.
>
>> +
>> +/* register exynos5410 clocks */
>> +static void __init exynos5410_clk_init(struct device_node *np)
>> +{
>> +	void __iomem *reg_base;
>> +
>> +	reg_base = of_iomap(np, 0);
>> +	if (!reg_base)
>> +		panic("%s: failed to map registers\n", __func__);
>> +
>> +	samsung_clk_init(np, reg_base, CLK_NR_CLKS,
>> +			exynos5410_clk_regs,
> ARRAY_SIZE(exynos5410_clk_regs),
>> +			NULL, 0);
>> +	samsung_clk_of_register_fixed_ext(exynos5410_frt_ext_clks,
>> +			ARRAY_SIZE(exynos5410_frt_ext_clks),
>> +			ext_clk_match);
> This call could be dropped after moving to generic fixed rate clock
> bindings.
>
> Best regards,
> Tomasz

Already done. Will be added in patch v3.


Thank you for comments, Tomasz.

Best regards,
     Tarek Dakhran
