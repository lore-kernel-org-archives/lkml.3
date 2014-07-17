Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbaGQUYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 16:24:46 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:59660 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaGQUYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 16:24:45 -0400
MIME-Version: 1.0
In-Reply-To: <CABPqkBTMg_DM40LpgKisx-9GHpgxXxU96g3BEo_=JTLGyqYBVw@mail.gmail.com>
References: <1405123285-23544-1-git-send-email-andi@firstfloor.org>
	<1405123285-23544-2-git-send-email-andi@firstfloor.org>
	<CABPqkBScNfoK4a9BZkZxB-gAj3Ew2f7Ox3351YKWVt7cN-1EEw@mail.gmail.com>
	<20140714192451.GC5803@tassilo.jf.intel.com>
	<CABPqkBS=PB9tp78Y12ZRG9KLjd=DLY=3yrXeRdqCbZ4gnsdJ7A@mail.gmail.com>
	<20140714223918.GE5803@tassilo.jf.intel.com>
	<CABPqkBTYfc6CLJNzRqxDnQPr_sdv+yE9sLq717rg0sYzHhxssg@mail.gmail.com>
	<CABPqkBSVRuyOH8bTU4pjLNZMZdHoWFB4y-HJzVWTVowrO2Q+tg@mail.gmail.com>
	<20140715040542.GF5803@tassilo.jf.intel.com>
	<20140715085901.GS9918@twins.programming.kicks-ass.net>
	<CABPqkBTMg_DM40LpgKisx-9GHpgxXxU96g3BEo_=JTLGyqYBVw@mail.gmail.com>
Date: Thu, 17 Jul 2014 22:24:44 +0200
Message-ID: <CABPqkBSY=zJKCoran4psjm3uo1ozQfM0sG1Uff_=Ro-uPZLwVg@mail.gmail.com>
Subject: Re: [PATCH 2/2] perf, x86: Don't mark DataLA addresses as store
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 8:19 PM, Stephane Eranian <eranian@google.com> wrote:
> On Tue, Jul 15, 2014 at 10:59 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Mon, Jul 14, 2014 at 09:05:42PM -0700, Andi Kleen wrote:
>>
>>> Yes, there are only three store events:
>>>
>>> MEM_UOPS_RETIRED.STLB_MISS_STORES
>>> MEM_UOPS_RETIRED.SPLIT_STORES
>>> MEM_UOPS_RETIRED.ALL_STORES
>>>
>>> These can be added.
>>>
>>> But most others are loads, so if you wanted loads too (besides mem-loads)
>>> it would be nearly a full list.
>>
>> Of that list you had earlier:
>>
>> MEM_UOPS_RETIRED.STLB_MISS_LOADS
>> MEM_UOPS_RETIRED.STLB_MISS_STORES
>> MEM_UOPS_RETIRED.LOCK_LOADS
>> MEM_UOPS_RETIRED.SPLIT_LOADS
>> MEM_UOPS_RETIRED.SPLIT_STORES
>> MEM_UOPS_RETIRED.ALL_LOADS
>> MEM_UOPS_RETIRED.ALL_STORES
>>
>> There's only 4 loads and (as you already said) 3 stores.
>>
>> That's 7 events total, that's not nearly a full list.
>>
>> The other events:
>>
>> UOPS_RETIRED.ALL
>> MEM_LOAD_UOPS_RETIRED.L1_HIT
>> MEM_LOAD_UOPS_RETIRED.L2_HIT
>> MEM_LOAD_UOPS_RETIRED.L3_HIT
>> MEM_LOAD_UOPS_RETIRED.L1_MISS
>> MEM_LOAD_UOPS_RETIRED.L2_MISS
>> MEM_LOAD_UOPS_RETIRED.L3_MISS
>> MEM_LOAD_UOPS_RETIRED.HIT_LFB
>> MEM_LOAD_UOPS_L3_HIT_RETIRED.XSNP_MISS
>> MEM_LOAD_UOPS_L3_HIT_RETIRED.XSNP_HIT
>> MEM_LOAD_UOPS_L3_HIT_RETIRED.XSNP_HITM
>> MEM_LOAD_UOPS_L3_HIT_RETIRED.XSNP_NONE
>> MEM_LOAD_UOPS_L3_MISS_RETIRED.LOCAL_DRAM
>>
> Those are loads uops.
>
I suggest we add those back as loads. We cannot really loose
precision in the info returned.

>> are unclear on their type and should indeed be NA.
