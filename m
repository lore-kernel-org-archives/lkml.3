Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab3BNGoL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 01:44:11 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:59342 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071Ab3BNGoJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 01:44:09 -0500
MIME-Version: 1.0
In-Reply-To: <1360810114.1727.306.camel@jesse>
References: <1350138661-2454-1-git-send-email-linkinjeon@gmail.com>
	<1360810114.1727.306.camel@jesse>
Date: Thu, 14 Feb 2013 15:44:08 +0900
Message-ID: <CAKYAXd9qmDYivsJduT3bFD2vPOc0DQ0f8RQTxQ7MXXTCQMMQQA@mail.gmail.com>
Subject: Re: Read support for fat_fallocate()? (was [v2] fat: editions to
 support fat_fallocate())
From: Namjae Jeon <linkinjeon@gmail.com>
To: Andrew Bartlett <abartlet@samba.org>
Cc: hirofumi@mail.parknet.co.jp, linux-kernel@vger.kernel.org,
        Ravishankar N <cyberax82@gmail.com>,
        Amit Sahrawat <amit.sahrawat83@gmail.com>,
        Nam-Jae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/14, Andrew Bartlett <abartlet@samba.org>:
> (apologies for the duplicate mail, I typo-ed the maintainers address)
>
> G'day,
>
> I've been looking into the patch "[v2] fat: editions to support
> fat_fallocate()" and I wonder if there is a way we can split this issue
> in two, so that we get at least some of the patch into the kernel.
>
> https://lkml.org/lkml/2012/10/13/75
> https://patchwork.kernel.org/patch/1589161/
>
> What I'm wanting to discuss (and perhaps implement, with you if
> possible) is splitting this patch into writing to existing pre-allocated
> files, and creating a new pre-allocation.
>
> If Windows does, as you claim, simply read preallocations as zero, and
> writes to them normally and without error, then Linux should do the
> same.  Here of course I'm assuming that Windows is not preallocating,
> but instead simply trying to recover gracefully and safely from a simple
> 'file system corruption', where the sectors are allocated but not used.
>
> The bulk of this patch is implementing this transparent recovery, and it
> seem relatively harmless to include this into the kernel.
>
> Then vendors doing TV streaming, or in my case copies of large files
> onto Samba-mounted USB FAT devices, can add only the smaller patch to
> implement fallocate, at their own risk and fully knowing that it will be
> regarded as corrupt on Linux.
>
> If accepted read support will, over a period of years, trickle down to
> other Linux users, broadening the base that can still read these
> 'corrupt' drives, no matter the cause.
>
> I hope you agree that this is a practical way forward, and I look
> forward to working with you on this.
>
> Thanks,
Hi Andrew.

First, Thanks for your interest !
A mismatch between inode size and reserved blocks can be either due to
pre-allocation (after our changes) or due to corruption (sudden unplug
of media etc).
We don’t think it is right to include only read only support (i.e.
without fallocate support) for such files because if such files are
encountered it only means that the file is corrupted, as there is no
current method to check if the issue is due to pre-allocation.
If it is to be included in the kernel, then the whole patch has to go
in. But then again, since the FAT specifications do not accommodate
for pre-allocation, then it is up to OGAWA to decide if this is
acceptable.
In any case, the patch will definitely break backward compatibility
(on an older fat driver without fallocate support) and also in case
for the two variants for the same kernel versions and only one has
FALLOCATE enabled, in such cases also, the behavior will assume
corruption in one case.

Thanks.

>
> Andrew Bartlett
> --
> Andrew Bartlett                                http://samba.org/~abartlet/
> Authentication Developer, Samba Team           http://samba.org
>
>
>
>
