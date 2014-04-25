Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764AbaDYVXI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 17:23:08 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:64745 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaDYVXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 17:23:06 -0400
Message-ID: <535AD235.90604@kernel.dk>
Date: Fri, 25 Apr 2014 15:23:01 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: Alexander Gordeev <agordeev@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kent Overstreet <kmo@daterainc.com>, Shaohua Li <shli@kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH RFC 0/2] percpu_ida: Take into account CPU topology when
 stealing tags
References: <cover.1395840483.git.agordeev@redhat.com>	<20140422071057.GA13195@dhcp-26-169.brq.redhat.com>	<535676A1.3070706@kernel.dk>	<5356916F.4000205@kernel.dk>	<CACVXFVMXh5ZP+ZsO2fV2mdKJrJF9AHg58v5KWmt_ZbEWvszsLw@mail.gmail.com>	<535716A5.6050108@kernel.dk> <CACVXFVN-roORYH8b-qZ10e2_wrL1W5-xO2P=A_ARPFL2GqDn2Q@mail.gmail.com>
In-Reply-To: <CACVXFVN-roORYH8b-qZ10e2_wrL1W5-xO2P=A_ARPFL2GqDn2Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2014 03:10 AM, Ming Lei wrote:
> Hi Jens,
> 
> On Wed, Apr 23, 2014 at 9:25 AM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 2014-04-22 18:53, Ming Lei wrote:
>>
>>
>>> In my null_blk test on a quad core SMP VM:
>>>
>>>       - 4 hw queue
>>>       - timer mode
>>>
>>> With the above approach, tag allocation from local CPU can be
>>> improved from:
>>>
>>>          5%   -> 50% for boot CPU
>>>          30% -> 90% for non-boot CPU.
>>>
>>> If no one objects the idea, I'd like to post a patch for review.
>>
>>
>> Sent it out, that can't hurt. I'll take a look at it, and give it a test
>> spin as well.
> 
> I have sent out the patch in below link, and appreciate much
> you will take a look at it.
> 
>       marc.info/?l=linux-kernel&m=139826944613225&w=2

Sorry, I did run it the other day. It has little to no effect here, but
that's mostly because there's so much other crap going on in there. The
most effective way to currently make it work better, is just to ensure
the caching pool is of a sane size.

I've got an alternative tagging scheme that I think would be useful for
the cases where the tag space to cpu ratio isn't big enough. So I think
we'll retain percpu_ida for the cases where it can cache enough, and
punt to an alternative scheme when not.

That doesn't mean we should not improve percpu_ida. There's quite a bit
of low hanging fruit in there.

-- 
Jens Axboe

