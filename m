Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbaDCKo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 06:44:29 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:38442 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbaDCKo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 06:44:27 -0400
Message-ID: <533D3A97.1030809@linux.vnet.ibm.com>
Date: Thu, 03 Apr 2014 16:10:23 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC 1/4] sched: extend the usage of cpu_power_orig
References: <1396012949-6227-1-git-send-email-vincent.guittot@linaro.org> <1396012949-6227-2-git-send-email-vincent.guittot@linaro.org> <533A9768.6060006@linux.vnet.ibm.com> <CAKfTPtD7Qp4yUoZ+3jV-Me2Xn53zbi8cHRrWyO7X+COzwcy3Tg@mail.gmail.com>
In-Reply-To: <CAKfTPtD7Qp4yUoZ+3jV-Me2Xn53zbi8cHRrWyO7X+COzwcy3Tg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040310-5806-0000-0000-000024821A78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2014 04:50 PM, Vincent Guittot wrote:
> On 1 April 2014 12:39, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
>> Hi Vincent,
>>
>> On 03/28/2014 06:52 PM, Vincent Guittot wrote:
>>> cpu_power_orig is only changed for SMT system in order to reflect the lower
>>> capacity of CPUs. Heterogenous system also have to reflect an original
>>> capacity that is different from the default value.
>>
>> There is no parameter 'cpu_power_orig' till your fourth patch right?
>> Why is this term being used in this patch?
> 
> It looks like that i have mixed power_orig and cpu_power_orig in my
> commit messages
> 
>>
>> Besides, both parameters power and power_orig are changed for SMT
>> systems to reflect the lower capacity of the CPUs.Why is there a mention
>> of only power_orig?
> 
> Only SMT system is able to change power_orig from default value
> whereas all systems can already change power field with
> arch_scale_freq_power function. The goal of this patch is to change

I am unable to understand this. arch_scale_freq_power() is not doing the
same job as arch_scale_smt_power() right? While the former allows the
arch to set a power value per cpu different from the default value, the
latter allows arch to adjust the power for hyper threads.

For example in big.LITTLE, the big cores would be required to have a
higher cpu power than what is currently being used as default. This is
done by arch_scale_freq_power(). Whereas for an SMT system, the power of
a core could perhaps be the same as default value, but needs to be
divided among the hyper threads. This is done by arch_scale_smt_power().
They have different purposes right?

So I do not understand why you mention "all systems can already change
power field with arch_scale_freq_power()."

Actually I was assuming this patch would introduce
arch_scale_smt_power() and arch_scale_freq_power(), two functions that
would *enable all archs and not just ARCH_POWER* as is found today, to
adjust their smt power and non-smt power respectively.

For the same reasons, I am also unclear as to why power_orig is not
initialized *after* default/arch_scale_freq_power(). For big cores for
instance you would want the power_orig to be set not to a default value
but to what the arch says as the frequency of a core scaled over the
default value.

> the function name that is used to set power_orig value to a more
> generic one and to extend the possibility of setting power_orig for
> any kind of system. The behavior of the power field is not changed
> with this patchset.
> 
>>
>> IMO, the subject of the patch is not clearly reflecting the main
>> intention of the patch. There is nothing done to change the way
>> cpu_power is used; rather you are changing the way the cpu_power is
>> being set to be flexible, thus allowing for the right power value to be
>> set on heterogeneous systems.
>>
>> 'Allow archs to set the cpu_power instead of falling to default value'
>> or something similar would be more appropriate. What do you think?
> 
> I can change with : "Allow all archs to set the power_orig"

Ok, but for the reasons mentioned above I was thinking the power_orig
should be avoided since archs should be able to scale both power and
power_orig per thread and not just ARCH_POWER.

Regards
Preeti U Murthy


> 
> Thanks
> 
>>
>> Regards
>> Preeti U Murthy

