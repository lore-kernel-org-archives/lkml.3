Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbaGBJQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 05:16:57 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:52961 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbaGBJQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 05:16:54 -0400
MIME-Version: 1.0
X-Originating-IP: [95.23.59.197]
In-Reply-To: <20140702043338.23338.31600@quantum>
References: <1403848871-26519-1-git-send-email-peter.ujfalusi@ti.com>
	<1403848871-26519-3-git-send-email-peter.ujfalusi@ti.com>
	<CABxcv=metB4=eoT=fAh7S-b_mhAvHcJtn2wrV8v8koSyKMxNNw@mail.gmail.com>
	<53B0FC27.5040002@ti.com>
	<20140702043338.23338.31600@quantum>
Date: Wed, 2 Jul 2014 11:16:53 +0200
Message-ID: <CABxcv==Ut40bQg22hWuXmMgHF7b_iLfJuLHrdGds1B3wXb74ug@mail.gmail.com>
Subject: Re: [RESEND 2/2] clk: Add driver for Palmas clk32kg and clk32kgaudio clocks
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>, linux-doc@vger.kernel.org,
        Nishanth Menon <nm@ti.com>, Rob Herring <robh+dt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mike,

On Wed, Jul 2, 2014 at 6:33 AM, Mike Turquette <mturquette@linaro.org> wrote:
> Quoting Peter Ujfalusi (2014-06-29 22:56:55)
>> Hi Javier,
>>
>> On 06/27/2014 09:23 PM, Javier Martinez Canillas wrote:
>> > Hello Peter,
>> >
>> > On Fri, Jun 27, 2014 at 8:01 AM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
>> >> Palmas class of devices can provide 32K clock(s) to be used by other devices
>> >> on the board. Depending on the actual device the provided clocks can be:
>> >> CLK32K_KG and CLK32K_KGAUDIO
>> >> or only one:
>> >> CLK32K_KG (TPS659039 for example)
>> >>
>> >> Use separate compatible flags for the two 32K clock.
>> >> A system which needs or have only one of the 32k clock from
>> >> Palmas will need to add node(s) for each clock as separate section
>> >> in the dts file.
>> >> The two compatible property is:
>> >> "ti,palmas-clk32kg" for clk32kg clock
>> >> "ti,palmas-clk32kgaudio" for clk32kgaudio clock
>> >>
>> >> Apart from the register control of the clocks - which is done via
>> >> the clock API there is a posibility to enable the external sleep
>> >> control. In this way the clock can be enabled/disabled on demand by the
>> >> user of the clock.
>> >>
>> >> See the documentation for more details.
>> >>
>> >> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
>> >> Reviewed-by: Nishanth Menon <nm@ti.com>
>>
>> >> +static unsigned long palmas_clks_recalc_rate(struct clk_hw *hw,
>> >> +                                            unsigned long parent_rate)
>> >> +{
>> >> +       return 32768;
>> >> +}
>> >
>> > I see that other clock drivers using a constant rate return 0 if the
>> > clock has not been enabled.
>>
>> and there are examples when similar fixed clock drivers returns only the clock
>> value, like clk-max77686. I can not find clear guidelines neither in the
>> documentation or around the header/c files for this.
>> Mike, what is the appropriate way of handling the recalc_rate?
>
> You are right that there are no guidelines stating, "don't do that", but
> please, "don't do that" ;-)
>
> clk_enable and clk_set_rate are entirely unrelated operations from the
> perspective of the Linux clock framework, and mixing these two classes
> of operations is a recipe for pain.
>

Thanks a lot for the clarification. I just asked since when posting a
clock driver I got feedback that recalc_rate should return 0 if the
clock was disabled and also saw some drivers doing that, e.g:
drivers/clk/clk-s2mps11.c

>>
>> > So maybe is more correct to have something
>> > like the following?
>> >
>> > if (__clk_is_enabled(hw->clk))
>> >         return 32768;
>> > else
>> >         return 0;
>
> So what happens here if this is gateable clock and later on we call
> clk_enable on it? The clocks rate will still be zero since
> clk_enable/clk_disable do not touch the rate at all.
>

Got it, thanks for the explanation.

> Regards,
> Mike
>

Best regards,
Javier
