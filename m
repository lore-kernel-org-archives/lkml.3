Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349AbaFXFFk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 01:05:40 -0400
Received: from mail.active-venture.com ([67.228.131.205]:58000 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbaFXFFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 01:05:39 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53A90718.4050401@roeck-us.net>
Date: Mon, 23 Jun 2014 22:05:28 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [PATCH] powerpc: Fix build warning
References: <1402677499-28289-1-git-send-email-linux@roeck-us.net> <1403584501.4587.153.camel@pasglop>
In-Reply-To: <1403584501.4587.153.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2014 09:35 PM, Benjamin Herrenschmidt wrote:
> On Fri, 2014-06-13 at 09:38 -0700, Guenter Roeck wrote:
>> If compiled with W=1, the following warning is seen in powerpc builds.
>>
>> arch/powerpc/kernel/smp.c:750:18: warning:
>> 	type qualifiers ignored on function return type
>> static const int powerpc_smt_flags(void)
>>                   ^
>>
>> This is caused by a function returning 'const int', which doesn't
>> make sense to gcc. Drop 'const' to fix the problem.
>
> This breaks the 64-bit build:
>
> arch/powerpc/kernel/smp.c:764:2: error: initialization from incompatible pointer type [-Werror]
> arch/powerpc/kernel/smp.c:764:2: error: (near initialization for 'powerpc_topology[0].sd_flags') [-Werror]
>
> It appears that the generic definition in sched.h has this function
> defined as const int, so that needs to be fixed too along with all
> instances in all archs.
>

https://lkml.org/lkml/2014/6/12/743

Guenter

