Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165Ab3J2Pq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 11:46:29 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:36157 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab3J2PqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 11:46:25 -0400
Message-ID: <526FD849.9050000@samsung.com>
Date: Tue, 29 Oct 2013 08:46:17 -0700
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Tomasz Figa <t.figa@samsung.com>
CC: Mike Turquette <mturquette@linaro.org>, Kukjin Kim <kgene.kim@samsung.com>,
        mark.rutland@arm.com, swarren@wwwdotorg.org, linux-doc@vger.kernel.org,
        viresh.kumar@linaro.org, Tomasz Figa <tomasz.figa@gmail.com>,
        s.nawrocki@samsung.com, m.szyprowski@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux@arm.linux.org.uk,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>,
        linux-pm@vger.kernel.org, kyungmin.park@samsung.com,
        cpufreq@vger.kernel.org, thomas.abraham@linaro.org,
        t.stanislaws@samsung.com, devicetree@vger.kernel.org,
        pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
        rob.herring@calxeda.com, rjw@sisk.pl, ben-linux@fluff.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        b.zolnierkie@samsung.com, rob@landley.net
Subject: Re: [PATCH v5 0/3] ARM: S5PV210: move to common clk framework
References: <1380027009-2239-1-git-send-email-m.krawczuk@partner.samsung.com> <5264425E.4040301@samsung.com> <20131021121605.11944.74007@quantum> <1823897.8rOixkM4PW@amdc1227>
In-Reply-To: <1823897.8rOixkM4PW@amdc1227>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/13 04:42, Tomasz Figa wrote:
> Hi Kukjin, Mike,
>
> On Monday 21 of October 2013 05:16:05 Mike Turquette wrote:
>> Quoting Kukjin Kim (2013-10-20 13:51:42)
>>> On 10/20/13 01:03, Tomasz Figa wrote:
>>>> Hi Mike, Kukjin, Rafael,
>>>>
>>>> On Tuesday 24 of September 2013 14:50:06 Mateusz Krawczuk wrote:
>>>>> This patch series is the new s5pv210 clock implementation
>>>>> (using common clk framework).
>>>>>
>>>>> This implementation is compatible with device tree definition and board
>>>>> files.
>>>>>
>>>>> This patch series is based on linux-next and has been tested on goni and
>>>>> aquila
>>>>> boards using board file.
>>>>>
>>>>> Since v4:
>>>>> Corrected mux flags for finpll.
>>>>>
>>>>> Since v3:
>>>>>
>>>>> Replace s5pv210_clk_register_finpll, by creating mux finpll
>>>>> with xusbxti and xxti as parrents.
>>>>>
>>>>>
>>>>> Mateusz Krawczuk (3):
>>>>>     clk: samsung: Add clock driver for s5pc110/s5pv210
>>>>>     Cpufreq: s5pv210 cpufreq fixes for CCF
>>>>>     ARM: s5pv210: Migrate clock handling to Common Clock Framework
>>>>>
>>>>>    .../bindings/clock/samsung,s5pv210-clock.txt       |  75 +++
>>>>>    arch/arm/mach-s5pv210/Kconfig                      |   9 +
>>>>>    arch/arm/mach-s5pv210/Makefile                     |   4 +-
>>>>>    arch/arm/mach-s5pv210/common.c                     |  17 +
>>>>>    arch/arm/mach-s5pv210/common.h                     |  10 +
>>>>>    arch/arm/mach-s5pv210/mach-goni.c                  |   2 +-
>>>>>    arch/arm/mach-s5pv210/mach-smdkv210.c              |   2 +-
>>>>>    arch/arm/plat-samsung/Kconfig                      |   2 +-
>>>>>    drivers/clk/samsung/Makefile                       |   3 +
>>>>>    drivers/clk/samsung/clk-s5pv210.c                  | 673
>>>>> +++++++++++++++++++++ drivers/cpufreq/s5pv210-cpufreq.c
>>>>>    |   6 +-
>>>>>    include/dt-bindings/clock/samsung,s5pv210-clock.h  | 224 +++++++
>>>>>    12 files changed, 1019 insertions(+), 8 deletions(-)
>>>>>    create mode 100644
>>>>> Documentation/devicetree/bindings/clock/samsung,s5pv210-clock.txt
>>>>> create mode 100644 drivers/clk/samsung/clk-s5pv210.c
>>>>>    create mode 100644 include/dt-bindings/clock/samsung,s5pv210-clock.h
>>>>
>>>> I believe this series is reasonable to be applied. Could we agree on
>>>> the tree it would go through and get all tne required acks?
>>>>
>>>> Best regards,
>>>> Tomasz
>>>
>>> I agree.
>>>
>>> Mike, how do you think the common clk stuff for s5pv210?
>>
>> Clock code looks good to me. Which tree do you want to take it through?
>
> Seems like we just missed another kernel release. It's a bit sad that it's
> happening so often for Samsung patches...
>

Tomasz, sorry about that, I couldn't end up the stuff before attending 
ARM Kernel Summit, but in my opinion, this series would be merged for 
upcoming merge window via clk tree if Mike is fine because there is no 
conflicts with Samsung tree.

Mike, how do you think? If you're OK, please pick this into your tree 
with my ack.

Thanks,
Kukjin
