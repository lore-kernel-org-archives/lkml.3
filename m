Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab3GPIJq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 04:09:46 -0400
Received: from mail-qe0-f46.google.com ([209.85.128.46]:60598 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860Ab3GPIJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 04:09:19 -0400
MIME-Version: 1.0
X-Originating-IP: [72.73.18.11]
In-Reply-To: <20130716171527.7c6cb722@notabene.brown>
References: <001701ce7fb4$889bdd40$99d397c0$@lucidpixels.com>
	<20130716171527.7c6cb722@notabene.brown>
Date: Tue, 16 Jul 2013 04:09:18 -0400
Message-ID: <CAO9zADz6UTdxSoUySha=p4j4eGtomnctAZ2WVAFew1Z=-scrrw@mail.gmail.com>
Subject: Re: 3.10: discard/trim support on md-raid1?
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: NeilBrown <neilb@suse.de>
Cc: open list <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the replies,

After some further testing..
When I ran a repair on the md's sync_action, the system would reduce
I/O to the RAID-1 to 14kb/s or even less when it hit a certain number
of blocks and effectively locked the system every time.
It turned out to be a bad SSD (it also failed Intel's Secure Erase), I RMA'd it.
Interesting though that it did not drop out of the array but froze the
system (the failure scenario was odd).

Justin.



On Tue, Jul 16, 2013 at 3:15 AM, NeilBrown <neilb@suse.de> wrote:
> On Sat, 13 Jul 2013 06:34:19 -0400 "Justin Piszcz" <jpiszcz@lucidpixels.com>
> wrote:
>
>> Hello,
>>
>> Running 3.10 and I see the following for an md-raid1 of two SSDs:
>>
>> Checking /sys/block/md1/queue:
>> add_random: 0
>> discard_granularity: 512
>> discard_max_bytes: 2147450880
>> discard_zeroes_data: 0
>> hw_sector_size: 512
>> iostats: 0
>> logical_block_size: 512
>> max_hw_sectors_kb: 32767
>> max_integrity_segments: 0
>> max_sectors_kb: 512
>> max_segment_size: 65536
>> max_segments: 168
>> minimum_io_size: 512
>> nomerges: 0
>> nr_requests: 128
>> optimal_io_size: 0
>> physical_block_size: 512
>> read_ahead_kb: 8192
>> rotational: 1
>> rq_affinity: 0
>> scheduler: none
>> write_same_max_bytes: 0
>>
>> What should be seen:
>> rotational: 0
>
> What has "rotational" got to do with "supports discard"?
> There may be some correlation, but it isn't causal.
>
>> And possibly:
>> discard_zeroes_data: 1
>
> This should be set as the 'or' of the same value from component devices.  And
> does not enable or disable the use of discard.
>
> I don't think that "does this device support discard" appears in sysfs.
>
> I believe trim does work on md/raid1 if the underlying devices all support it.
>
> NeilBrown
>
>
>
>>
>> Can anyone confirm if there is a workaround to allow TRIM when using
>> md-raid1?
>>
>> Some related discussion here:
>> http://us.generation-nt.com/answer/md-rotational-attribute-help-206571222.ht
>> ml
>> http://www.progtown.com/topic343938-ssd-strange-itself-conducts.html
>>
>>
>> Justin.
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
