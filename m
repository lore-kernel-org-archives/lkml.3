Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595Ab3ILEto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 00:49:44 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:40064 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab3ILEtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 00:49:43 -0400
Message-ID: <523147DB.9010500@linux.vnet.ibm.com>
Date: Thu, 12 Sep 2013 10:19:31 +0530
From: Hemant <hkshaw@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org,
        Mikhail.Kulemin@ru.ibm.com, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, mingo@redhat.com, systemtap@sourceware.org,
        masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH] uprobes: Fix limiting un-nested return probes
References: <20130903060959.1351.16587.stgit@hemant-fedora> <20130908163232.GA32685@redhat.com> <20130909083635.GA3270@bandura.laptop> <20130909145515.GA5855@redhat.com>
In-Reply-To: <20130909145515.GA5855@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091204-1396-0000-0000-0000038B42F8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

On 09/09/2013 08:25 PM, Oleg Nesterov wrote:
> On 09/09, Anton Arapov wrote:
>> On Sun, Sep 08, 2013 at 06:32:32PM +0200, Oleg Nesterov wrote:
>>> Not sure, but I can be easily wrong... afaics we need something like below, no?
>>> Anton?
>> Oleg, your guess is correct.
>>
>> My original intention was to limit by depth the chained only probes. But later,
>> after your review, we've decided /based on safety concerns/ to limit it hard.
> Chained or not, we allocate return_instance every time, so we certainly
> need to account to limit the depth unconditionally. Unless we reuse the
> same return_instance if chained, but this is another story.

Hmm, agreed. Thanks for the description.

>
>> The decrement 'utask->depth--;' in my own tree is above the 'if (!chained)'
>> check. I think it got mangled somehow when I rebased the code before I sent it
>> to lkml.
> OK, thanks, I'll write the changelog and re-send the patch below.
>
>> Anton.
>>
>>
>>> Oleg.
>>>
>>> --- x/kernel/events/uprobes.c
>>> +++ x/kernel/events/uprobes.c
>>> @@ -1682,12 +1682,10 @@ static bool handle_trampoline(struct pt_
>>>   		tmp = ri;
>>>   		ri = ri->next;
>>>   		kfree(tmp);
>>> +		utask->depth--;
>>>
>>>   		if (!chained)
>>>   			break;
>>> -
>>> -		utask->depth--;
>>> -
>>>   		BUG_ON(!ri);
>>>   	}


-- 
Thanks
Hemant

