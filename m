Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbaEUOb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 10:31:58 -0400
Received: from service87.mimecast.com ([91.220.42.44]:38415 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbaEUOb4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 10:31:56 -0400
Message-ID: <537CB8DE.2050001@arm.com>
Date: Wed, 21 May 2014 15:31:58 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: Sudeep Holla <sudeep.holla@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <Arvind.Chauhan@arm.com>,
        "inderpal.s@samsung.com" <inderpal.s@samsung.com>,
        "nm@ti.com" <nm@ti.com>,
        "chander.kashyap@linaro.org" <chander.kashyap@linaro.org>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "len.brown@intel.com" <len.brown@intel.com>
Subject: Re: [PATCH V2 5/7] cpufreq: imx6q: don't initialize opp table
References: <cover.1400670427.git.viresh.kumar@linaro.org> <cc399206d57ef946d27a98203c6b0a247cd1b245.1400670427.git.viresh.kumar@linaro.org> <537CB328.6000400@arm.com> <20140521141622.GB27211@dragon>
In-Reply-To: <20140521141622.GB27211@dragon>
X-OriginalArrivalTime: 21 May 2014 14:31:53.0274 (UTC) FILETIME=[68EBE1A0:01CF7501]
X-MC-Unique: 114052115315409701
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 21/05/14 15:16, Shawn Guo wrote:
> On Wed, May 21, 2014 at 03:07:36PM +0100, Sudeep Holla wrote:
>>> @@ -376,7 +356,7 @@ static void __init imx6q_init_late(void)
>>>   		imx6q_cpuidle_init();
>>>
>>>   	if (IS_ENABLED(CONFIG_ARM_IMX6Q_CPUFREQ)) {
>>> -		imx6q_opp_init();
>>> +		imx6q_opp_check_speed_grading();
>>
>> [Query] Not exactly related to this patch, but asking it here to get clarified.
>>
>> This OPP limiting is done as part of late initcall and if the cpufreq driver is
>> built in the kernel, there will be a small window where the OPPs not supported
>> are still enabled ? Will that not be an issue if say performance governor is
>> selected by default.
>
> Even if cpufreq driver is built in the kernel, it won't be probed until
> platform_device_register(&imx6q_cpufreq_pdev) is called.  And we make
> this call only after the OPP limiting.
>

Ah right, I missed that. Thanks for clarifying.

Regards,
Sudeep

