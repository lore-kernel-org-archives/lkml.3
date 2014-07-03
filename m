Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbaGCHh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 03:37:59 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:33739 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907AbaGCHh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 03:37:57 -0400
MIME-Version: 1.0
In-Reply-To: <20140702223552.7440.60829@quantum>
References: <1403798144-32188-1-git-send-email-wens@csie.org> <20140702223552.7440.60829@quantum>
From: Chen-Yu Tsai <wens@csie.org>
Date: Thu, 3 Jul 2014 15:37:36 +0800
X-Google-Sender-Auth: yo5ffIUYYO6Lio4nZ3E5BKfpfNA
Message-ID: <CAGb2v67ceT8X-zmB7ULPg6Kqd8PRpmo0x_Vu9iF4s_6euXg_FQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] clk: sunxi: fixes, cleanups and A23 basic clocks
To: Mike Turquette <mturquette@linaro.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Emilio Lopez <emilio@elopez.com.ar>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 3, 2014 at 6:35 AM, Mike Turquette <mturquette@linaro.org> wrote:
> Quoting Chen-Yu Tsai (2014-06-26 08:55:38)
>> Hi everyone,
>>
>> This is v4 of the sun8i clock series, which adds basic clock
>> support for the A23 SoC. It is based on my initial sun8i bring
>> up series [1]. This series was split up from the original A23
>> series [2]. Yet to come are more clocks, reset controllers,
>> prcm, pinctrl, and mmc.
>
> Hello Chen-Yu,
>
> This series looks good to me.

Thanks. Assuming no one else raises any issues, I consider this
series merged. I'll send the next sun8i series later today.

The remaining series still have some clock patches, so thanks
in advance.


Cheers
ChenYu


> Maxime,
>
> I see that you Acked it already. Are you planning to roll this into a
> pull request later on?
>
> Regards,
> Mike
>
>>
>> The first patch fixes the reworked clock protection code merged in
>> 3.16-rc1, which unintentionally made clock gates unprotectable.
>>
>> The second patch moves the remaining "ahb_sdram" clock to the
>> protected clock list, now that it works.
>>
>> The third patch adds support for factor clocks that have an N factor
>> not starting from 0. This is found on some PLLs in A31/A23.
>>
>> The fourth patch adds table-based dividers for div clocks, as some
>> clocks, such as apb0 divider on sun4/5/7i, apb1 on sun6/8i and axi
>> on sun8i.
>>
>> The fifth patch adds support for the basic clocks in the A23, just
>> PLL1 for cpus, and the system bus clocks and gates.
>>
>> The last patch adds the DT nodes for the newly added clocks, and
>> updates clock phandles for existing peripherals, the uarts.
>>
>> Originally I intended for patch 1 to be merged as a fix for 3.16.
>> However, the only user of the affected code, sun6i's "ahb1_sdram"
>> clock, doesn't seem to result in any runtime issues. So this whole
>> series can go into 3.17.
>>
>>
>> Related changes since v3:
>>
>>   - Dropped fields with default values from sun8i_a23_axi_div_data
>>   - Added Maxime's Acked-by
>>   - Fixed incorrect compatible string for axi clock node
>>   - Updated clock phandles for uarts in dtsi
>>
>> Related changes since v2:
>>
>>   - Rewrote factor clocks to support any (0~255) N factor starting value
>>
>> Related changes since v1:
>>
>>   - Added "clk: sunxi: Add support for table-based divider clocks"
>>   - Added table-based divider axi clock
>>   - Fixed incorrectly squashed fixups
>>
>>
>> Cheers
>> ChenYu
>>
>>
>>   [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-June/265211.html
>>   [2] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-May/259097.html
>>
>> Chen-Yu Tsai (6):
>>   clk: sunxi: register clock gates with clkdev
>>   clk: sunxi: move "ahb_sdram" to protected clock list
>>   clk: sunxi: Support factor clocks with N factor starting not from 0
>>   clk: sunxi: Add support for table-based divider clocks
>>   clk: sunxi: Add A23 clocks support
>>   ARM: sun8i: Add basic clock nodes to the DTSI
>>
>>  Documentation/devicetree/bindings/clock/sunxi.txt |   5 +
>>  arch/arm/boot/dts/sun8i-a23.dtsi                  | 125 +++++++++++++++++++++-
>>  drivers/clk/sunxi/clk-factors.c                   |   2 +-
>>  drivers/clk/sunxi/clk-factors.h                   |   1 +
>>  drivers/clk/sunxi/clk-sunxi.c                     | 119 ++++++++++++++++++--
>>  5 files changed, 237 insertions(+), 15 deletions(-)
>>
>> --
>> 2.0.0
>>
