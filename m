Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbaEUOmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 10:42:21 -0400
Received: from service87.mimecast.com ([91.220.42.44]:51153 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbaEUOmT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 10:42:19 -0400
Message-ID: <537CBB4C.7000006@arm.com>
Date: Wed, 21 May 2014 15:42:20 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Sudeep Holla <sudeep.holla@arm.com>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <Arvind.Chauhan@arm.com>,
        "inderpal.s@samsung.com" <inderpal.s@samsung.com>,
        "nm@ti.com" <nm@ti.com>,
        "chander.kashyap@linaro.org" <chander.kashyap@linaro.org>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "len.brown@intel.com" <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH V2 3/7] driver/core: cpu: initialize opp table
References: <cover.1400670427.git.viresh.kumar@linaro.org>	<b59df199b373191791afcccd627d900ce07afa71.1400670427.git.viresh.kumar@linaro.org>	<537CADFB.1090305@arm.com> <CAKohpo=-kmfH9Z+m8E9HQXs4AvRoUCDzcrns6-HHLH=AqeJ-DQ@mail.gmail.com>
In-Reply-To: <CAKohpo=-kmfH9Z+m8E9HQXs4AvRoUCDzcrns6-HHLH=AqeJ-DQ@mail.gmail.com>
X-OriginalArrivalTime: 21 May 2014 14:42:15.0157 (UTC) FILETIME=[DB97B250:01CF7502]
X-MC-Unique: 114052115421701001
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 21/05/14 15:01, Viresh Kumar wrote:
> On 21 May 2014 19:15, Sudeep Holla <sudeep.holla@arm.com> wrote:
>> [Nit] Not sure if we need this logging on each cpu, may be dev_dbg if you
>> still
>> fancy one ? :)
>
> It wouldn't happen on each CPU, but one CPU per policy as others
> would return -ENODEV.
>

Hmm agreed, but there are SoCs that support per CPU DVFS ;)

> I added dev_dbg earlier but then I thought dev_info is better as we may
> better show this to everybody as it about the most important device,
> i.e. CPU :)
>
>>> +       /* Print error only if there is an issue with OPP table */
>>> +       else if (error != -ENOSYS && error != -ENODEV)
>>> +               dev_err(&cpu->dev, "%s: failed to init OPP table for
>>> cpu%d, err: %d\n",
>>> +                       __func__, cpu->dev.id, error);
>>> +}
>>> +#else
>>> +static inline void of_init_cpu_opp_table(struct cpu *cpu) {}
>>> +#endif
>>> +
>>
>>
>> IMO this could be more generic and applicable for any device if you replace
>> "struct cpu" with "struct device". I know this is currently used by cpu but
>> we can extend it's use for any device if needed in future. You can then move
>> this to pm_opp.h as of_init_dev_opp_table may be.
>
> Probably we will call of_init_opp_table() directly for other devices, as this
> function doesn't do anything else, apart from some prints.. So, probably
> leave is as is for now, unless a real need arises ?
>

I don't see anything cpu specific there, but that's just my opinion.

Regards,
Sudeep

