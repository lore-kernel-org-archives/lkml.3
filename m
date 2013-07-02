Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab3GBQex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 12:34:53 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:33752 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab3GBQew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 12:34:52 -0400
Message-ID: <51D3012A.4030306@hp.com>
Date: Tue, 02 Jul 2013 09:34:50 -0700
From: Chegu Vinod <chegu_vinod@hp.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: prarit@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        KVM <kvm@vger.kernel.org>, "Hull, Jim" <jim.hull@hp.com>
Subject: Re: kvm_intel: Could not allocate 42 bytes percpu data
References: <51C897A7.50302@hp.com> <87ehbisstv.fsf@rustcorp.com.au> <51D22931.1080008@hp.com> <8761wth5ph.fsf@rustcorp.com.au>
In-Reply-To: <8761wth5ph.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/1/2013 10:49 PM, Rusty Russell wrote:
> Chegu Vinod <chegu_vinod@hp.com> writes:
>> On 6/30/2013 11:22 PM, Rusty Russell wrote:
>>> Chegu Vinod <chegu_vinod@hp.com> writes:
>>>> Hello,
>>>>
>>>> Lots (~700+) of the following messages are showing up in the dmesg of a
>>>> 3.10-rc1 based kernel (Host OS is running on a large socket count box
>>>> with HT-on).
>>>>
>>>> [   82.270682] PERCPU: allocation failed, size=42 align=16, alloc from
>>>> reserved chunk failed
>>>> [   82.272633] kvm_intel: Could not allocate 42 bytes percpu data
>>> Woah, weird....
>>>
>>> Oh.  Shit.  Um, this is embarrassing.
>>>
>>> Thanks,
>>> Rusty.
>>
>> Thanks for your response!
>>
>>> ===
>>> module: do percpu allocation after uniqueness check.  No, really!
>>>
>>> v3.8-rc1-5-g1fb9341 was supposed to stop parallel kvm loads exhausting
>>> percpu memory on large machines:
>>>
>>>       Now we have a new state MODULE_STATE_UNFORMED, we can insert the
>>>       module into the list (and thus guarantee its uniqueness) before we
>>>       allocate the per-cpu region.
>>>
>>> In my defence, it didn't actually say the patch did this.  Just that
>>> we "can".
>>>
>>> This patch actually *does* it.
>>>
>>> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>>> Tested-by: Noone it seems.
>> Your following "updated" fix seems to be working fine on the larger
>> socket count machine with HT-on.
> OK, did you definitely revert every other workaround?

Yes no other workarounds were there when your change was tested.

>
> If so, please give me a Tested-by: line...

FYI.... The actual verification of your change was done by my esteemed 
colleague :Jim Hull (cc'd) who had access to this larger socket count box.



Tested-by: Jim Hull <jim.hull@hp.com>




Thanks
Vinod


>
> Thanks,
> Rusty.
> .
>

