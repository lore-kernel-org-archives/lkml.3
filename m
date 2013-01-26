Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab3AZS1K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 13:27:10 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:39851 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab3AZS1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 13:27:08 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUX=XdAJjWwx8P_y31JGW3GC+tdWuFhv2Ym-0OELGWGbDQ@mail.gmail.com>
References: <CA+icZUW6LBSjpqK-eQUAt7R=kXCPRjFoi=z1UijaajrVAj=fEg@mail.gmail.com>
	<1378199.89Y5N0mHyy@vostro.rjw.lan>
	<CA+icZUV_9Ax3ZZpkO0XDfhkU1U+KE6beobeUC2zcUyAENBLPnQ@mail.gmail.com>
	<CA+icZUUh8OTXnFWzC5r=9+-uOxFEanCksBx9wMRWaY_f20cfxQ@mail.gmail.com>
	<CA+icZUX=XdAJjWwx8P_y31JGW3GC+tdWuFhv2Ym-0OELGWGbDQ@mail.gmail.com>
Date: Sat, 26 Jan 2013 19:27:06 +0100
Message-ID: <CA+icZUX31SB3+NU8uXA9LH5KOHxgeHKZLcqWNhzUVhx5onk6qA@mail.gmail.com>
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

On Sat, Jan 26, 2013 at 4:05 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Sat, Jan 26, 2013 at 3:33 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> On Sat, Jan 26, 2013 at 2:24 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>> On Sat, Jan 26, 2013 at 2:25 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>>> On Saturday, January 26, 2013 12:10:32 PM Sedat Dilek wrote:
>>>>> On Fri, Jan 25, 2013 at 6:26 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>>>> > Hi all,
>>>>> >
>>>>> > Changes since 20130124:
>>>>> >
>>>>> > New trees: ipsec and ipsec-next
>>>>> >
>>>>> > The powerpc tree still had a build failure.
>>>>> >
>>>>> > The sound-asoc tree still had its build failure so I used the version from
>>>>> > next-20130122.
>>>>> >
>>>>> > The akpm tree lost its build failure and several patches that turned up
>>>>> > elsewhere.
>>>>> >
>>>>> > ----------------------------------------------------------------------------
>>>>> >
>>>>>
>>>>> Unfortunately, on suspend or running the pm_test/freezer leads here to
>>>>> a frozen machine - hard reset.
>>>>>
>>>>> I see 4-5 pages of call-traces but dunno how to log them in such a f-u-ed state.
>>>>> Any hints welcome!
>>>>>
>>>>> As I saw catched with my left eye on one call-trace sth. with...
>>>>>
>>>>>       kernel/watchdog.c (line #245, watchdog_overflow_callback)
>>>>>
>>>>> ... I tried to revert the last two commits from Sascha (see -3 patch,
>>>>> but no success.
>>>>>
>>>>> The same with reverting all cpu-freq changes since v3.8-rc4 (see -4
>>>>> patch) after seeing some suspicious lines on the screen.
>>>>>
>>>>> Can someone confirm that suspend is BROKEN for him/her before doing
>>>>> eventually a bisect?
>>>>
>>>> Can you please test the linux-next branch of the linux-pm.git tree alone?
>>>>
>>>
>>> That sounds like a good idea as I just reverted "cpu-hotplug,
>>> memory-hotplug: try offlining the node when hotremoving a cpu" [1]
>>> from akpm tree.
>>> Building... 1st with revert than trying pm-next only.
>>>
>>
>> Your pm-next tree is fine here.
>>
>> commit 0b9d032a2bf0a0224ef446f3d6048fdd8a5b8280
>> "Merge branch 'pm-cpufreq-next' into linux-next linux-next"
>>
>> Furthermore, the culprit is not between akpm-master and akpm-current
>> as I have seen cpu/mem hotplug and pm changes there.
>>
>> Hmm, maybe bisecting would have been faster than hunting on suspicious commits.
>>
>> - Sedat -
>>
>>> - Sedat -
>>>
>>> [1] http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=154cb61f36690edef68beb5fd9dc0a5027f9dbd9
>>>
>>>> Rafael
>>>>
>>>>
>>>> --
>>>> I speak only for myself.
>>>> Rafael J. Wysocki, Intel Open Source Technology Center.
>
> I merged on top of my Linux-v3.8-rc5 GIT branch...
>
> Sedat Dilek (8):
>       mei: Fix some more kernel-doc typos in hw-me.c
>       kbuild: deb-pkg: Try to determine distribution
>       kbuild: deb-pkg: Bump year in debian/copyright file
>       kbuild: deb-pkg: Update git repository URL in debian/copyright file
>       Merge tag 'next-20130124' of
> git://git.kernel.org/.../next/linux-next into Linux-Next-v20130124
>       Merge branch 'deb-pkg-fixes' into 3.8.0-rc5-next20130124-1-pmnext-generic
>       Merge branch 'Linux-Next-v20130124' into
> 3.8.0-rc5-next20130124-1-pmnext-generic
>       Merge branch 'pm-next' into 3.8.0-rc5-next20130124-1-pmnext-generic
>
> ...and this f-u-s the machine as well.
> So, the culprit seems not to get from your PM stuff.
>
> Anyway, this does not help me... but hope it's good news for you, Rafael :-)!
>
> - Sedat -

This tells me ZERO...

$ cat git-bisect-log.txt
git bisect start
# bad: [a8ae185b9edd81927bd762b89a327617e3e7a1e8] Add linux-next
specific files for 20130124
git bisect bad a8ae185b9edd81927bd762b89a327617e3e7a1e8
# good: [7d1f9aeff1ee4a20b1aeb377dd0f579fe9647619] Linux 3.8-rc4
git bisect good 7d1f9aeff1ee4a20b1aeb377dd0f579fe9647619
# bad: [5a4e73d60a0f01a39c602e3c2cbb2f136268f717] Merge
remote-tracking branch 'spi-mb/spi-next'
git bisect bad 5a4e73d60a0f01a39c602e3c2cbb2f136268f717
# good: [9b70ab49707f2db028b29664600db3fcf2221abd] Merge
remote-tracking branch 'slave-dma/next'
git bisect good 9b70ab49707f2db028b29664600db3fcf2221abd
# good: [97b57dc123017c4d748fdf2abdd9a9231239c437] Merge
remote-tracking branch 'crypto/master'
git bisect good 97b57dc123017c4d748fdf2abdd9a9231239c437
# good: [6ab8307c4b30d2414bbbc192d3b07819b2a2ec1e] 20130122/sound-asoc
git bisect good 6ab8307c4b30d2414bbbc192d3b07819b2a2ec1e
# good: [76e51c3f858996beb6de0dfd03838ec04f9c6203] Merge
remote-tracking branch 'mmc/mmc-next'
git bisect good 76e51c3f858996beb6de0dfd03838ec04f9c6203
# good: [25dcea3017741797805c1279d013108b220b6aea] Merge
remote-tracking branch 'battery/master'
git bisect good 25dcea3017741797805c1279d013108b220b6aea
# good: [c051f41da8c60f0945d295b736aa3c0331ac85bc] Merge
remote-tracking branch 'regulator/for-next'
git bisect good c051f41da8c60f0945d295b736aa3c0331ac85bc
# good: [6f9801536a9bea9f405971fab8abbba929138738] Merge
remote-tracking branch 'iommu/next'
git bisect good 6f9801536a9bea9f405971fab8abbba929138738
# good: [58e49ef6da7f434698699a20683408b2c041081d] Merge
remote-tracking branch 'trivial/for-next'
git bisect good 58e49ef6da7f434698699a20683408b2c041081d
# good: [33cb219590de91b65a9d0e995dbf26642d5d32e0] Merge
remote-tracking branch 'edac-amd/for-next'
git bisect good 33cb219590de91b65a9d0e995dbf26642d5d32e0
# good: [7a5d8ca12aece480e0fe5eda8ce4236dddf55363] spi: bitbang:
simplify pointer arithmetics
git bisect good 7a5d8ca12aece480e0fe5eda8ce4236dddf55363
# good: [bf2084d51182ed0fa1fcf3febd80b308d2e62b20] Merge
remote-tracking branch 'dt-rh/for-next'
git bisect good bf2084d51182ed0fa1fcf3febd80b308d2e62b20
# good: [f28037d2e9ee1fe34ede6211f1cce1d38d867cb8] MAINTAINERS: Add
myself as a backup maintainer for SPI
git bisect good f28037d2e9ee1fe34ede6211f1cce1d38d867cb8

$ cat git-bisect-view--stat.txt
commit 5a4e73d60a0f01a39c602e3c2cbb2f136268f717
Merge: bf2084d f28037d
Author: Stephen Rothwell <sfr@canb.auug.org.au>
Date:   Thu Jan 24 13:49:47 2013 +1100

    Merge remote-tracking branch 'spi-mb/spi-next'

- Sedat -
