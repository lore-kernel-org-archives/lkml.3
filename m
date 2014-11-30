Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919AbaK3IYT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 03:24:19 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:46291 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbaK3IYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 03:24:18 -0500
Message-ID: <547AD41F.7030907@huawei.com>
Date: Sun, 30 Nov 2014 16:23:59 +0800
From: Wang Weidong <wangweidong1@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: <viresh.kumar@linaro.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <guohanjun@huawei.com>
Subject: Re: [PATCH 0/2] fix some problems for cpufreq
References: <1417142619-14548-1-git-send-email-wangweidong1@huawei.com> <2248504.pAVebap2qN@vostro.rjw.lan> <547923F2.6000701@huawei.com> <4004530.x5fm24OG42@vostro.rjw.lan>
In-Reply-To: <4004530.x5fm24OG42@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.75]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/30 6:30, Rafael J. Wysocki wrote:
> On Saturday, November 29, 2014 09:40:02 AM Wang Weidong wrote:
>> On 2014/11/29 9:26, Rafael J. Wysocki wrote:
>>> On Friday, November 28, 2014 10:43:37 AM Wang Weidong wrote:
>>>> Hi Rafael and Viresh
>>>>
>>>> Sorry to trouble you again. As for:
>>>> "acpi-cpufreq: get the cur_freq from acpi_processor_performance states"
>>>> I do it again, and add the other patch.
>>>>
>>>> patch #1: acpi-cpufreq: make the freq_table store the same freq value
>>>>
>>>> I think it can work. The set of available states which come
>>>> from acpi won't change. Just like the power would be remove,
>>>> the acpi driver will do that:
>>>> call
>>>>  ->acpi_processor_ppc_has_changed
>>>>  ->cpufreq_update_policy
>>>>  ->acpi_ppc_notifier_block.notifier_call
>>>>    ->acpi_processor_ppc_notifier
>>>>    ->cpufreq_verify_within_limits
>>>> The progress will change the policy's min_freq and max_freq
>>>> while it won't change the set of states(freq_tables).
>>>
>>> OK, so the above information needs to go into the changelog of patch [1/2].
>>> Also, please clarify the problem description in that changelog, it is very
>>> difficult to understand the way it is now.
>>>
>>
>> sure, I should do it.
>>
>>>> patch #2: cpufreq: show the real avail freqs with the freq_table
>>>>
>>>> when the min_freq and max_freq change, we should sync the availble
>>>> freqs.
>>>
>>> Why?  Do any other cpufreq drivers do that?
>>>
>>
>> If some cpufreq drivers support several freqs like this:
>> 1.05 Ghz 1.30Ghz 1.70GHz 2.10GHz 2.3GHz
>>            |                |
>>           min              max
>> So what the available freqs is 1.30GHz 1.70GHz 2.10GHz
>>
>> when we do cpufreq-info or cat scaling_available_frequencies,
>> I think the available freqs table show only show these 3 value,
>> not all the values.
> 
> That changes an existing user space interface, however, and the
> only reason I can figure out from what you're saying is your personal
> opinion.  This isn't a good enough reason, however.
> 
> What if there are utilities and scripts out there relying on the
> current behavior?
> 

No, there are not utilities and scripts relying on it. 

I just confuse that:
If the policy->min and policy-max is changed while it shows all available freqs
though scaling_available_frequencies. I can't set all freq-steps, only [policy->min, policy->max].
why should it show all the available freqs.

Although, it doesn't impact on us. So just ignore the patch#2. :)

Wang,
Regards

> 


