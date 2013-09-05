Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab3IEUvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 16:51:16 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:56500 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab3IEUvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 16:51:14 -0400
Message-ID: <5228EEBE.5070102@gmail.com>
Date: Thu, 05 Sep 2013 22:51:10 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Mike Turquette <mturquette@linaro.org>, Kumar Gala <galak@codeaurora.org>,
        devicetree@vger.kernel.org,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tero Kristo <t-kristo@ti.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Matt Sealey <neko@bakuhatsu.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        ian campbell <ian.campbell@citrix.com>,
        Mark Rutland <Mark.Rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>
Subject: Re: [PATCH v4 3/5] clk: dt: binding for basic multiplexer clock
References: <1377150793-27864-1-git-send-email-mturquette@linaro.org> <1377150793-27864-4-git-send-email-mturquette@linaro.org> <2A930389-012E-45C3-93EB-6B4A41DB2EF5@codeaurora.org> <20130829011425.8231.78802@quantum> <39BAF1F8-41AD-4667-BF76-22BDF709415A@codeaurora.org> <20130830203334.10934.10011@quantum> <522110AA.7040700@wwwdotorg.org> <20130903232219.10934.67434@quantum> <52277DBF.7080104@wwwdotorg.org> <CAPtuhThWHP61FzDBCH5SSFx6kV7==VdF3-M=Lke+cgnrOQL7JQ@mail.gmail.com> <5228EA02.3000200@wwwdotorg.org>
In-Reply-To: <5228EA02.3000200@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2013 10:30 PM, Stephen Warren wrote:
> On 09/05/2013 12:29 PM, Mike Turquette wrote:
>> >  On Wed, Sep 4, 2013 at 11:36 AM, Stephen Warren<swarren@wwwdotorg.org>  wrote:
>>> >>  On 09/03/2013 05:22 PM, Mike Turquette wrote:
>>>> >>>  Quoting Stephen Warren (2013-08-30 14:37:46)
>>>>> >>>>  On 08/30/2013 02:33 PM, Mike Turquette wrote:
>>> >>  ...
>>>>>> >>>>>  The clock_data_  seems to always have some churn to it. Moving it out to
>>>>>> >>>>>  DT reduces that churn from Linux. My concern above is not about kernel
>>>>>> >>>>>  data size.
>>>>> >>>>
>>>>> >>>>  That sounds like the opposite of what we should be doing.
>>>>> >>>>
>>>>> >>>>  It's fine for kernel code/data to change; that's a natural part of
>>>>> >>>>  development. Obviously, we should minimize churn, through thorough
>>>>> >>>>  review, domain knowledge, etc.
>>>> >>>
>>>> >>>  And with the "clock mapping" style bindings we'll end up changing both
>>>> >>>  the DT binding definition and the kernel. Not great.
>>> >>
>>> >>  What's a "clock mapping" style binding? I guess that means the style
>>> >>  where you have a single DT node that provides multiple clocks, rather
>>> >>  than one DT node per clock?
>>> >>
>>> >>  If the kernel driver changes its internal data, I don't see why that
>>> >>  would have any impact at all on the DT binding definition. We should be
>>> >>  able to use one DT binding definition with arbitrary drivers.
>> >
>> >  Yes, I'm referring to a single node providing multiple clocks. As an
>> >  example see the Exynos 5420 binding:
>> >  Documentation/devicetree/bindings/clock/exynos5420-clock.txt
>> >
>> >  The clock id's are stored as part of the binding definition resulting
>> >  in a mapping scheme that can be fragile.
>
> The mapping shouldn't be fragile if e.g.
> include/dt-bindings/clock/exynos5420.h were used to define the values.
> That way, both the Exynos clock driver and Exynos DT files could both
> include the header, and would always be in sync.

It was our intention to have things done this way since first time the idea
of the preprocessor support in dtc was proposed, and since very initial
versions of the exynos clocks driver. I took some time but there have been
recently already posted patches moving the values definition to common
headers [1].

[1] http://www.spinics.net/lists/arm-kernel/msg271807.html

--
Thanks,
Sylwester
