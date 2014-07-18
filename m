Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807AbaGRER1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 00:17:27 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:56874 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbaGRERZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 00:17:25 -0400
MIME-Version: 1.0
In-Reply-To: <2399813.Puj1SZWhCh@vostro.rjw.lan>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
	<20140717093518.486ac244@free-electrons.com>
	<CAKohpokZXUzXKRWBje7QF_jrvOd5dmfmWQ2Csf3xiMuvT_vPYA@mail.gmail.com>
	<2399813.Puj1SZWhCh@vostro.rjw.lan>
Date: Fri, 18 Jul 2014 09:47:24 +0530
Message-ID: <CAKohpomKzK8pMJs1gv+uXxhd17HtCQyfjSnVYw9KpGz6FwbgDA@mail.gmail.com>
Subject: Re: [PATCH 00/14] cpufreq: cpu0: Extend support beyond CPU0, V2
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Rob Herring <rob.herring@linaro.org>,
        Mike Turquette <mturquette@linaro.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Nishanth Menon <nm@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Simon Horman <horms@verge.net.au>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas P Abraham <thomas.ab@samsung.com>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Sachin Kamat <spk.linux@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 July 2014 06:32, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>> > only support the following cases:
>> >
>> >  * One clock for all CPUs
>> >  * One clock for each CPU
>>
>> Yeah, so I also proposed this yesterday that we stick to only these
>> two implementations for now. And was looking at how would the
>> cpufreq-generic driver come to know about this.
>>
>> So, one way out now is to see if "clocks" property is defined in
>> multiple cpu nodes, if yes don't compare them and consider separate
>> clocks for each cpu. We don't have to try matching that to any other
>> node, as that's a very bad idea. Mike was already very upset with that :)
>>
>> @Stephen/Rafael: Does that sound any better? Ofcourse the final thing
>> is to get bindings to figure out relations between CPUs..
>
> Before I apply anything in this area, I need a clear statement from the ARM
> people as a group on what the approach is going to be.

Thanks for your response Rafael.

Mike/Rob/Stephen: I believe Atleast three of you should express your views
now :)

So, this is what I propose:

- I will start another thread with a new DT binding, something like:

"clocks-ganged" = <&cpu0>

and then we can decide on naming/etc ..

- I will drop the patch which matches clock nodes from DT and introduce
another one that will just check if "clocks" is mentioned in more than one
CPU. If yes, then we behave as if all CPUs have separate clock lines.

That will work for Krait/mvebu and all existing users.

Does that sound good?

--
viresh
