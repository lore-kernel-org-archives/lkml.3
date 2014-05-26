Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbaEZJnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 05:43:37 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:32785 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbaEZJnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 05:43:35 -0400
MIME-Version: 1.0
In-Reply-To: <20140525185101.GQ10768@lukather>
References: <1400831485-28576-1-git-send-email-wens@csie.org>
 <1400831485-28576-5-git-send-email-wens@csie.org> <20140525185101.GQ10768@lukather>
From: Chen-Yu Tsai <wens@csie.org>
Date: Mon, 26 May 2014 17:43:14 +0800
X-Google-Sender-Auth: hI6uhbVJhCjFvmyIZACG6vDcyyE
Message-ID: <CAGb2v64T6QYu1YNYMkd-R-=uK1XSR0-jKC5W6drK+9yHTrp6JQ@mail.gmail.com>
Subject: Re: [PATCH 04/22] clk: sunxi: move "ahb_sdram" to protected clock list
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 2:51 AM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> On Fri, May 23, 2014 at 03:51:07PM +0800, Chen-Yu Tsai wrote:
>> With sunxi_gates clocks registered with clkdev, we can use the
>> protected clocks list to enable the "ahb_sdram" clock, instead
>> of looking for it and adding CLK_IGNORE_UNUSED inline in the
>> clock setup code.
>>
>> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
>> ---
>>  drivers/clk/sunxi/clk-sunxi.c | 10 ++++------
>>  1 file changed, 4 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
>> index 3e33bc1..b2c6d12 100644
>> --- a/drivers/clk/sunxi/clk-sunxi.c
>> +++ b/drivers/clk/sunxi/clk-sunxi.c
>> @@ -870,7 +870,6 @@ static void __init sunxi_gates_clk_setup(struct device_node *node,
>>       int qty;
>>       int i = 0;
>>       int j = 0;
>> -     int ignore;
>>
>>       reg = of_iomap(node, 0);
>>
>> @@ -891,15 +890,12 @@ static void __init sunxi_gates_clk_setup(struct device_node *node,
>>               of_property_read_string_index(node, "clock-output-names",
>>                                             j, &clk_name);
>>
>> -             /* No driver claims this clock, but it should remain gated */
>> -             ignore = !strcmp("ahb_sdram", clk_name) ? CLK_IGNORE_UNUSED : 0;
>> -
>>               clk_data->clks[i] = clk_register_gate(NULL, clk_name,
>> -                                                   clk_parent, ignore,
>> +                                                   clk_parent, 0,
>>                                                     reg + 4 * (i/32), i % 32,
>>                                                     0, &clk_lock);
>>               WARN_ON(IS_ERR(clk_data->clks[i]));
>> -             clk_register_clkdev(clks[i], clk_name, NULL);
>> +             clk_register_clkdev(clk_data->clks[i], clk_name, NULL);
>
> I'm fine with the change itself, but shouldn't this part of it be in
> the patch that actually add this line?
>
> Looks broken to me otherwise.

Brain fart on my part. I squashed a fixup for patch 2 into this one.


Thanks
ChenYu
