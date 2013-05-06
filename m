Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab3EFSgk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 14:36:40 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:62912 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab3EFSgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 14:36:39 -0400
MIME-Version: 1.0
Date: Mon, 6 May 2013 11:36:38 -0700
Message-ID: <CA+8MBb++1CVLAo3zw4fx2O7akWsZcvybRyZpt0ac0sX7M=u5Xw@mail.gmail.com>
Subject: VFAT complains that my file system may be corrupted
From: Tony Luck <tony.luck@gmail.com>
To: Oleksij Rempel <bug-track@fisher-privat.net>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Built Linus' tree this morning (HEAD =
d7ab7302f970a254997687a1cdede421a5635c68) and got this message:

FAT-fs (sda1): Volume was not properly unmounted. Some data may be
corrupt. Please run fsck.

when booting my ia64 machine.  The message may well be legitimate
because I did crash the machine, so the filessytem was not unmounted
cleanly.

BUT ... If I unmount and run fsck as it suggests, then I see:

# fsck /boot/efi
fsck from util-linux-ng 2.16
dosfsck 2.11, 12 Mar 2005, FAT32, LFN
There are differences between boot sector and its backup.
Differences: (offset:original/backup)
  65:01/00
1) Copy original to backup
2) Copy backup to original
3) No action

I tried option 3 - fsck made no other changes, but I still see the
message. I tried
option 1 - and I still see the message. So I went for option 2 ... and
guess what,
I still see the message when I mount this filesystem.

Note that with either option 1 or 2 "fsck" says:

Leaving file system unchanged.
/dev/sda1: 20 files, 19865/255496 clusters

This is the first time I've ever seen this message ... but I haven't
had this system crash for some time, so not really sure when this may
have started.

-Tony
