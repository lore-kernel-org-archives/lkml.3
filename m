Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab3GBMXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 08:23:37 -0400
Received: from ozlabs.org ([203.10.76.45]:38491 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769Ab3GBMXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 08:23:35 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Chegu Vinod <chegu_vinod@hp.com>
Cc: prarit@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        KVM <kvm@vger.kernel.org>
Subject: Re: kvm_intel: Could not allocate 42 bytes percpu data
In-Reply-To: <51D22931.1080008@hp.com>
References: <51C897A7.50302@hp.com> <87ehbisstv.fsf@rustcorp.com.au> <51D22931.1080008@hp.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 02 Jul 2013 15:19:14 +0930
Message-ID: <8761wth5ph.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chegu Vinod <chegu_vinod@hp.com> writes:
> On 6/30/2013 11:22 PM, Rusty Russell wrote:
>> Chegu Vinod <chegu_vinod@hp.com> writes:
>>> Hello,
>>>
>>> Lots (~700+) of the following messages are showing up in the dmesg of a
>>> 3.10-rc1 based kernel (Host OS is running on a large socket count box
>>> with HT-on).
>>>
>>> [   82.270682] PERCPU: allocation failed, size=42 align=16, alloc from
>>> reserved chunk failed
>>> [   82.272633] kvm_intel: Could not allocate 42 bytes percpu data
>> Woah, weird....
>>
>> Oh.  Shit.  Um, this is embarrassing.
>>
>> Thanks,
>> Rusty.
>
>
> Thanks for your response!
>
>> ===
>> module: do percpu allocation after uniqueness check.  No, really!
>>
>> v3.8-rc1-5-g1fb9341 was supposed to stop parallel kvm loads exhausting
>> percpu memory on large machines:
>>
>>      Now we have a new state MODULE_STATE_UNFORMED, we can insert the
>>      module into the list (and thus guarantee its uniqueness) before we
>>      allocate the per-cpu region.
>>
>> In my defence, it didn't actually say the patch did this.  Just that
>> we "can".
>>
>> This patch actually *does* it.
>>
>> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>> Tested-by: Noone it seems.
>
> Your following "updated" fix seems to be working fine on the larger 
> socket count machine with HT-on.

OK, did you definitely revert every other workaround?

If so, please give me a Tested-by: line...

Thanks,
Rusty.
