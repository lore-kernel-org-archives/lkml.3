Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbaF0Ji2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 05:38:28 -0400
Received: from service87.mimecast.com ([91.220.42.44]:44572 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbaF0Ji1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 05:38:27 -0400
Message-ID: <53AD3BB1.6020404@arm.com>
Date: Fri, 27 Jun 2014 10:38:57 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Sudeep Holla <sudeep.holla@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <Will.Deacon@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 8/9] ARM: kernel: add support for cpu cache information
References: <1403717444-23559-1-git-send-email-sudeep.holla@arm.com> <1403717444-23559-9-git-send-email-sudeep.holla@arm.com> <53AB6700.2060807@codeaurora.org> <53AC05C4.2030104@arm.com> <53AC6A3A.1010001@codeaurora.org>
In-Reply-To: <53AC6A3A.1010001@codeaurora.org>
X-OriginalArrivalTime: 27 Jun 2014 09:38:24.0211 (UTC) FILETIME=[8A62DA30:01CF91EB]
X-MC-Unique: 114062710382520301
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 26/06/14 19:45, Stephen Boyd wrote:
> On 06/26/14 04:36, Sudeep Holla wrote:
>> Hi Stephen,
>>
>> On 26/06/14 01:19, Stephen Boyd wrote:
>>> On 06/25/14 10:30, Sudeep Holla wrote:
>>>> +
>>>> +/*
>>>> + * Which cache CCSIDR represents depends on CSSELR value
>>>> + * Make sure no one else changes CSSELR during this
>>>> + * smp_call_function_single prevents preemption for us
>>>> + */
>>>
>>> Where's the smp_call_function_single() or preemption disable happening?
>>>
>>
>> init_cache_level is called using smp_call_function_single in
>> drivers/base/cacheinfo.c(PATCH 2/9)
>
> Oh that's unexpected. Do other architectures require the use of
> smp_call_function_single() to read their cache information? It seems
> like an ARM architecture specific detail that has been pushed up into
> the generic layer.
>

Right, since I started with x86 as reference and it requires it, I missed to
see others. So x86,ARM{32,64} requires it while ppc,s390 and ia64 doesn't.
I see how to fix that. Thanks for spotting it.

Regards,
Sudeep

