Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934020Ab3GPUoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 16:44:19 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:61735 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933910Ab3GPUoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 16:44:16 -0400
MIME-Version: 1.0
In-Reply-To: <20130716171527.7c6cb722@notabene.brown>
References: <001701ce7fb4$889bdd40$99d397c0$@lucidpixels.com>
	<20130716171527.7c6cb722@notabene.brown>
Date: Wed, 17 Jul 2013 00:44:15 +0400
Message-ID: <CAGqmV7qf14zrsimCMRsVWobq8SpLaavxPQvEyU6N=f1nBgvFHQ@mail.gmail.com>
Subject: Re: 3.10: discard/trim support on md-raid1?
From: CoolCold <coolthecold@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>,
        Linux kernel <linux-kernel@vger.kernel.org>,
        Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil, I've tryed to look around commit logs but failed to find commit
where discard/trim were added.
I was looking via
http://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/log/drivers/md?id=9f2a940965286754f3a34d5737c3097c05db8725&qt=grep&q=discard+support
, tryed just "discard" without support - found commits about dm, not
md, though.

Can you shed some light here? Thanks in advance.

(resent in plaintext mode, please reply to this one)


On Tue, Jul 16, 2013 at 11:15 AM, NeilBrown <neilb@suse.de> wrote:
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



-- 
Best regards,
[COOLCOLD-RIPN]
