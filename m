Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab3AVSzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 13:55:53 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:47320 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536Ab3AVSzs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 13:55:48 -0500
MIME-Version: 1.0
In-Reply-To: <A3397C8B8B789E45844E7EC5DEAD89D02DF084EA@sausexdag04.amd.com>
References: <CA+55aFx5ZyFtd59ygn6ja5X-3ZyRvhfJLqtNKyF_mH3+-kSjKg@mail.gmail.com>
	<CAKocOOPr4wddCmDEWKmsKsKeTc3m779opuN_qRb4yiL63KVZ8A@mail.gmail.com>
	<CAKocOOPp1PA-n_=xdPuBSBKaKiREqhgeo02QqWpP-oX7vnN_YA@mail.gmail.com>
	<CAKocOOOpDb=0XgX-uhDbBjOF7qK_M5MA31q9ScD0yTat0QRquQ@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DC30FE7@sausexdag04.amd.com>
	<CAKocOONuFvcik229+1B0oeaBnQG7seZPeYf99xqduFa6kBZhOw@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DF083DE@sausexdag04.amd.com>
	<CAKocOOMxAYw-XO-6XGteKb8NyHDq4_BdZn2njUNBh+a73wrFGA@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DF084EA@sausexdag04.amd.com>
Date: Tue, 22 Jan 2013 11:55:46 -0700
Message-ID: <CAKocOOOYKAZPH1+W3usfRUh68594e8YKqBUORo2c5bCCCYDh0A@mail.gmail.com>
Subject: Re: Linux 3.8-rc4
From: Shuah Khan <shuahkhan@gmail.com>
To: "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 11:40 AM, Deucher, Alexander
<Alexander.Deucher@amd.com> wrote:
>> -----Original Message-----
>> From: Shuah Khan [mailto:shuahkhan@gmail.com]
>> Sent: Tuesday, January 22, 2013 1:06 PM
>> To: Deucher, Alexander
>> Cc: Linus Torvalds; Linux Kernel Mailing List
>> Subject: Re: Linux 3.8-rc4
>>
>> On Tue, Jan 22, 2013 at 9:36 AM, Deucher, Alexander
>> <Alexander.Deucher@amd.com> wrote:
>> >> -----Original Message-----
>> >> From: Shuah Khan [mailto:shuahkhan@gmail.com]
>> >> Sent: Tuesday, January 22, 2013 11:15 AM
>> >> To: Deucher, Alexander
>> >> Cc: Linus Torvalds; Linux Kernel Mailing List
>> >> Subject: Re: Linux 3.8-rc4
>> >>
>> >> On Sat, Jan 19, 2013 at 9:44 AM, Deucher, Alexander
>> >> <Alexander.Deucher@amd.com> wrote:
>> >> >> -----Original Message-----
>> >> >> From: Shuah Khan [mailto:shuahkhan@gmail.com]
>> >> >> Sent: Friday, January 18, 2013 7:40 PM
>> >> >> To: Linus Torvalds; Deucher, Alexander
>> >> >> Cc: Linux Kernel Mailing List
>> >> >> Subject: Re: Linux 3.8-rc4
>> >> >>
>> >> >> On Fri, Jan 18, 2013 at 3:37 PM, Shuah Khan <shuahkhan@gmail.com>
>> >> wrote:
>> >> >> > On Fri, Jan 18, 2013 at 10:51 AM, Shuah Khan
>> <shuahkhan@gmail.com>
>> >> >> wrote:
>> >> >>
>> >> >> >
>> >> >> > ok. I bisected the DMAR faults and it points to the following commit:
>> >> >> >
>> >> >> > 909d9eb67f1e4e39f2ea88e96bde03d560cde3eb
>> >> >> >
>> >> >> > This commit as I recall, fixed the crash problem I was seeing back in
>> >> >> > 3.8-rc1. Reverting to see if crash problem reappears.
>> >> >>
>> >> >> Confirming that with this commit reverted crash problem re-appeared.
>> >> >> With this commit, DMAR faults show up.
>> >> >
>> >> > I'm not quite sure what's going on with your system.   At this point it's
>> >> probably best to just disable the DMA ring on these cards until we sort out
>> >> what's going on.  The attached patch disables the use of the DMA ring.
>> Let
>> >> me know if it fixes the issues you are seeing.
>> >> >
>> >>
>> >> I applied this patch to 3.8-rc4 and didn't fix the DMAR faults.
>> >
>> > Are you getting continuous DMAR faults or just when while the module is
>> being loaded?
>> >
>> > Alex
>>
>> During module initialization, I think might be actually right after
>> RV620 Microcode loading attempt: dmesg excerpts starting from radeoan
>> init:
>
> Does the attached patch stop them?  It basically skips all initialization of the DMA ring on your system.  What I don't understand is why you still get them with the previous patch, but not with 909d9eb67f1e4e39f2ea88e96bde03d560cde3eb reverted.  909d9eb67f1e4e39f2ea88e96bde03d560cde3eb only affects the use of the DMA ring for buffer migration and the patch I previously attached disables the use of the DMA ring for buffer migration.  Does the latest batch of drm-fixes from Dave that Linus just merged help?
>
> Alex

Will try your latest patch. Will also try the latest git - I am
currently on Jan 17th. However, in the meantime, I found that these
messages might not be new and getting printed now with the
eaaa6983ab2ccdf826c90838eb584211e0cadb76 [PATCH] drm/radeon: print dma
status reg on lockup (v2) commit that introduced debug messages in
r600_gpu_soft_reset(). I couldn't revert this commit, but doing a
compile with these messages commented out. Will update you on the
results and then test the new git

-- Shuah
