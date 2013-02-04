Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab3BDNu4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 08:50:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380Ab3BDNuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 08:50:54 -0500
Message-ID: <510FBCA9.4070700@redhat.com>
Date: Mon, 04 Feb 2013 08:50:33 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, aquini@redhat.com, walken@google.com,
        eric.dumazet@gmail.com, lwoodman@redhat.com, knoel@redhat.com,
        chegu_vinod@hp.com, raghavendra.kt@linux.vnet.ibm.com,
        mingo@redhat.com
Subject: Re: [PATCH -v4 5/5] x86,smp: limit spinlock delay on virtual machines
References: <20130125140553.060b8ced@annuminas.surriel.com> <20130125141917.6d5960a8@annuminas.surriel.com> <20130126120043.GB13445@gmail.com> <20130126124716.GB21395@pd.tnic>
In-Reply-To: <20130126124716.GB21395@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2013 07:47 AM, Borislav Petkov wrote:
> On Sat, Jan 26, 2013 at 01:00:43PM +0100, Ingo Molnar wrote:
>>> +void __init init_spinlock_delay(void)
>>> +{
>>> +	if (x86_hyper)
>>> +		max_spinlock_delay = MAX_SPINLOCK_DELAY_GUEST;
>>
>> I realize that you took existing code and extended it, but that
>> chunk of code looks pretty disgusting visually now - at minimum
>> it should be vertically aligned as most other kernel code does.
>>
>> The comment should also tell that the unit of these values is
>> 'spinlock-op loops' or so.

Will do.

> Also, with currently making PARAVIRT_GUEST optional, x86_hyper is maybe
> a bad choice of a variable to test.
>
> Maybe instead to this:
>
> 	if (IS_ENABLED(CONFIG_PARAVIRT_GUEST))
> 		...

We need to know whether we are actually running on top of a
hypervisor, not whether we have the code compiled in to do
so.

After all, the majority of distribution kernels will have
CONFIG_PARAVIRT_GUEST set, but the majority of those kernels
will be running bare metal...

-- 
All rights reversed
