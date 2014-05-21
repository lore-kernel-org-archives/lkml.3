Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbaEUOBH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 10:01:07 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:46347 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbaEUOBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 10:01:05 -0400
MIME-Version: 1.0
In-Reply-To: <537CADFB.1090305@arm.com>
References: <cover.1400670427.git.viresh.kumar@linaro.org>
	<b59df199b373191791afcccd627d900ce07afa71.1400670427.git.viresh.kumar@linaro.org>
	<537CADFB.1090305@arm.com>
Date: Wed, 21 May 2014 19:31:01 +0530
Message-ID: <CAKohpo=-kmfH9Z+m8E9HQXs4AvRoUCDzcrns6-HHLH=AqeJ-DQ@mail.gmail.com>
Subject: Re: [PATCH V2 3/7] driver/core: cpu: initialize opp table
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 May 2014 19:15, Sudeep Holla <sudeep.holla@arm.com> wrote:
> [Nit] Not sure if we need this logging on each cpu, may be dev_dbg if you
> still
> fancy one ? :)

It wouldn't happen on each CPU, but one CPU per policy as others
would return -ENODEV.

I added dev_dbg earlier but then I thought dev_info is better as we may
better show this to everybody as it about the most important device,
i.e. CPU :)

>> +       /* Print error only if there is an issue with OPP table */
>> +       else if (error != -ENOSYS && error != -ENODEV)
>> +               dev_err(&cpu->dev, "%s: failed to init OPP table for
>> cpu%d, err: %d\n",
>> +                       __func__, cpu->dev.id, error);
>> +}
>> +#else
>> +static inline void of_init_cpu_opp_table(struct cpu *cpu) {}
>> +#endif
>> +
>
>
> IMO this could be more generic and applicable for any device if you replace
> "struct cpu" with "struct device". I know this is currently used by cpu but
> we can extend it's use for any device if needed in future. You can then move
> this to pm_opp.h as of_init_dev_opp_table may be.

Probably we will call of_init_opp_table() directly for other devices, as this
function doesn't do anything else, apart from some prints.. So, probably
leave is as is for now, unless a real need arises ?
