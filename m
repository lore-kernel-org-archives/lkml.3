Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbaEHDl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 23:41:27 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:52446 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbaEHDlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 23:41:24 -0400
MIME-Version: 1.0
In-Reply-To: <20140508031700.GO7047@lukather>
References: <1399483554-8824-1-git-send-email-boris.brezillon@free-electrons.com>
 <1399483554-8824-8-git-send-email-boris.brezillon@free-electrons.com> <20140508031700.GO7047@lukather>
From: Chen-Yu Tsai <wens@csie.org>
Date: Thu, 8 May 2014 11:40:59 +0800
X-Google-Sender-Auth: cy7eaY5kDImjgDZu206gZhmoQZw
Message-ID: <CAGb2v664vFwezKVp+C1UYdsUktRhrZDxjsyf9L=kwVHGCUV=HA@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] ARM: sunxi: dt: add PRCM clk and reset controller subdevices
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        =?UTF-8?Q?Emilio_L=C3=B3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shuge <shuge@allwinnertech.com>, kevin <kevin@allwinnertech.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        devicetree <devicetree@vger.kernel.org>, linux-doc@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, dev <dev@linux-sunxi.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 8, 2014 at 11:17 AM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> On Wed, May 07, 2014 at 07:25:54PM +0200, Boris BREZILLON wrote:
>> Add DT definitions for PRCM (Power/Reset/Clock Management) clock and reset
>> controller subdevices.
>>
>> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
>> ---
>>  arch/arm/boot/dts/sun6i-a31.dtsi | 39 ++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 38 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/boot/dts/sun6i-a31.dtsi b/arch/arm/boot/dts/sun6i-a31.dtsi
>> index ec3253a..b69be0b 100644
>> --- a/arch/arm/boot/dts/sun6i-a31.dtsi
>> +++ b/arch/arm/boot/dts/sun6i-a31.dtsi
>> @@ -498,9 +498,46 @@
>>                       reg = <0x01f01c00 0x300>;
>>               };
>>
>> -             prcm@01f01c00 {
>> +             prcm@01f01400 {
>
> This has already been fixed by Hans.
>
>>                       compatible = "allwinner,sun6i-a31-prcm";
>>                       reg = <0x01f01400 0x200>;
>> +
>> +                     ar100: ar100_clk {
>> +                             compatible = "allwinner,sun6i-a31-ar100-clk";
>> +                             #clock-cells = <0>;
>> +                             clocks = <&osc32k>, <&osc24M>, <&pll6>, <&pll6>;
>> +                     };
>> +
>> +                     ahb0: ahb0_clk {
>> +                             compatible = "fixed-factor-clock";
>> +                             #clock-cells = <0>;
>> +                             clock-div = <1>;
>> +                             clock-mult = <1>;
>> +                             clocks = <&ar100>;
>> +                             clock-output-names = "ahb0";
>> +                     };
>> +
>> +                     apb0: apb0_clk {
>> +                             compatible = "allwinner,sun6i-a31-apb0-clk";
>> +                             #clock-cells = <0>;
>> +                             clocks = <&ahb0>;
>> +                             clock-output-names = "apb0";
>> +                     };
>> +
>> +                     apb0_gates: apb0_gates_clk {
>> +                             compatible = "allwinner,sun6i-a31-apb0-gates-clk";
>> +                             #clock-cells = <1>;
>> +                             clocks = <&apb0>;
>> +                             clock-output-names = "apb0_pio", "apb0_ir",
>> +                                             "apb0_timer01", "apb0_p2wi",
>
> timer01 ? is this a typo?

A23 manual lists the clock gate as "r_timer0_1", so I put the name on the wiki.
Allwinner sun6i code uses "r_tmr" or just "tmr". I see no problem naming this
clock output as "apb0_timer" though.

>> +                                             "apb0_uart", "apb0_1wire",
>> +                                             "apb0_i2c";
>> +                     };
>> +
>> +                     apb0_rst: apb0_rst {
>> +                             compatible = "allwinner,sun6i-a31-clock-reset";
>> +                             #reset-cells = <1>;
>> +                     };
>>               };
>>       };
>>  };
>> --
>> 1.8.3.2
>>
