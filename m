Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751215AbaFZSpS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 14:45:18 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52562 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaFZSpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 14:45:16 -0400
Message-ID: <53AC6A3A.1010001@codeaurora.org>
Date: Thu, 26 Jun 2014 11:45:14 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Sudeep Holla <sudeep.holla@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <Will.Deacon@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 8/9] ARM: kernel: add support for cpu cache information
References: <1403717444-23559-1-git-send-email-sudeep.holla@arm.com> <1403717444-23559-9-git-send-email-sudeep.holla@arm.com> <53AB6700.2060807@codeaurora.org> <53AC05C4.2030104@arm.com>
In-Reply-To: <53AC05C4.2030104@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/14 04:36, Sudeep Holla wrote:
> Hi Stephen,
>
> On 26/06/14 01:19, Stephen Boyd wrote:
>> On 06/25/14 10:30, Sudeep Holla wrote:
>>> +
>>> +/*
>>> + * Which cache CCSIDR represents depends on CSSELR value
>>> + * Make sure no one else changes CSSELR during this
>>> + * smp_call_function_single prevents preemption for us
>>> + */
>>
>> Where's the smp_call_function_single() or preemption disable happening?
>>
>
> init_cache_level is called using smp_call_function_single in
> drivers/base/cacheinfo.c(PATCH 2/9)

Oh that's unexpected. Do other architectures require the use of
smp_call_function_single() to read their cache information? It seems
like an ARM architecture specific detail that has been pushed up into
the generic layer.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

