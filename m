Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab3FKHbi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 03:31:38 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16759 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab3FKHbh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 03:31:37 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 11 Jun 2013 00:30:10 -0700
Message-ID: <51B6D239.5030905@nvidia.com>
Date: Tue, 11 Jun 2013 13:01:05 +0530
From: Prashant Gaikwad <pgaikwad@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Paul Walmsley <pwalmsley@nvidia.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Aleksandr Frid <afrid@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/3] clk: tegra: T114: add DFLL DVCO reset control
References: <20130607121505.21868.72360.stgit@dusk.lan> <20130607121901.21868.65416.stgit@dusk.lan> <51B21105.1080301@wwwdotorg.org> <alpine.DEB.2.02.1306071703050.7753@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.02.1306071703050.7753@utopia.booyaka.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 June 2013 10:36 PM, Paul Walmsley wrote:
> Hi Stephen,
>
> On Fri, 7 Jun 2013, Stephen Warren wrote:
>
>> On 06/07/2013 06:19 AM, Paul Walmsley wrote:
>>> Add DFLL DVCO reset line control functions to the CAR IP block driver.
>>>
>>> The DVCO present in the DFLL IP block has a separate reset line,
>>> exposed via the CAR IP block.  This reset line is asserted upon SoC
>>> reset.  Unless something (such as the DFLL driver) deasserts this
>>> line, the DVCO will not oscillate, although reads and writes to the
>>> DFLL IP block will complete.
>>>
>>> Thanks to Aleksandr Frid <afrid@nvidia.com> for identifying this and
>>> saving hours of debugging time.
>>> diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
>>>   void tegra114_clock_tune_cpu_trimmers_high(void);
>>>   void tegra114_clock_tune_cpu_trimmers_low(void);
>>>   void tegra114_clock_tune_cpu_trimmers_init(void);
>>> +void tegra114_clock_assert_dfll_dvco_reset(void);
>>> +void tegra114_clock_deassert_dfll_dvco_reset(void);
>> Where/what is the code that will call these new APIs? If it's going to
>> be something in drivers/clk, that seems fine.
> That's correct - they'll be used by the DFLL clocksource code, which will
> live in drivers/clk/tegra.  You've seen the patches already ;-)

Why not implement these APIs in DFLL clock driver itself and pass RST 
address register to driver?

>> The reset assert/de-assert functions at least might be worth exposing
>> using the new generic module reset API. I believe Prashant Gaikwad is
>> working on converting the Tegra clock driver to be a module reset
>> provider, hence removing the existing custom
>> tegra_periph_reset_{de,}assert() APIs.
> OK, will take a look to see if this can be done without getting in the way
> of Prashant's work.  I'd naïvely assume that it might be best to convert
> these as part of his series - that way we won't duplicate effort.
>
> Prashant, what stage are you at in the conversion?  If you're close to
> completion, maybe we can just add this functionality in with your patches?
>

You can continue with this patch. I do not see any need to add this 
reset control to generic reset module.

> - Paul

