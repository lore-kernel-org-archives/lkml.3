Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934858Ab3DHGLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 02:11:45 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:63733 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761287Ab3DHGLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 02:11:43 -0400
Message-ID: <51625F9A.1050308@gmail.com>
Date: Mon, 08 Apr 2013 08:11:38 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Dom Cobley <popcornmix@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rabeeh Khoury <rabeeh@solid-run.com>, Daniel Mack <zonque@gmail.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        Lars-Peter Clausen <lars@metafoo.de>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [v5] clk: add si5351 i2c common clock driver
References: <1365139415-17815-1-git-send-email-sebastian.hesselbarth@gmail.com> <20130407225046.GA16326@roeck-us.net> <51620604.4070204@gmail.com> <20130408001725.GA16648@roeck-us.net>
In-Reply-To: <20130408001725.GA16648@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2013 02:17 AM, Guenter Roeck wrote:
> On Mon, Apr 08, 2013 at 01:49:24AM +0200, Sebastian Hesselbarth wrote:
>> On 04/08/2013 12:50 AM, Guenter Roeck wrote:
>>> On Fri, Apr 05, 2013 at 05:23:35AM -0000, Sebastian Hesselbarth wrote:
>>>> This patch adds a common clock driver for Silicon Labs Si5351a/b/c
>>>> i2c programmable clock generators. Currently, the driver supports
>>>> DT kernels only and VXCO feature of si5351b is not implemented. DT
>>>> bindings selectively allow to overwrite stored Si5351 configuration
>>>> which is very helpful for clock generators with empty eeprom
>>>> configuration. Corresponding device tree binding documentation is
>>>> also added.
>>>>
>>>> Signed-off-by: Sebastian Hesselbarth<sebastian.hesselbarth@gmail.com>
>>>> Tested-by: Daniel Mack<zonque@gmail.com>
>>>>
>>> [ ... ]
>>>
>>>> +static inline void _si5351_msynth_set_pll_master(
>>>> +	struct si5351_driver_data *drvdata, unsigned char num, int is_master)
>>>> +{
>>>> +	unsigned long flags;
>>>> +
>>>> +	if (num>   8 ||
>>>> +	    (drvdata->variant == SI5351_VARIANT_A3&&   num>   3))
>>>> +		return;
>>>> +
>>>> +	flags = __clk_get_flags(drvdata->msynth[num].hw.clk);
>>>> +	if (is_master)
>>>> +		flags |= CLK_SET_RATE_PARENT;
>>>> +	else
>>>> +		flags&= ~CLK_SET_RATE_PARENT;
>>>> +	__clk_set_flags(drvdata->msynth[num].hw.clk, flags);
>>>> +}
>>>> +
>>> Unless I am missing something, neither __clk_get_flags() nor the new
>>> __clk_set_flags is exported.
>>>
>>> Did you try to build and load the driver as module ?
>>
>> Well, good catch. I didn't try to build v5 as a module, but I guess it
>> will fail. But I consider this as something that has to be addressed in
>> clk framework itself, not in this patch. There will be other
>> clk-providers built as module in the future for sure.
>>
> Sure, but you provided the patch to make __clk_set_flags global. To avoid
> build failures, I would suggest to either submit a patch to export the
> missing functions, or to remove the ability to build the driver as module.

Actually, I knew that __clk_set_flags patch will not be accepted before 
posting it ;)

> On a side note, do you happen to know anyone working on drivers for Si5319 or
> Si5368 ?

No.

> Thanks,
> Guenter

