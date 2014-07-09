Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbaGIRlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 13:41:40 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:45352 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbaGIRlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 13:41:37 -0400
Message-ID: <53BD7ECF.8010408@codeaurora.org>
Date: Wed, 09 Jul 2014 10:41:35 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Sachin Kamat <spk.linux@gmail.com>,
        Thomas P Abraham <thomas.ab@samsung.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, Tomasz Figa <t.figa@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Rob Herring <rob.herring@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH 00/14] cpufreq: cpu0: Extend support beyond CPU0, V2
References: <cover.1404231535.git.viresh.kumar@linaro.org> <CAKohpomRttWnCBGEpR3cVsGYniJSnjWUnvtbg21AiYyrUnDjGw@mail.gmail.com> <53B4B0B3.9080000@codeaurora.org> <CAKohponRv6+rzJnO4cYFhXn6On1+4-KoxFSA2iU_nz130gvsug@mail.gmail.com> <20140703221609.11380.6884@quantum> <CAKohpomNv_xvcmx03pb8nj=3O33Qt-2Dj2B1q3U46mv5EBtUjA@mail.gmail.com> <CAKohpo=Z5gEHOC5q40q8dfQfoNP5-WyhjG1arV99zJiG2c+6Xg@mail.gmail.com>
In-Reply-To: <CAKohpo=Z5gEHOC5q40q8dfQfoNP5-WyhjG1arV99zJiG2c+6Xg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/14 21:50, Viresh Kumar wrote:
> On 4 July 2014 09:51, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> Yeah, having something like what you suggested from DT is the perfect
>> solution to get over this. The only reason why I am not touching that here
>> is to not delay other patches just because of that.
>>
>> There are separate threads going on for that and probably somebody
>> else was trying to push for that.
>>
>> That's it, nothing more. I would definitely like to use those bindings instead
>>  of the crazy routines we are trying here, once that is finalized :)
> Do we have some kind of agreement for this temporary solution? Anyways
> I will kick the other thread again to resolve the bindings soon.
>
> @Stephen: Do you still want find_rate_changer() stuff in this series only
> and or this can go into 3.17 without anymore changes and lets finalize
> the bindings Mike suggested and then update this code?
>
>

Finding the rate change is not necessary for me. I don't imagine my code
will be getting into 3.17 anyway though so I'm no in a rush to merge
anything immediately.

I still prefer the common clock framework API. If we go ahead with the
find_rate_changer() stuff we've pretty well insulated this driver from
any DTisms, which is nice. The only thing left would be
transition-latency and voltage-tolerance, but those are already optional
so you really don't need to even run on a DT enabled platform to use
this code.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

