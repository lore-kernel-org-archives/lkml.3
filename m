Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab3C1WYX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 18:24:23 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57290 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab3C1WYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 18:24:22 -0400
Message-ID: <5154C312.80807@wwwdotorg.org>
Date: Thu, 28 Mar 2013 16:24:18 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Colin Cross <ccross@google.com>, Ulf Hansson <ulf.hansson@linaro.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Bill Huang <bilhuang@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/1] clk: Add notifier support in clk_prepare/clk_unprepare
References: <1363699712-8124-1-git-send-email-bilhuang@nvidia.com> <20130319170140.8663.93388@quantum> <1363748149.8815.16.camel@bilhuang-vm1> <20130320033142.11073.30097@quantum> <1363754384.8815.42.camel@bilhuang-vm1> <20130320144752.11073.653@quantum> <CAPDyKFr+Hqi8Dge3Hn55JXbqEP358F3Eq1OHdYy=2JxucJHtJg@mail.gmail.com> <20130321223619.834.31998@quantum> <CAMbhsRSSknsEX_gwAzPtV8b8kGdZyTpLEoT2uXaDKoCbpr3cJg@mail.gmail.com> <20130328220109.13785.58488@quantum>
In-Reply-To: <20130328220109.13785.58488@quantum>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2013 04:01 PM, Mike Turquette wrote:
> Quoting Colin Cross (2013-03-21 17:06:25)
>> On Thu, Mar 21, 2013 at 3:36 PM, Mike Turquette <mturquette@linaro.org> wrote:
>>> To my knowledge, devfreq performs one task: implements an algorithm
>>> (typically one that loops/polls) and applies this heuristic towards a
>>> dvfs transition.
>>>
>>> It is a policy layer, a high level layer.  It should not be used as a
>>> lower-level mechanism.  Please correct me if my understanding is wrong.
>>>
>>> I think the very idea of the clk framework calling into devfreq is
>>> backwards.  Ideally a devfreq driver would call clk_set_rate as part of
>>> it's target callback.  This is analogous to a cpufreq .target callback
>>> which calls clk_set_rate and regulator_set_voltage.  Can you imagine the
>>> clock framework cross-calling into cpufreq when clk_set_rate is called?
>>> I think that would be strange.
>>>
>>> I think that all of this discussion highlights the fact that there is a
>>> missing piece of infrastructure.  It isn't devfreq or clock rate-change
>>> notifiers.  It is that there is not a dvfs mechanism which neatly builds
>>> on top of these lower-level frameworks (clocks & regulators).  Clearly
>>> some higher-level abstraction layer is needed.
>>
>> I went through all of this on Tegra2.  For a while I had a
>> dvfs_set_rate api for drivers that needed to modify the voltage when
>> they updated a clock, but I ended up dropping it.  Drivers rarely care
>> about the voltage, all they want to do is set their clock rate.  The
>> voltage necessary to support that clock is an implementation detail of
>> the silicon that is irrelevant to the driver
> 
> Hi Colin,
> 
> I agree about voltage scaling being an implementation detail,  but I
> think that drivers similarly do not care about enabling clocks, clock
> domains, power domains, voltage domains, etc.  The just want to say
> "give me what I need to turn on and run", and "I'm done with that stuff
> now, lazily turn off if you want to".  Runtime pm gives drivers that
> abstraction layer today.

I don't understand how runtime PM gives this abstraction today. All the
implementations of runtime PM that I've seen involve the driver itself
implementing its own runtime PM callbacks, and explicitly managing the
clocks itself. I don't see how that hides those details from the driver.
Have I been looking at runtime PM implementations that aren't
implemented philosophically correctly?
