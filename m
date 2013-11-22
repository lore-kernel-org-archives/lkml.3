Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab3KVTpZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 14:45:25 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:58787 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932110Ab3KVTpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 14:45:19 -0500
Message-ID: <528FB2EC.2020202@wwwdotorg.org>
Date: Fri, 22 Nov 2013 12:39:24 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Stephen Warren <swarren@nvidia.com>, Kukjin Kim <kgene@kernel.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>
CC: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lan Tianyu <tianyu.lan@intel.com>, Nishanth Menon <nm@ti.com>,
        jinchoi@broadcom.com, Sebastian Capella <sebastian.capella@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Subject: Re: [PATCH V2 2/2] cpufreq: Change freq before suspending governors
References: <cover.1385118255.git.viresh.kumar@linaro.org>	<df162ba4cbdf1379ccfa5dd4ca34153626ae9c71.1385118256.git.viresh.kumar@linaro.org>	<2783049.JzUB2QcsZz@vostro.rjw.lan> <CAKohpo=RWi1nRUJq4qx8K+Y7swMDaqwEOH24-KfBCMgdbW=hMQ@mail.gmail.com>
In-Reply-To: <CAKohpo=RWi1nRUJq4qx8K+Y7swMDaqwEOH24-KfBCMgdbW=hMQ@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2013 05:52 AM, Viresh Kumar wrote:
> On 22 November 2013 18:07, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>> On Friday, November 22, 2013 04:59:49 PM Viresh Kumar wrote:
>>> Some platforms might want to change frequency before suspending governors. Like:
>>> - Some platform which want to set freq to max to speed up suspend/hibernation
>>>   process.
>>> - Some platform (like: Tegra or exynos), set this to min or bootloader's
>>>   frequency.
>>>
>>> This patch adds an option for those, so that they can specify this at call to
>>> ->init(), so that cpufreq core can take care of this before suspending system.
>>>
>>> If this variable is not updated by ->init() then its value would be zero and so
>>> core wouldn't do anything.
>>>
>>> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>>
>> I don't think this is generally necessary, because the suspend/resume routines
>> added by patch [1/2] will be executed very late during suspend or very early
>> during resume and it shouldn't really matter what performance levels the CPUs
>> are at then.
> 
> There are few things here:
> - I feel that the current place from where we have suspended stuff is not gonna
> fly. We are doing that in noirq and probably devices which might be required
> during frequency transitions might already be down.. So we *may* need to
> move that in dpm_suspend()..
> - Secondly I want to understand why Tegra/Exynos has such code which I
> mentioned above..
> 
> @Stephen, Kukjin and other samsung folks: Please provide some input here,
> before your systems break in mainline :)

I believe we set the clock to a low value because fast clocks consume
more power. Tegra architecturally supports a number of different suspend
levels. Only some of those actually power off or gate the clock source
itself.
