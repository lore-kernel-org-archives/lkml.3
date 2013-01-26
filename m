Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab3AZNYT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 08:24:19 -0500
Received: from mail-qe0-f52.google.com ([209.85.128.52]:32778 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab3AZNYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 08:24:17 -0500
X-Greylist: delayed 8022 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Jan 2013 08:24:16 EST
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1378199.89Y5N0mHyy@vostro.rjw.lan>
References: <CA+icZUW6LBSjpqK-eQUAt7R=kXCPRjFoi=z1UijaajrVAj=fEg@mail.gmail.com>
	<1378199.89Y5N0mHyy@vostro.rjw.lan>
Date: Sat, 26 Jan 2013 14:24:15 +0100
Message-ID: <CA+icZUV_9Ax3ZZpkO0XDfhkU1U+KE6beobeUC2zcUyAENBLPnQ@mail.gmail.com>
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

On Sat, Jan 26, 2013 at 2:25 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Saturday, January 26, 2013 12:10:32 PM Sedat Dilek wrote:
>> On Fri, Jan 25, 2013 at 6:26 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> > Hi all,
>> >
>> > Changes since 20130124:
>> >
>> > New trees: ipsec and ipsec-next
>> >
>> > The powerpc tree still had a build failure.
>> >
>> > The sound-asoc tree still had its build failure so I used the version from
>> > next-20130122.
>> >
>> > The akpm tree lost its build failure and several patches that turned up
>> > elsewhere.
>> >
>> > ----------------------------------------------------------------------------
>> >
>>
>> Unfortunately, on suspend or running the pm_test/freezer leads here to
>> a frozen machine - hard reset.
>>
>> I see 4-5 pages of call-traces but dunno how to log them in such a f-u-ed state.
>> Any hints welcome!
>>
>> As I saw catched with my left eye on one call-trace sth. with...
>>
>>       kernel/watchdog.c (line #245, watchdog_overflow_callback)
>>
>> ... I tried to revert the last two commits from Sascha (see -3 patch,
>> but no success.
>>
>> The same with reverting all cpu-freq changes since v3.8-rc4 (see -4
>> patch) after seeing some suspicious lines on the screen.
>>
>> Can someone confirm that suspend is BROKEN for him/her before doing
>> eventually a bisect?
>
> Can you please test the linux-next branch of the linux-pm.git tree alone?
>

That sounds like a good idea as I just reverted "cpu-hotplug,
memory-hotplug: try offlining the node when hotremoving a cpu" [1]
from akpm tree.
Building... 1st with revert than trying pm-next only.

- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=154cb61f36690edef68beb5fd9dc0a5027f9dbd9

> Rafael
>
>
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
