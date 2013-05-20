Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989Ab3ETUwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 16:52:45 -0400
Received: from ishtar.tlinx.org ([173.164.175.65]:36960 "EHLO Ishtar.hs"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756327Ab3ETUwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 16:52:44 -0400
Message-ID: <519A8D0D.7090604@tlinx.org>
Date: Mon, 20 May 2013 13:52:29 -0700
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Thunderbird
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: new mount is broken w/regard to devnames in /etc/fstab
References: <1369078758.2776.2@driftwood>
In-Reply-To: <1369078758.2776.2@driftwood>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org





Rob Landley wrote:
> On 05/19/2013 12:01:18 AM, Linda Walsh wrote:
>> 1) How is one supposed to get the real root device?
>> It's not /dev/root -- and on my system /dev/root doesn't even exist.
> There was a thread on this a couple months ago:
>   https://lkml.org/lkml/2013/3/20/315
>
> You can get the major/minor of a filesystem with the stat() system
> call, or even the stat command line utility. That gives you the
> major/minor of the device the filesystem was mounted from.
>
> Note that there's only a major/minor when the filesystem _has_ a
> backing block device. If it's initramfs or tmpfs: there isn't one. If
> it's nfs, smbfs, or v9fs: there isn't one.
----
    Indeed.

    Just that having to go through the extra stat call breaks
*scripts* that relied on previous behavior.  I mean why the kernel
can't put /dev/sdc1 in /proc/mounts instead of /dev/root when it
was specifically passed root=/dev/sdc1 on it's command line
seems a bit puzzling.

    The thing is -- while there is a /dev/root in '/proc/mounts', there
is no '/dev/root' in '/dev/ NOR is there a "root" or "rootfs" listed
in '/proc/devices'.  I.e. saying the boot occurred from /dev/root when
/dev/root doesn't exist is a bit obfuscating, at best.

    That said, it's also incredibly non-portable to have to ...
call 'stat' on '/', get back a hex device, then use the
major/minor to find the device name -- a bit more hairy
if a devmapper was involved.  While that's not my
situation, to force a shell script to scan devices in /dev/block
to find a reverse mapping seems like a huge jump in work-involved
from the previous "df <dirname>|cut..." approach.


As for the boot from ramfs, it's odd that it doesn't list
dev/ramdisk or /dev/mem as the major. 

Thanks for the archive pointer, BTW...









