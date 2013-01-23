Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687Ab3AWSpE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 13:45:04 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:36654 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab3AWSo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 13:44:59 -0500
MIME-Version: 1.0
In-Reply-To: <A3397C8B8B789E45844E7EC5DEAD89D02DF086E6@sausexdag04.amd.com>
References: <CA+55aFx5ZyFtd59ygn6ja5X-3ZyRvhfJLqtNKyF_mH3+-kSjKg@mail.gmail.com>
	<CAKocOOPr4wddCmDEWKmsKsKeTc3m779opuN_qRb4yiL63KVZ8A@mail.gmail.com>
	<CAKocOOPp1PA-n_=xdPuBSBKaKiREqhgeo02QqWpP-oX7vnN_YA@mail.gmail.com>
	<CAKocOOOpDb=0XgX-uhDbBjOF7qK_M5MA31q9ScD0yTat0QRquQ@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DC30FE7@sausexdag04.amd.com>
	<CAKocOONuFvcik229+1B0oeaBnQG7seZPeYf99xqduFa6kBZhOw@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DF083DE@sausexdag04.amd.com>
	<CAKocOOMxAYw-XO-6XGteKb8NyHDq4_BdZn2njUNBh+a73wrFGA@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DF084EA@sausexdag04.amd.com>
	<CAKocOOOYKAZPH1+W3usfRUh68594e8YKqBUORo2c5bCCCYDh0A@mail.gmail.com>
	<CAKocOOOaWSvWZkhLNBx9u6M5nOu39wUgnS-a9Srsbp5BTcdh1A@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DF086E6@sausexdag04.amd.com>
Date: Wed, 23 Jan 2013 11:44:54 -0700
Message-ID: <CAKocOOMD9i7TtzoH3c2pDXqSRXV8RB1qmqp_QxftCpfK763CqA@mail.gmail.com>
Subject: Re: Linux 3.8-rc4
From: Shuah Khan <shuahkhan@gmail.com>
To: "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 6:40 AM, Deucher, Alexander
<Alexander.Deucher@amd.com> wrote:
>> -----Original Message-----
>> From: Shuah Khan [mailto:shuahkhan@gmail.com]
>> Sent: Tuesday, January 22, 2013 6:57 PM
>> To: Deucher, Alexander
>> Cc: Linus Torvalds; Linux Kernel Mailing List
>> Subject: Re: Linux 3.8-rc4
>>
>> On Tue, Jan 22, 2013 at 11:55 AM, Shuah Khan <shuahkhan@gmail.com>
>> wrote:
>>
>> >>> init:
>> >>
>> >> Does the attached patch stop them?  It basically skips all initialization of
>> the DMA ring on your system.  What I don't understand is why you still get
>> them with the previous patch, but not with
>> 909d9eb67f1e4e39f2ea88e96bde03d560cde3eb reverted.
>> 909d9eb67f1e4e39f2ea88e96bde03d560cde3eb only affects the use of the
>> DMA ring for buffer migration and the patch I previously attached disables
>> the use of the DMA ring for buffer migration.  Does the latest batch of drm-
>> fixes from Dave that Linus just merged help?
>> >>
>> >> Alex
>> >
>> > Will try your latest patch. Will also try the latest git - I am
>> > currently on Jan 17th. However, in the meantime, I found that these
>> > messages might not be new and getting printed now with the
>> > eaaa6983ab2ccdf826c90838eb584211e0cadb76 [PATCH] drm/radeon: print
>> dma
>> > status reg on lockup (v2) commit that introduced debug messages in
>> > r600_gpu_soft_reset(). I couldn't revert this commit, but doing a
>> > compile with these messages commented out. Will update you on the
>> > results and then test the new git
>> >
>> > -- Shuah
>>
>> Here is what I tried:
>>
>> 1. Applied your latest disable_dma_ring_on_6xx-2.diff and still see
>> messages.
>
> If that is the case, I'm beginning to think the bug is elsewhere.  Support for the DMA ring was the only major feature we added in this cycle.  If you are still getting errors even with the ring completely disabled, it's probably not the DMA ring.
>
> Make sure your kernel has this patch:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=20707874fd4fd37e09513f508e642fa8bd06365a
> That's the only thing I can think of that may cause the DMAR errors if the DMA ring is disabled.
>

I verified I have this commit. ok maybe the bug is elsewhere. So far
all my bisects are on drivers/gpu/drm/radeon - I am going go one more
level up and start at drivers/gpu/drm and see what I can isolate it
that way. I do know that I don't see this problem on 3.7.4

-- Shuah
