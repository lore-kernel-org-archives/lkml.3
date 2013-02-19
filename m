Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab3BSJxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 04:53:41 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:55506 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab3BSJxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 04:53:39 -0500
Message-ID: <51234B8E.2000504@gmail.com>
Date: Tue, 19 Feb 2013 10:53:18 +0100
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Afzal Mohammed <x0148406@ti.com>
Subject: Re: Question about fixed-clock
References: <5122BF88.1050007@gmail.com> <CAOMZO5BXVX8=QOV4+tN_w27ztSVkHAnOG2ifbS_Jpd=-cPnAdw@mail.gmail.com>
In-Reply-To: <CAOMZO5BXVX8=QOV4+tN_w27ztSVkHAnOG2ifbS_Jpd=-cPnAdw@mail.gmail.com>
X-Enigmail-Version: undefined
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabio,
Hi Afzal,

On 19.02.2013 02:33, Fabio Estevam wrote:
> On Mon, Feb 18, 2013 at 8:55 PM, Daniel Mack <zonque@gmail.com> wrote:
>> Hi,
>>
>> This might be a stupid question, but I'm somehow stuck here. I'm using a
>> driver with the following DTS sub-node:
>>
>>         ref25: ref25M {
>>                 compatible = "fixed-clock";
>>                 #clock-cells = <0>;
>>                 clock-frequency = <25000000>;
>>         };
>>
>>         clock-generator@0 {
>>                                 /* ... */
>>                                 #clock-cells = <1>;
>>                                 clocks = <&ref25>;
>>         }
>>
>> The device driver for clock-generator uses something like the following
>> call to get its clock:
>>
>>         clk = of_clk_get(np, 0);
>>
>> but the return value is ERR_PTR(-ENOENT) and I also can't find this
>> clock in the clk debugfs tree.
>>
>> This is on a OMAP/AM33xx device with kernel 3.8-rc7 plus the -next tips
>> of arm-soc and omap, but with no other special clock options selected in
>> the config. Is there anything I'm missing to correctly instantiate the
>> dummy clock?
> 
> Have you registered it with clk_register_fixed_rate() ?
> 
> In imx we use imx_clk_fixed, which in turns call  clk_register_fixed_rate().
> 
> Take a look at arch/arm/mach-imx/clk-imx51-imx53.c for a reference.

Hmm no, I didn't do anything else than adding it to the DT in the first
place, hoping that a driver will pick it up and add the clock for me.
But it turns out that of_clk_init() is not called at all on my platform.

I'm doing this now from omap_generic_init() and it works. If that's an
appropriate place to call it, I can provide a patch.


Thanks,
Daniel

