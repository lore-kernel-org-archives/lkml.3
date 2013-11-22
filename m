Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab3KVMwz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 07:52:55 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:53934 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab3KVMww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 07:52:52 -0500
MIME-Version: 1.0
In-Reply-To: <2783049.JzUB2QcsZz@vostro.rjw.lan>
References: <cover.1385118255.git.viresh.kumar@linaro.org>
	<df162ba4cbdf1379ccfa5dd4ca34153626ae9c71.1385118256.git.viresh.kumar@linaro.org>
	<2783049.JzUB2QcsZz@vostro.rjw.lan>
Date: Fri, 22 Nov 2013 18:22:52 +0530
Message-ID: <CAKohpo=RWi1nRUJq4qx8K+Y7swMDaqwEOH24-KfBCMgdbW=hMQ@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] cpufreq: Change freq before suspending governors
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Stephen Warren <swarren@nvidia.com>, Kukjin Kim <kgene@kernel.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lan Tianyu <tianyu.lan@intel.com>, Nishanth Menon <nm@ti.com>,
        jinchoi@broadcom.com, Sebastian Capella <sebastian.capella@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 November 2013 18:07, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Friday, November 22, 2013 04:59:49 PM Viresh Kumar wrote:
>> Some platforms might want to change frequency before suspending governors. Like:
>> - Some platform which want to set freq to max to speed up suspend/hibernation
>>   process.
>> - Some platform (like: Tegra or exynos), set this to min or bootloader's
>>   frequency.
>>
>> This patch adds an option for those, so that they can specify this at call to
>> ->init(), so that cpufreq core can take care of this before suspending system.
>>
>> If this variable is not updated by ->init() then its value would be zero and so
>> core wouldn't do anything.
>>
>> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>
> I don't think this is generally necessary, because the suspend/resume routines
> added by patch [1/2] will be executed very late during suspend or very early
> during resume and it shouldn't really matter what performance levels the CPUs
> are at then.

There are few things here:
- I feel that the current place from where we have suspended stuff is not gonna
fly. We are doing that in noirq and probably devices which might be required
during frequency transitions might already be down.. So we *may* need to
move that in dpm_suspend()..
- Secondly I want to understand why Tegra/Exynos has such code which I
mentioned above..

@Stephen, Kukjin and other samsung folks: Please provide some input here,
before your systems break in mainline :)

> The only exception *may* be hibernation, because the amount of time needed to
> create the image will depend on the current performance level of the boot CPU,
> but that should be an explicitly special case in my opinion.

Hmm.. That looks sensible if there is nothing special required for Tegra/Exynos.
