Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab3EFSoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 14:44:12 -0400
Received: from mout.gmx.net ([212.227.15.15]:60483 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545Ab3EFSoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 14:44:11 -0400
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX1/Swf8tNwTSNRCI01QR75RlfinbPTRvIyUZyysV2P
	x7fdgCq7UPuuGd
Message-ID: <5187F9F5.7090501@fisher-privat.net>
Date: Mon, 06 May 2013 20:44:05 +0200
From: Oleksij Rempel <bug-track@fisher-privat.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tony Luck <tony.luck@gmail.com>
CC: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: VFAT complains that my file system may be corrupted
References: <CA+8MBb++1CVLAo3zw4fx2O7akWsZcvybRyZpt0ac0sX7M=u5Xw@mail.gmail.com>
In-Reply-To: <CA+8MBb++1CVLAo3zw4fx2O7akWsZcvybRyZpt0ac0sX7M=u5Xw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 06.05.2013 20:36, schrieb Tony Luck:
> Built Linus' tree this morning (HEAD =
> d7ab7302f970a254997687a1cdede421a5635c68) and got this message:
>
> FAT-fs (sda1): Volume was not properly unmounted. Some data may be
> corrupt. Please run fsck.
>
> when booting my ia64 machine.  The message may well be legitimate
> because I did crash the machine, so the filessytem was not unmounted
> cleanly.
>
> BUT ... If I unmount and run fsck as it suggests, then I see:
>
> # fsck /boot/efi
> fsck from util-linux-ng 2.16
> dosfsck 2.11, 12 Mar 2005, FAT32, LFN
> There are differences between boot sector and its backup.
> Differences: (offset:original/backup)
>    65:01/00
> 1) Copy original to backup
> 2) Copy backup to original
> 3) No action
>
> I tried option 3 - fsck made no other changes, but I still see the
> message. I tried
> option 1 - and I still see the message. So I went for option 2 ... and
> guess what,
> I still see the message when I mount this filesystem.
>
> Note that with either option 1 or 2 "fsck" says:
>
> Leaving file system unchanged.
> /dev/sda1: 20 files, 19865/255496 clusters
>
> This is the first time I've ever seen this message ... but I haven't
> had this system crash for some time, so not really sure when this may
> have started.

Hi Tony,
i provided patches for dosfstools for some time now, you need at least 
v3.0.14. If your system do not provide it you will need to grub it here:
http://daniel-baumann.ch/gitweb/?p=software/dosfstools.git


-- 
Regards,
Oleksij
