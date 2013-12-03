Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab3LCINn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 03:13:43 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36010 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3LCINl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 03:13:41 -0500
Message-ID: <529D92D6.8050409@gmail.com>
Date: Tue, 03 Dec 2013 09:14:14 +0100
From: Francis Moreau <francis.moro@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jingoo Han <jg1.han@samsung.com>, "'Wei WANG'" <wei_wang@realsil.com.cn>,
        "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Chris Ball'" <cjb@laptop.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "'Borislav Petkov'" <bp@alien8.de>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Re: 3.12: kernel panic when resuming from suspend to RAM (x86_64)
References: <20131117195358.GO27323@pd.tnic> <4523614.I5MBhorHFt@vostro.rjw.lan> <5292FF5D.1050304@gmail.com> <1821758.2MoNI3h1Mv@vostro.rjw.lan> <52985041.5050000@gmail.com> <alpine.DEB.2.02.1311290958560.30673@ionos.tec.linutronix.de> <5299FF38.7060203@gmail.com> <alpine.DEB.2.02.1312021145190.30673@ionos.tec.linutronix.de> <alpine.DEB.2.02.1312021219090.30673@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1312021219090.30673@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas,

On 12/02/2013 12:20 PM, Thomas Gleixner wrote:
> On Mon, 2 Dec 2013, Thomas Gleixner wrote:
>> On Sat, 30 Nov 2013, Francis Moreau wrote:
>>> Hello Thomas,
>>>
>>> Sorry for the delay.
>>>
>>> On 11/29/2013 10:02 AM, Thomas Gleixner wrote:
>>>> On Fri, 29 Nov 2013, Francis Moreau wrote:
>>>>> Since it seems to be related to rtsx driver or its upper layer, could
>>>>> the folks involved in this area have a look to this issue please ?
>>>>
>>>> I'm not involved, but looking at the debug objects backtrace it's
>>>> related to the delayed work in rtsx.
>>>>
>>>> Does the untested patch below cure the issue?
>>>>
>>>
>>> It seems it does since I can't see the debug object trace anymore
>>> however Ican see this now:
>>
>> <SNIP>
>>  
>>> So I don't think it completely solve the problem but it's a good start.
>>
>> I kinda expected that, but I wanted to confirm my suspicion, that the
>> interrupt hits after the delayed work is canceled and just requeues it
>> again, which then leads to an armed timer being freed further down.
>>
>> I'm not familiar with that driver and I leave the final fixup to the
>> driver maintainers. It's enough data for them to figure out the real
>> solution.
> 
> Just had a quick look and the obvious solution is to disable the
> interrupts at the device level _BEFORE_ doing anything else in the
> teardown path. Updated patch below. That should avoid the nobody cared
> splat on the other irq line.
> 

Yes it does.

Now that you did the hard work, I hope driver's maintainer/developper
will care about this issue.

Thank you.
