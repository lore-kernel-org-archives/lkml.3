Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab3KSRn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 12:43:57 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:38149 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab3KSRny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 12:43:54 -0500
Message-ID: <528BA355.4040008@ti.com>
Date: Tue, 19 Nov 2013 11:43:49 -0600
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
References: <1384568535-26611-1-git-send-email-nm@ti.com>	<20131116134445.GI11014@S2101-09.ap.freescale.net>	<CAKohponU-WFnG8Gx6ba=k3eJmWV_0eWtpsy9kDP8yA2KrdoKtg@mail.gmail.com>	<528A27F8.3070402@ti.com>	<20131118155753.GU11014@S2101-09.ap.freescale.net>	<528A4340.3020508@ti.com>	<20131119022133.GB18434@S2101-09.ap.freescale.net>	<CAKohpok_yRZr-XQEC+w8PLN+ZyW83uijFyZrDM1LB8G2X4h-fg@mail.gmail.com>	<528B72C1.5060006@ti.com>	<CAKohpo=hzCSuQBGreRStzkOuH6aFiZKTtK9SF+_eGEajkwSXEA@mail.gmail.com>	<528B7CE5.5040502@ti.com>	<CAKohponO7M6rYoPt=ePNTZh=y+iU=BEbFWBqxr1JQPbVptvgXA@mail.gmail.com>	<528B884C.7070908@ti.com> <CAKohpo=brpnLe68ExPRPg9h5ABMhg+GS85Ebn-+S5-vWaStrPQ@mail.gmail.com>
In-Reply-To: <CAKohpo=brpnLe68ExPRPg9h5ABMhg+GS85Ebn-+S5-vWaStrPQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2013 11:10 AM, Viresh Kumar wrote:
> On 19 November 2013 21:18, Nishanth Menon <nm@ti.com> wrote:
>> is that true for userspace governor
>> (CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE)?
>> /sys/devices/system/cpu/cpu0/cpufreq $ cat scaling_available_frequencies
>> 500000 1000000 1500000
>>
>> /sys/devices/system/cpu/cpu0/cpufreq $ cat scaling_cur_freq
>> 1100000
> 
> No, but userspace governor must take care of this stuff as it want's
> to change freq from userspace..
> 

Right, the point is that CPUFREQ_GOV_LIMITS wont help in the case when
it is within min-max bound.. the first transition will help bring it
to a sane value - that I agree.

>> OMAP5-UEVM will remain at this frequency for a long period of time
>> with AVS voltage(Adaptive Voltage Scaling technique used in OMAP to
>> optimize operational voltage) that was meant for 1GHz! that is
>> definitely not stable if there is no further transition to a valid
>> frequency.
> 
> I understand that point, but will this stay for a long time at that freq?
> Why aren't governors coming into picture here?

we depend on the first transition to take us to a sane configuration -
but we cannot predict when and if it will happen.


-- 
Regards,
Nishanth Menon
