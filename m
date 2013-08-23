Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990Ab3HWIEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 04:04:48 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:64145 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451Ab3HWIEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 04:04:38 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUWy4V_6YSa_wMeZRZ=1w08YihumWXPikJdkiuPgkOb_mw@mail.gmail.com>
References: <CA+icZUUkS-UptLRM1CfcaHH=8UD-ZaHbXr8wFkA+YKyk-rPjvg@mail.gmail.com>
	<20130821134441.GE26909@phenom.ffwll.local>
	<CA+icZUVLau7AgZvcnWKjx=tc4WeuJ3qEH7qQta+YLKDmxk6QvA@mail.gmail.com>
	<20130821212012.GH26909@phenom.ffwll.local>
	<CA+icZUUoZ3WRNChLJ8vfP_MxJhTu2annkWCmB8jnqOxNKSEtOg@mail.gmail.com>
	<20130822072417.GM26909@phenom.ffwll.local>
	<CA+icZUXoebf4p1pp6wkaOMFbfVjjL1+wDbYF+SvLUjkm991Rcg@mail.gmail.com>
	<CAKMK7uG5AntN=nQ6TWUwNgXJh7tATu5TacccYah36sXnLAmAiQ@mail.gmail.com>
	<CAKMK7uHfPb67Mshczxv6aPwwjQMb-tFwmdg8aH0VVSHnSyLiwA@mail.gmail.com>
	<CA+icZUWy4V_6YSa_wMeZRZ=1w08YihumWXPikJdkiuPgkOb_mw@mail.gmail.com>
Date: Fri, 23 Aug 2013 10:04:37 +0200
Message-ID: <CA+icZUUm=k9-G2M8+V-QkL3Tkv=5LXy_pyRKFnVSFjzF_vsX=A@mail.gmail.com>
Subject: Re: linux-next: Tree for Aug 21 [ screen corruption in graphical mode ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 9:55 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Thu, Aug 22, 2013 at 1:32 PM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
>> On Thu, Aug 22, 2013 at 1:30 PM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
>>> On Thu, Aug 22, 2013 at 1:13 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>>> dmesg (a lot of traces) and kernel-config attached.
>>>>
>>>> UXA causes still screen corruption.
>>>
>>> Hm, was only a slim chance that this patch would fix anything - I
>>> think you'd always see an oops when you'd hit this bug instead of just
>>> a bit of corruption.
>>
>> Ok, I think it's time to throw in the towel a bit. I've dropped
>>
>>
>> commit d46f1c3f1372e3a72fab97c60480aa4a1084387f
>> Author: Chris Wilson <chris@chris-wilson.co.uk>
>> Date:   Thu Aug 8 14:41:06 2013 +0100
>>
>>     drm/i915: Allow the GPU to cache stolen memory
>>
>> from my queue. I guess we can retry for 3.13 again.
>
> I am sorry to keep someone's work to be delayed, really.
> I would have liked to see this fixed (and I have spent some time on it).
>
> Which patches did you exactly drop?
>

Sorry for bombing you with question...

I am trying latest Linus-tree HEAD with the drm-intel-nightly I made
my last testings.

Are any of these TLB / x86-get_unmapped_area fixes of interested...
has any effects on the reported issue?

I still wonder what is the root-cause...
I mean if SNA is OK but UXA not and Linux graphics stack is that complex.
( Can't say if user-space like unity isn't involved... ).

- Sedat -

[1] Fix TLB gather virtual address range invalidation corner cases
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/patch/?id=2b047252d087be7f2ba088b4933cd904f92e6fce

[2] Revert "x86 get_unmapped_area(): use proper mmap base for
bottom-up direction"
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/patch/?id=5ea80f76a56605a190a7ea16846c82aa63dbd0aa

[3] x86 get_unmapped_area: Access mmap_legacy_base through mm_struct member
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/patch/?id=41aacc1eea645c99edbe8fbcf78a97dc9b862adc
