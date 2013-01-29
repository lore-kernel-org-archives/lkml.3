Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343Ab3A2Vjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 16:39:35 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:62373 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab3A2Vje convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 16:39:34 -0500
MIME-Version: 1.0
In-Reply-To: <A3397C8B8B789E45844E7EC5DEAD89D02DF0A37D@sausexdag04.amd.com>
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
	<CAKocOOMD9i7TtzoH3c2pDXqSRXV8RB1qmqp_QxftCpfK763CqA@mail.gmail.com>
	<CAKocOONFpPBQH=naKdmrXa1ijpzf=0jonKuUWbw3NhEeumfM=A@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DF0A266@sausexdag04.amd.com>
	<CAKocOOPsvh=jOXLahe6ukjpyjOOqt9tRdwELxv8i0_Vi1xqQkA@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DF0A37D@sausexdag04.amd.com>
Date: Tue, 29 Jan 2013 14:39:32 -0700
Message-ID: <CAKocOOORwoUAStDmFPhW1--WhAJaEzEmG-=tZ1sgkWKsquq=rQ@mail.gmail.com>
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

On Tue, Jan 29, 2013 at 1:13 PM, Deucher, Alexander
<Alexander.Deucher@amd.com> wrote:
>> -----Original Message-----
>> From: Shuah Khan [mailto:shuahkhan@gmail.com]
>> Sent: Tuesday, January 29, 2013 2:11 PM
>> To: Deucher, Alexander
>> Cc: Linus Torvalds; Linux Kernel Mailing List
>> Subject: Re: Linux 3.8-rc4
>>
>> On Tue, Jan 29, 2013 at 6:05 AM, Deucher, Alexander
>> <Alexander.Deucher@amd.com> wrote:
>> >> -----Original Message-----
>> >> I was out sick for a few days and finally picked this bisect backup
>> >> again. I started at 3.7 tag instead of 3.8-rc1 that I did in the past
>> >> and also did bisect at drivers/gpu/drm/radeon instead. Here are the
>> >> results:
>> >>
>> >> 6253e4c75d96006c06b9ac8f417eba873de2497b is the first bad commit
>> >> commit 6253e4c75d96006c06b9ac8f417eba873de2497b
>> >> Author: Alex Deucher <alexander.deucher@amd.com>
>> >> Date:   Wed Dec 12 14:30:32 2012 -0500
>> >>
>> >>     drm/radeon: improve mc_stop/mc_resume on r5xx-r7xx
>> >>
>> >>     Along the same lines of what was done for evergreen+
>> >>     in the last kernel.
>> >>
>> >>     Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
>> >>
>> >> git bisect log attached.
>> >>
>> >
>> > Try the attached patch.  I think it should fix the issue.  I just applied a similar
>> patch for newer asics.
>> >
>> > Alex
>> >
>>
>> I reverted 6253e4c75d96006c06b9ac8f417eba873de2497b and DMAR faults
>> went away. Undid the revert and applied your new patch. DMAR faults
>> are back again.
>>
>>
>> [   25.158653] [drm] PCIE GART of 512M enabled (table at
>> 0x0000000000040000).
>> [   25.158715] radeon 0000:01:00.0: WB enabled
>> [   25.158719] radeon 0000:01:00.0: fence driver on ring 0 use gpu
>> addr 0x0000000008000c00 and cpu addr 0xffff88002f143c00
>> [   25.158721] radeon 0000:01:00.0: fence driver on ring 3 use gpu
>> addr 0x0000000008000c0c and cpu addr 0xffff88002f143c0c
>>
>> A few observations and questions about r600_startup() code sequence:
>>
>> I notice DMAR faults right after
>>
>> [drm] Loading RV620 Microcode message which is from
>> r600_init_microcode(). This routine does a series of
>> request_firmware() calls. btw. don't see release_firmware() calls in
>> regular code path, only from error legs in r600_init_microcode().
>>
>> However, this routine doesn't do any loading yet. When this routine
>> returns, I am assuming request_firmware() step isn't complete yet
>> based on my reading request_firmware() interface. At this point
>> r600_startup() keeps chugging along, and does r600_mc_program() which
>> in turn calls rv515_mc_stop() which was changed with the
>> 6253e4c75d96006c06b9ac8f417eba873de2497b commit.
>>
>> I am thinking the changes somehow eliminated a wait or delay that used
>> be there for request_firmware() step to complete (?)
>>
>> I can see from dmesg that the faults occur right after:
>>
>> r600_init_microcode(rdev);
>>
>> and stop before r600_pcie_gart_enable()
>
> r600_init_microcode() doesn't actually touch the hardware it just calls request_firmware() to fetch the microcode images from disk.  The microcode doesn't get loaded onto the hardware until r600_cp_load_microcode() much later in the function.  I don't think the microcode has anything to do with this.
>
> rv515_mc_stop() stops GPU memory clients (e.g., the displays) and blacks out the GPU memory controller so that we can change the location of VRAM within the GPU's address space.  If one of the display controllers memory request stop requests takes too long to go through for some reason, it's possible that the display hardware may attempt to read from a GPU memory location no-longer backed by vram (since we changed the location of vram in r600_mc_program()) momentarily until the stop request goes through.  Does the attached updated version of the patch help?  Alternatively, you can try adding delays to the end of rv515_mc_stop() and see if that helps.
>
> Alex
>

This v2 patch didn't help. I added  mdelay(15); at the end of
rv515_mc_stop() on top of this v2 patch and that fixed the problem.
mdelay(15) is a bit much I am sure. Shouldn't rv515_mc_wait_for_idle()
take care of the delay? It waits for idle usec_timeout?

-- Shuah
