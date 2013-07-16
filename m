Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab3GPIWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 04:22:54 -0400
Received: from mail.lang.hm ([64.81.33.126]:54201 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470Ab3GPIWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 04:22:35 -0400
Date: Tue, 16 Jul 2013 01:22:28 -0700 (PDT)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: NeilBrown <neilb@suse.de>, open list <linux-kernel@vger.kernel.org>,
        linux-raid@vger.kernel.org
Subject: Re: 3.10: discard/trim support on md-raid1?
In-Reply-To: <CAO9zADz6UTdxSoUySha=p4j4eGtomnctAZ2WVAFew1Z=-scrrw@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1307160121020.16723@nftneq.ynat.uz>
References: <001701ce7fb4$889bdd40$99d397c0$@lucidpixels.com> <20130716171527.7c6cb722@notabene.brown> <CAO9zADz6UTdxSoUySha=p4j4eGtomnctAZ2WVAFew1Z=-scrrw@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Part of this depends on the exact failure mode. I've seen cases where drives 
fail, and the drive does a bunch of retries, then the OS does a bunch of 
retries, and eventually the read fails, but in the meantime, everything stalls 
for a long time.

I've even seen the same thing in at least one case where there was a hardware 
RAID card in use.

David Lang

On Tue, 16 Jul 2013, Justin Piszcz wrote:

> Thanks for the replies,
>
> After some further testing..
> When I ran a repair on the md's sync_action, the system would reduce
> I/O to the RAID-1 to 14kb/s or even less when it hit a certain number
> of blocks and effectively locked the system every time.
> It turned out to be a bad SSD (it also failed Intel's Secure Erase), I RMA'd it.
> Interesting though that it did not drop out of the array but froze the
> system (the failure scenario was odd).
>
> Justin.
>
>
>
> On Tue, Jul 16, 2013 at 3:15 AM, NeilBrown <neilb@suse.de> wrote:
>> On Sat, 13 Jul 2013 06:34:19 -0400 "Justin Piszcz" <jpiszcz@lucidpixels.com>
>> wrote:
>>
>>> Hello,
>>>
>>> Running 3.10 and I see the following for an md-raid1 of two SSDs:
>>>
>>> Checking /sys/block/md1/queue:
>>> add_random: 0
>>> discard_granularity: 512
>>> discard_max_bytes: 2147450880
>>> discard_zeroes_data: 0
>>> hw_sector_size: 512
>>> iostats: 0
>>> logical_block_size: 512
>>> max_hw_sectors_kb: 32767
>>> max_integrity_segments: 0
>>> max_sectors_kb: 512
>>> max_segment_size: 65536
>>> max_segments: 168
>>> minimum_io_size: 512
>>> nomerges: 0
>>> nr_requests: 128
>>> optimal_io_size: 0
>>> physical_block_size: 512
>>> read_ahead_kb: 8192
>>> rotational: 1
>>> rq_affinity: 0
>>> scheduler: none
>>> write_same_max_bytes: 0
>>>
>>> What should be seen:
>>> rotational: 0
>>
>> What has "rotational" got to do with "supports discard"?
>> There may be some correlation, but it isn't causal.
>>
>>> And possibly:
>>> discard_zeroes_data: 1
>>
>> This should be set as the 'or' of the same value from component devices.  And
>> does not enable or disable the use of discard.
>>
>> I don't think that "does this device support discard" appears in sysfs.
>>
>> I believe trim does work on md/raid1 if the underlying devices all support it.
>>
>> NeilBrown
>>
>>
>>
>>>
>>> Can anyone confirm if there is a workaround to allow TRIM when using
>>> md-raid1?
>>>
>>> Some related discussion here:
>>> http://us.generation-nt.com/answer/md-rotational-attribute-help-206571222.ht
>>> ml
>>> http://www.progtown.com/topic343938-ssd-strange-itself-conducts.html
>>>
>>>
>>> Justin.
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
