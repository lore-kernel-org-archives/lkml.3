Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab3FYRT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 13:19:26 -0400
Received: from relay3.sgi.com ([192.48.152.1]:49697 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751506Ab3FYRTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 13:19:25 -0400
Message-ID: <51C9D114.8040408@sgi.com>
Date: Tue, 25 Jun 2013 10:19:16 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@kernel.org>, Nathan Zimmer <nzimmer@sgi.com>,
        holt@sgi.com, rob@landley.net, tglx@linutronix.de, mingo@redhat.com,
        yinghai@kernel.org, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC 2/2] x86_64, mm: Reinsert the absent memory
References: <1371831934-156971-1-git-send-email-nzimmer@sgi.com> <1371831934-156971-3-git-send-email-nzimmer@sgi.com> <20130623092840.GB13445@gmail.com> <20130624203657.GA107621@asylum.americas.sgi.com> <20130625073819.GC11420@gmail.com> <58029951-199f-484d-ad60-199d15a89c12@email.android.com>
In-Reply-To: <58029951-199f-484d-ad60-199d15a89c12@email.android.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks.  I went through a few iterations until finalizing
on the current patches.  Originally the memory was inserted
using the memory probe interface, but at 2G per addition,
it was still very slow.  By bypassing the memory driver
interface, and going directly to add_memory and memory_online,
along with Nathan's changes to unlock the memory mutex on
a per node basis, it sped up dramatically.


On 6/25/2013 8:07 AM, H. Peter Anvin wrote:
> I have to say I really like this concept. It should have some very nice properties including perhaps making THP work better?
> 
> Ingo Molnar <mingo@kernel.org> wrote:
> 
>>
>> * Nathan Zimmer <nzimmer@sgi.com> wrote:
>>
>>> On Sun, Jun 23, 2013 at 11:28:40AM +0200, Ingo Molnar wrote:
>>>>
>>>> That's 4.5 GB/sec initialization speed - that feels a bit slow and
>> the 
>>>> boot time effect should be felt on smaller 'a couple of gigabytes' 
>>>> desktop boxes as well. Do we know exactly where the 2 hours of boot
>>
>>>> time on a 32 TB system is spent?
>>>
>>> There are other several spots that could be improved on a large
>> system 
>>> but memory initialization is by far the biggest.
>>
>> My feeling is that deferred/on-demand initialization triggered from the
>>
>> buddy allocator is the better long term solution.
>>
>> That will also make it much easier to profile/test memory init 
>> performance: boot up a large system and run a simple testprogram that 
>> allocates a lot of RAM.
>>
>> ( It will also make people want to optimize the initialization sequence
>>
>>  better, as it will be part of any freshly booted system's memory 
>>  allocation overhead. )
>>
>> Thanks,
>>
>> 	Ingo
> 
