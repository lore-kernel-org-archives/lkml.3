Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164Ab3BGLOu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 06:14:50 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:45299 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab3BGLOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 06:14:46 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: sedat.dilek@gmail.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
References: <CA+icZUXzh1S2+ZQ8vvPFSN8jXS62kijbAP+83F0hG9emLQzpQw@mail.gmail.com>
	<CA+icZUWQuLe1banpd9qzuvUtSep0GiyQWpu=yjhSao_9qAgaUA@mail.gmail.com>
	<CA+icZUWNXpta6PhVCMvEjZVTgi0H0AC4Ou+ysG+b5PMEF6kxXQ@mail.gmail.com>
Date: Thu, 07 Feb 2013 03:14:30 -0800
In-Reply-To: <CA+icZUWNXpta6PhVCMvEjZVTgi0H0AC4Ou+ysG+b5PMEF6kxXQ@mail.gmail.com>
	(Sedat Dilek's message of "Thu, 7 Feb 2013 11:42:40 +0100")
Message-ID: <87ip644bqh.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+zvT1o7mz1HEBM0wYD4rSRcVMwzjLeq2o=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0026]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;sedat.dilek@gmail.com
X-Spam-Relay-Country: 
Subject: Re: linux-next: Tree for Feb 7 (fakeroot BROKEN due to SYSV IPC support?)
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sedat Dilek <sedat.dilek@gmail.com> writes:

> On Thu, Feb 7, 2013 at 11:20 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> On Thu, Feb 7, 2013 at 10:38 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>> On Thu, Feb 7, 2013 at 7:37 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>>> Hi all,
>>>>
>>>> Changes since 20130206:
>>>>
>>>> Removed tree: kvmtool (still present via the tip tree)
>>>>
>>>> The block tree lost its build failure.
>>>>
>>>> The tip tree gained a conflict against the s390 tree.
>>>>
>>>> The kvm tree gained a conflict against Linus' tree.
>>>>
>>>> The tty tree lost its build failure.
>>>>
>>>> The arm-soc tree gained conflicts against the iommu tree.
>>>>
>>>> The signal tree gained a conflict against the s390 tree.
>>>>
>>>> The akpm tree gained a conflict against the kvm tree and lost its build
>>>> failure.
>>>>
>>>> ----------------------------------------------------------------------------
>>>>
>>>
>>> My build-script uses fakeroot and does no more start:
>>>
>>> $ ./scripts/build_linux-next.sh
>>> make options ...... CC=gcc-4.6 -j4
>>> KBUILD_BUILD_USER=sedat.dilek@gmail.com
>>> LOCALVERSION=-next20130207-2-iniza-small
>>> dep-pkg options ... KDEB_PKGVERSION=3.8.0~rc6~next20130207-2~iniza+dileks1
>>> fakeroot, while creating message channels: Invalid argument
>>> This may be due to a lack of SYSV IPC support.
>>> fakeroot: error while starting the `faked' daemon.
>>> kill: usage: kill [-s sigspec | -n signum | -sigspec] pid | jobspec
>>> ... or kill -l [sigspec]
>>>
>>>
>>> Any hints?
>>> ( I could run strace... )
>>>
>>> - Sedat -
>>
>> Attached strace outputs within yesterday's (GOOD) and today's (BAD) Linux-Next.
>>
>> - Sedat -
>
> [ CCing Al and Eric ]
>
> I compared quickly the diff between the -next versions and saw changes
> coming from signal and userns trees.
> ( Sorry for re-attaching the strace outputs. )

It has been about a week and a half since I have pushed anything into
the userns tree, and I don't have anything ipc related in my tree.
So the reason for the suspicion seems odd.

The straces are useless because all they show is that fakeroot was
forked, but there is not a trace of fakeroot itself.

Given the timing my initial suspect would be the idr_preload patches
from Tejun that were merged via Andrew's akpm tree.  I didn't see
anything in there that would kill ipc but that is likely the most recent
touch to the ipc code.

Eric
