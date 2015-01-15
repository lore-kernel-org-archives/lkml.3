Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbbAOUKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 15:10:13 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:33277 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbbAOUKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 15:10:11 -0500
Message-ID: <54B81EA0.8060409@gmail.com>
Date: Thu, 15 Jan 2015 12:10:08 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Aaro Koskinen <aaro.koskinen@iki.fi>
CC: Ralf Baechle <ralf@linux-mips.org>, David Daney <david.daney@cavium.com>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Hemmo Nieminen <hemmo.nieminen@iki.fi>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] MIPS: OCTEON: fix kernel crash when offlining a CPU
References: <1421347767-21740-1-git-send-email-aaro.koskinen@iki.fi> <54B816AC.7070902@gmail.com> <20150115195345.GA8087@fuloong-minipc.musicnaut.iki.fi>
In-Reply-To: <20150115195345.GA8087@fuloong-minipc.musicnaut.iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2015 11:53 AM, Aaro Koskinen wrote:
> Hi,
>
> On Thu, Jan 15, 2015 at 11:36:12AM -0800, David Daney wrote:
>> On 01/15/2015 10:49 AM, Aaro Koskinen wrote:
>>> octeon_cpu_disable() will unconditionally enable interrupts when called
>>> with interrupts disabled. Fix that.
>>
>> interrupts are always disabled here, so...
>
> Is that also true for all the currently supported stable kernels...?

I haven't done extensive research recently, but I have removed that pair 
of local_irq_disable/local_irq_enable in our SDK kernel based on 3.10


> Or should I just drop Cc: stable from this patch?
>
>> Just remove this...
>>
>>>   	octeon_fixup_irqs();
>>> -	local_irq_enable();
>>> +	local_irq_restore(flags);
>>
>> ... and this.
>>
>>>
>>>   	flush_cache_all();
>>>   	local_flush_tlb_all();
>>>
>>
>> You can add an Acked-by me if you do that.
>
> Ok, I will do that.
>
> A.
>
>

