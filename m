Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab3KSPsg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 10:48:36 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:57932 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212Ab3KSPsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 10:48:33 -0500
Message-ID: <528B884C.7070908@ti.com>
Date: Tue, 19 Nov 2013 09:48:28 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Shawn Guo <shawn.guo@linaro.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Carlos Hernandez <ceh@ti.com>
Subject: Re: [PATCH] cpufreq: cpufreq-cpu0: Use a sane boot frequency when
 booting with a mismatched bootloader configuration
References: <1384568535-26611-1-git-send-email-nm@ti.com>	<20131116134445.GI11014@S2101-09.ap.freescale.net>	<CAKohponU-WFnG8Gx6ba=k3eJmWV_0eWtpsy9kDP8yA2KrdoKtg@mail.gmail.com>	<528A27F8.3070402@ti.com>	<20131118155753.GU11014@S2101-09.ap.freescale.net>	<528A4340.3020508@ti.com>	<20131119022133.GB18434@S2101-09.ap.freescale.net>	<CAKohpok_yRZr-XQEC+w8PLN+ZyW83uijFyZrDM1LB8G2X4h-fg@mail.gmail.com>	<528B72C1.5060006@ti.com>	<CAKohpo=hzCSuQBGreRStzkOuH6aFiZKTtK9SF+_eGEajkwSXEA@mail.gmail.com>	<528B7CE5.5040502@ti.com> <CAKohponO7M6rYoPt=ePNTZh=y+iU=BEbFWBqxr1JQPbVptvgXA@mail.gmail.com>
In-Reply-To: <CAKohponO7M6rYoPt=ePNTZh=y+iU=BEbFWBqxr1JQPbVptvgXA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2013 09:32 AM, Viresh Kumar wrote:
> On 19 November 2013 20:29, Nishanth Menon <nm@ti.com> wrote:
>> Not completely true - reaching probe after boot in a few seconds may
>> not mean that system will remain stable at that frequency for longer
>> duration. From a silicon vendor perspective, I do know that we
>> gaurentee the discrete frequencies in the data manual (and that gets
>> populated in devicetree and hence in freq_table), but we will not
>> guarentee any other frequency to be functional for any length of time.
>> in short, if a actual product is manufactured and operational at a
>> frequency we do not "officially support", there is a risk associated
>> with that. just a boot on a few development systems do not ever
>> guarentee productization capability.
> 
> Maybe for a long duration system isn't stable enough but should be
> stable for few seconds Atleast?
yes.

> 
> As soon as ->init() of driver is called we will get a call to:
> cpufreq_set_policy() from cpufreq_init_policy(). And we will execute
> this for sure:
> 
> ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
> 
> On this call if the current freq is lesser or greater than policy limits,
> then we will fix it straight away.. Otherwise whichever the governor
> is, we will change the freq to any from freq-table very soon..
is that true for userspace governor
(CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE)?
/sys/devices/system/cpu/cpu0/cpufreq $ cat scaling_available_frequencies
500000 1000000 1500000

/sys/devices/system/cpu/cpu0/cpufreq $ cat scaling_cur_freq
1100000


> 
> So, we need a real example of unstable system which really
> requires your patch. Otherwise I feel that we will not face any problems
> at all..
OMAP5-UEVM will remain at this frequency for a long period of time
with AVS voltage(Adaptive Voltage Scaling technique used in OMAP to
optimize operational voltage) that was meant for 1GHz! that is
definitely not stable if there is no further transition to a valid
frequency.

> 
>> So, to summarize: what is our overall strategy here? to move to a
>> frequency matched in freq_table OR just giveup? I can try and respin
>> accordingly.
> 
> I want cpufreq-stats to be fixed with something else, might be something
> similar to the patch I have sent..
> 
> But this stuff can be left as is..
An alternative might be to ensure CPUFREQ_GOV_LIMITS takes care of that?


-- 
Regards,
Nishanth Menon
