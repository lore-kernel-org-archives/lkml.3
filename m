Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab3AZPF4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 10:05:56 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:53250 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab3AZPFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 10:05:54 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUUh8OTXnFWzC5r=9+-uOxFEanCksBx9wMRWaY_f20cfxQ@mail.gmail.com>
References: <CA+icZUW6LBSjpqK-eQUAt7R=kXCPRjFoi=z1UijaajrVAj=fEg@mail.gmail.com>
	<1378199.89Y5N0mHyy@vostro.rjw.lan>
	<CA+icZUV_9Ax3ZZpkO0XDfhkU1U+KE6beobeUC2zcUyAENBLPnQ@mail.gmail.com>
	<CA+icZUUh8OTXnFWzC5r=9+-uOxFEanCksBx9wMRWaY_f20cfxQ@mail.gmail.com>
Date: Sat, 26 Jan 2013 16:05:53 +0100
Message-ID: <CA+icZUX=XdAJjWwx8P_y31JGW3GC+tdWuFhv2Ym-0OELGWGbDQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Jan 25 (BROKEN suspend)
From: Sedat Dilek <sedat.dilek@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Sasha Levin <sasha.levin@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2013 at 3:33 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Sat, Jan 26, 2013 at 2:24 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> On Sat, Jan 26, 2013 at 2:25 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>> On Saturday, January 26, 2013 12:10:32 PM Sedat Dilek wrote:
>>>> On Fri, Jan 25, 2013 at 6:26 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>>> > Hi all,
>>>> >
>>>> > Changes since 20130124:
>>>> >
>>>> > New trees: ipsec and ipsec-next
>>>> >
>>>> > The powerpc tree still had a build failure.
>>>> >
>>>> > The sound-asoc tree still had its build failure so I used the version from
>>>> > next-20130122.
>>>> >
>>>> > The akpm tree lost its build failure and several patches that turned up
>>>> > elsewhere.
>>>> >
>>>> > ----------------------------------------------------------------------------
>>>> >
>>>>
>>>> Unfortunately, on suspend or running the pm_test/freezer leads here to
>>>> a frozen machine - hard reset.
>>>>
>>>> I see 4-5 pages of call-traces but dunno how to log them in such a f-u-ed state.
>>>> Any hints welcome!
>>>>
>>>> As I saw catched with my left eye on one call-trace sth. with...
>>>>
>>>>       kernel/watchdog.c (line #245, watchdog_overflow_callback)
>>>>
>>>> ... I tried to revert the last two commits from Sascha (see -3 patch,
>>>> but no success.
>>>>
>>>> The same with reverting all cpu-freq changes since v3.8-rc4 (see -4
>>>> patch) after seeing some suspicious lines on the screen.
>>>>
>>>> Can someone confirm that suspend is BROKEN for him/her before doing
>>>> eventually a bisect?
>>>
>>> Can you please test the linux-next branch of the linux-pm.git tree alone?
>>>
>>
>> That sounds like a good idea as I just reverted "cpu-hotplug,
>> memory-hotplug: try offlining the node when hotremoving a cpu" [1]
>> from akpm tree.
>> Building... 1st with revert than trying pm-next only.
>>
>
> Your pm-next tree is fine here.
>
> commit 0b9d032a2bf0a0224ef446f3d6048fdd8a5b8280
> "Merge branch 'pm-cpufreq-next' into linux-next linux-next"
>
> Furthermore, the culprit is not between akpm-master and akpm-current
> as I have seen cpu/mem hotplug and pm changes there.
>
> Hmm, maybe bisecting would have been faster than hunting on suspicious commits.
>
> - Sedat -
>
>> - Sedat -
>>
>> [1] http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=154cb61f36690edef68beb5fd9dc0a5027f9dbd9
>>
>>> Rafael
>>>
>>>
>>> --
>>> I speak only for myself.
>>> Rafael J. Wysocki, Intel Open Source Technology Center.

I merged on top of my Linux-v3.8-rc5 GIT branch...

Sedat Dilek (8):
      mei: Fix some more kernel-doc typos in hw-me.c
      kbuild: deb-pkg: Try to determine distribution
      kbuild: deb-pkg: Bump year in debian/copyright file
      kbuild: deb-pkg: Update git repository URL in debian/copyright file
      Merge tag 'next-20130124' of
git://git.kernel.org/.../next/linux-next into Linux-Next-v20130124
      Merge branch 'deb-pkg-fixes' into 3.8.0-rc5-next20130124-1-pmnext-generic
      Merge branch 'Linux-Next-v20130124' into
3.8.0-rc5-next20130124-1-pmnext-generic
      Merge branch 'pm-next' into 3.8.0-rc5-next20130124-1-pmnext-generic

...and this f-u-s the machine as well.
So, the culprit seems not to get from your PM stuff.

Anyway, this does not help me... but hope it's good news for you, Rafael :-)!

- Sedat -
