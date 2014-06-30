Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272AbaF3F5H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 01:57:07 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45853 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150AbaF3F5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 01:57:05 -0400
Message-ID: <53B0FC27.5040002@ti.com>
Date: Mon, 30 Jun 2014 08:56:55 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Javier Martinez Canillas <javier@dowhile0.org>
CC: Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        <ldewangan@nvidia.com>, <linux-doc@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, Rob Herring <robh+dt@kernel.org>
Subject: Re: [RESEND 2/2] clk: Add driver for Palmas clk32kg and clk32kgaudio
 clocks
References: <1403848871-26519-1-git-send-email-peter.ujfalusi@ti.com>	<1403848871-26519-3-git-send-email-peter.ujfalusi@ti.com> <CABxcv=metB4=eoT=fAh7S-b_mhAvHcJtn2wrV8v8koSyKMxNNw@mail.gmail.com>
In-Reply-To: <CABxcv=metB4=eoT=fAh7S-b_mhAvHcJtn2wrV8v8koSyKMxNNw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Javier,

On 06/27/2014 09:23 PM, Javier Martinez Canillas wrote:
> Hello Peter,
> 
> On Fri, Jun 27, 2014 at 8:01 AM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
>> Palmas class of devices can provide 32K clock(s) to be used by other devices
>> on the board. Depending on the actual device the provided clocks can be:
>> CLK32K_KG and CLK32K_KGAUDIO
>> or only one:
>> CLK32K_KG (TPS659039 for example)
>>
>> Use separate compatible flags for the two 32K clock.
>> A system which needs or have only one of the 32k clock from
>> Palmas will need to add node(s) for each clock as separate section
>> in the dts file.
>> The two compatible property is:
>> "ti,palmas-clk32kg" for clk32kg clock
>> "ti,palmas-clk32kgaudio" for clk32kgaudio clock
>>
>> Apart from the register control of the clocks - which is done via
>> the clock API there is a posibility to enable the external sleep
>> control. In this way the clock can be enabled/disabled on demand by the
>> user of the clock.
>>
>> See the documentation for more details.
>>
>> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
>> Reviewed-by: Nishanth Menon <nm@ti.com>

>> +static unsigned long palmas_clks_recalc_rate(struct clk_hw *hw,
>> +                                            unsigned long parent_rate)
>> +{
>> +       return 32768;
>> +}
> 
> I see that other clock drivers using a constant rate return 0 if the
> clock has not been enabled.

and there are examples when similar fixed clock drivers returns only the clock
value, like clk-max77686. I can not find clear guidelines neither in the
documentation or around the header/c files for this.
Mike, what is the appropriate way of handling the recalc_rate?

> So maybe is more correct to have something
> like the following?
> 
> if (__clk_is_enabled(hw->clk))
>         return 32768;
> else
>         return 0;
> 
> Best regards,
> Javier
> 


-- 
Péter
