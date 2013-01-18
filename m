Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab3ARRnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 12:43:41 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:34749 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab3ARRnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 12:43:40 -0500
MIME-Version: 1.0
In-Reply-To: <CAKocOOOgA2Pd3A9upag0xpgNsSu-vaVNAH8KpXD4gt1Q6AnrjA@mail.gmail.com>
References: <CAKocOOMagCzn7fkkZJM+r5K--yXjZ40jCsHpwi97gCKo1keZ1A@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DC2FB3A@sausexdag04.amd.com>
	<CAKocOOMrTf9RMa17Zy_oK+uPJ_B7uNwxhsX7dOm4okVdnmwY5A@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DC30C27@sausexdag04.amd.com>
	<CAKocOOPNf5HZOO421Cvhb35fMxM6Tfu7w2aXZb3UF3igS9S=Kw@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DC30C52@sausexdag04.amd.com>
	<CAKocOOOgA2Pd3A9upag0xpgNsSu-vaVNAH8KpXD4gt1Q6AnrjA@mail.gmail.com>
Date: Fri, 18 Jan 2013 10:38:25 -0700
Message-ID: <CAKocOONGgpHfDRxc5J9NvsyN3PmHJwuuPKEEMce0SY9+iQp81g@mail.gmail.com>
Subject: Re: linux 3.8-rc3 reboot and shutdown
From: Shuah Khan <shuahkhan@gmail.com>
To: "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc: "jglisse@redhat.com" <jglisse@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 7:55 PM, Shuah Khan <shuahkhan@gmail.com> wrote:
> On Thu, Jan 17, 2013 at 5:35 PM, Deucher, Alexander
> <Alexander.Deucher@amd.com> wrote:
>>> -----Original Message-----
>>> From: Shuah Khan [mailto:shuahkhan@gmail.com]
>>> Sent: Thursday, January 17, 2013 7:26 PM
>>> To: Deucher, Alexander
>>> Cc: jglisse@redhat.com; linux-kernel@vger.kernel.org
>>> Subject: Re: linux 3.8-rc3 reboot and shutdown
>>>
>>> On Thu, Jan 17, 2013 at 4:48 PM, Deucher, Alexander
>>> <Alexander.Deucher@amd.com> wrote:
>>> >> -----Original Message-----
>>> >> From: Shuah Khan [mailto:shuahkhan@gmail.com]
>>> >> Sent: Thursday, January 17, 2013 6:21 PM
>>> >> To: Deucher, Alexander
>>> >> Cc: jglisse@redhat.com; linux-kernel@vger.kernel.org
>>> >> Subject: Re: linux 3.8-rc3 reboot and shutdown
>>> >>
>>> >> On Thu, Jan 17, 2013 at 12:45 PM, Deucher, Alexander
>>> >> <Alexander.Deucher@amd.com> wrote:
>>> >> >> -----Original Message-----
>>> >> >> From: Shuah Khan [mailto:shuahkhan@gmail.com]
>>> >> >> Sent: Thursday, January 17, 2013 2:03 PM
>>> >> >> To: jglisse@redhat.com; Deucher, Alexander
>>> >> >> Cc: linux-kernel@vger.kernel.org; Shuah Khan
>>> >> >> Subject: linux 3.8-rc3 reboot and shutdown
>>> >> >>
>>> >> >> Alex,
>>> >> >>
>>> >> >> I started seeing hang during shutdown and reboot on my laptop that
>>> has
>>> >> >> ATI radeon VGA.
>>> >> >>
>>> >> >> 01:00.0 VGA compatible controller: Advanced Micro Devices [AMD]
>>> nee
>>> >> >> ATI RV620 [Mobility Radeon HD 3400 Series] (prog-if 00 [VGA
>>> >> >> controller])
>>> >> >>
>>> >> >> My bisect narrowed it to the following commit.
>>> >> >
>>> >> > Should be fixed by this commit:
>>> >> > http://cgit.freedesktop.org/~agd5f/linux/commit/?h=drm-fixes-
>>> >> 3.8&id=19fc42ed9950d5fe17089c0a928121047c882092
>>> >> > Which should be finding its way upstream any day now.
>>> >> >
>>> >> > Alex
>>> >> >
>>> >>
>>> >> Alex,
>>> >>
>>> >> Applied this patch on 3.8-rc3 and tested it. reboot still hung. The
>>> >> only thing that fixes the problem is reverting
>>> >> 71e3d1578c954cf29f1f4db1c8930d3574025eb0
>>> >
>>> > Does the attached patch applied in addition to:
>>> > http://cgit.freedesktop.org/~agd5f/linux/commit/?h=drm-fixes-
>>> 3.8&id=19fc42ed9950d5fe17089c0a928121047c882092
>>> > fix the issue?
>>> >
>>> > Alex
>>>
>>> No reboot still hung after applying
>>> 0001-drm-radeon-don-t-attempt-to-soft-reset-DMA-ring-on-r.patch  in
>>> addition to 19fc42ed9950d5fe17089c0a928121047c882092
>>
>> Can you send me the dmesg from the failed reboot?
>>
>> Alex
>
> dmesg from good and bad attached. The good one is the one I bisected
> and the bad one is the kernel with
> 0001-drm-radeon-don-t-attempt-to-soft-reset-DMA-ring-on-r.patch  in
> addition to 19fc42ed9950d5fe17089c0a928121047c882092
>
> You will notice that both have  DMAR faults.
> [   18.357712] DMAR:[fault reason 06] PTE Read access is not set
> [   18.357730] dmar: DRHD: handling fault status reg 3
> [   18.357734] dmar: DMAR:[DMA Read] Request device [01:00.0] fault
> addr 80006000
>
> I haven't gotten a chance to bisect the DMAR problem. Will try to get
> to it tomorrow.
>

Alex,

I no longer see reboot/shutdown hang on linux 3.8-rc4. I still see
DMAR errors. Working on bisecting that one.

-- Shuah
