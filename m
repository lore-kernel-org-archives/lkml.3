Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab3K0OmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:42:21 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:45351 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab3K0OmR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:42:17 -0500
MIME-Version: 1.0
Date: Wed, 27 Nov 2013 15:42:17 +0100
Message-ID: <CAFHacg07C6yAokWMt3KtOj174bJCsu2ebTjmApXYPK2V=3+_hg@mail.gmail.com>
Subject: mpt2sas, SMART test, Illegal request, Logical block address out of range
From: =?ISO-8859-1?B?TWlo4Wx5IMFydmEtVPN0aA==?= 
	<mihaly.arva-toth@virtual-call-center.eu>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've a SM SSG-6047R-E1R36L server with LSI2308 HBA, which handled by
mpt2sas kernel driver. I'm using four SATA HDD in server, 2 disks in
software RAID-1 with installed Ubuntu 12.04 LTS (3.8.0-29) and 2 disks
for standalone Ceph OSD storage.

When I run SMART short/extended test on one of first two disk (which
holds system), I think driver sends something wrong to controller. I
can reproduce every time with smartctl -t short /dev/sda (but I need
to do restart after crash)

2013-10-18T02:11:56+02:00 stor2 kernel: : [34198.503083] sd 0:0:1:0: [sdb]
2013-10-18T02:11:56+02:00 stor2 kernel: : [34198.503087] Result:
hostbyte=DID_OK driverbyte=DRIVER_SENSE
2013-10-18T02:11:56+02:00 stor2 kernel: : [34198.503089] sd 0:0:1:0: [sdb]
2013-10-18T02:11:56+02:00 stor2 kernel: : [34198.503091] Sense Key :
Illegal Request [current]
2013-10-18T02:11:56+02:00 stor2 kernel: : [34198.503095] Info fld=0x104c668
2013-10-18T02:11:56+02:00 stor2 kernel: : [34198.503096] sd 0:0:1:0: [sdb]
2013-10-18T02:11:56+02:00 stor2 kernel: : [34198.503099] Add. Sense:
Logical block address out of range
2013-10-18T02:11:56+02:00 stor2 kernel: : [34198.503101] sd 0:0:1:0: [sdb] CDB:
2013-10-18T02:11:56+02:00 stor2 kernel: : [34198.503103] Write(10): 2a
08 01 04 c6 68 00 00 08 00
2013-10-18T02:11:56+02:00 stor2 kernel: : [34198.503110] end_request:
critical target error, dev sdb, sector 17090152
2013-10-18T02:11:56+02:00 stor2 kernel: : [34198.503498] end_request:
critical target error, dev sdb, sector 17090152
2013-10-18T02:11:56+02:00 stor2 kernel: : [34198.503947] Aborting
journal on device md0-8.
2013-10-18T02:11:56+02:00 stor2 kernel: : [34198.504417] journal
commit I/O error
2013-10-18T02:11:56+02:00 stor2 kernel: : [34198.522733] EXT4-fs error
(device md0): ext4_journal_start_sb:349: Detected aborted journal
2013-10-18T02:11:56+02:00 stor2 kernel: : [34198.523245] EXT4-fs
(md0): Remounting filesystem read-only

I tried rootfs with ext4 and xfs filesystems too. When I run SMART
test on 3rd or 4th HDD (not system disk), there is no crash and tests
working fine. When I boot from a live CD, I can run SMART tests on all
HDDs without problem. I tried to install and booted latest stable
FreeBSD and SMART tests working well, no hang up.

I tired the latest LSI firmware P17 and latest mpt2sas kernel driver
compiled to this kernel, but problem still exists.

I found an another guy who runs same issue:

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/906873/comments/4

So the bug exists in linux kernel only, and crash happens only when I
try to run SMART tests on booted system's disks. I tried to contact
with LSI support who sent to SuperMicro because SM built this HBA card
based on LSI chip. SM support can't help me, don't understand my
problem.

LKML my last hope to solve this issue.

Please send answer/comments also me Cc.

Thank you,

-- 
Best regards,
Mihály Árva-Tóth
System Engineer
