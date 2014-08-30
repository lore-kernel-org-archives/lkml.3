Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbaH3Det (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 23:34:49 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:49115 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaH3Der (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 23:34:47 -0400
Message-ID: <54014773.6020303@gmail.com>
Date: Sat, 30 Aug 2014 11:39:31 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com
CC: xen-devel@lists.xenproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/xen/evtchn.c: Check failure for evtchn_make_refcounted()
References: <53FF4702.9020509@gmail.com> <53FF4FA5.4050105@citrix.com> <5400817E.6060500@gmail.com> <5400836F.1090508@citrix.com>
In-Reply-To: <5400836F.1090508@citrix.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 8/29/14 21:43, David Vrabel wrote:
> On 29/08/14 14:34, Chen Gang wrote:
>>
>>
>> On 8/28/14 23:49, David Vrabel wrote:
>>> On 28/08/14 16:13, Chen Gang wrote:
>>>> evtchn_make_refcounted() may return failure, so need process the failure
>>>> case. In failure case, it need call unbind_from_irqhandler() just like
>>>> evtchn_unbind_from_user() has done.
>>>>
>>>> irq_from_evtchn() must be OK when bind_evtchn_to_irqhandler() succeed,
>>>> so need not check it again.
>>>>
>>>> Also still need remain the closing port code, because when the failure
>>>> occurs, unbind_from_irqhandler() will not close port internally.
>>>
>>> None of the evtchn_make_refcounted() failures can occur since we know we
>>> have a valid irq and info at the single call site.
>>>
>>
>> OK, thanks. I guess what you said is correct.
>>
>> But only according to the code, for me, I am not quite sure about 'info'
>> must be always valid. If bind_evtchn_to_irqhandler() succeeds, I can not
>> find any related code to prove 'info' must be valid.
>>
>>  - for a new irq, it will allocate 'info' for it.
>>
>>  - but for an existing irq, the code assumes it may has no 'info'.
>>    (so several areas check 'info' whether valid, although irq is OK).
>>
>> So could you give some additional related proofs for it? And if 'info'
>> must be always OK, can we remove all the related check about 'info'?
> 
> I'm not sure what you mean by an existing irq.  If it's an irq for an
> event channel it will have had info set when it was allocated.  the
> irq_mapping_update_lock protects against seeing partially setup irqs.
> 

After check the code details again. I guess, really no "existing irq",
just like you said.

But in honest, only based on the code, for me, it is not quite clear (
I guess it is OK, but I am not sure it must be OK -- still worry about
it).


> So, the checks for !info can be removed, yes.
> 

So for me, for safety (also easy understanding) reason, I still prefer
my original patch, although it is not the best one.

If you are sure about it (I guess you are sure), please help send patch
for it (skip checking "!info"). If necessary, may mark Cc or Reported-by
to me.


Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
