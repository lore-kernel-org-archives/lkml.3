Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab3FDE5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 00:57:14 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:44962 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab3FDE5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 00:57:11 -0400
Date: Tue, 4 Jun 2013 00:57:07 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, stable@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Message-ID: <1898240904.11078354.1370321827838.JavaMail.root@redhat.com>
In-Reply-To: <20130604041617.GF29466@dastard>
References: <510292845.4997401.1369279175460.JavaMail.root@redhat.com> <1824023060.8558101.1369892432333.JavaMail.root@redhat.com> <1462663454.9294499.1369969415681.JavaMail.root@redhat.com> <20130531060415.GU29466@dastard> <1517224799.10311874.1370228651422.JavaMail.root@redhat.com> <20130603040038.GX29466@dastard> <1317567060.11044929.1370315696270.JavaMail.root@redhat.com> <20130604041617.GF29466@dastard>
Subject: Re: 3.9.4 Oops running xfstests (WAS Re: 3.9.3: Oops running
 xfstests)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.11]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF20 (Linux)/8.0.3_GA_5664)
Thread-Topic: 3.9.4 Oops running xfstests (WAS Re: 3.9.3: Oops running xfstests)
Thread-Index: CN9cdo5uV+/9SY2joJxoC4vi21Vlxw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Cai, I did ask you for the information that would have answered this
> question:
> 
> > > 	3. if you can't reproduce it like that, does it reproduce on
> > > 	  an xfstest run on a pristine system? If so, what command
> > > 	  line are you running, and what are the filesystem
> > > 	  configurations?
> 
> So, I need xfstests command line and the xfs_info output from the
> filesystems in use at the time this problem occurs..
Here you are.
[root@hp-z210-01 xfstests-dev]# a=`grep ' swap' /etc/fstab | cut -f 1 -d ' '`
[root@hp-z210-01 xfstests-dev]# b=`grep ' /home' /etc/fstab | cut -f 1 -d ' '`
[root@hp-z210-01 xfstests-dev]# swapoff -a
[root@hp-z210-01 xfstests-dev]# umount /home
[root@hp-z210-01 xfstests-dev]# echo "swap = $a"
swap = /dev/mapper/rhel_hp--z210--01-swap
[root@hp-z210-01 xfstests-dev]# echo "home = $b"
home = /dev/mapper/rhel_hp--z210--01-home
[root@hp-z210-01 xfstests-dev]# export TEST_DEV=$a
[root@hp-z210-01 xfstests-dev]# export TEST_DIR=/mnt/testarea/test
[root@hp-z210-01 xfstests-dev]# export SCRATCH_DEV=$b
[root@hp-z210-01 xfstests-dev]# export SCRATCH_MNT=/mnt/testarea/scratch
[root@hp-z210-01 xfstests-dev]# mkdir -p /mnt/testarea/test
[root@hp-z210-01 xfstests-dev]# mkdir -p /mnt/testarea/scratch
[root@hp-z210-01 xfstests-dev]# 
[root@hp-z210-01 xfstests-dev]# mkfs.xfs -f $a
meta-data=/dev/mapper/rhel_hp--z210--01-swap isize=256    agcount=4, agsize=251904 blks
         =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=1007616, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
[root@hp-z210-01 xfstests-dev]# mkfs.xfs -f $b
meta-data=/dev/mapper/rhel_hp--z210--01-home isize=256    agcount=4, agsize=11701504 blks
         =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=46806016, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=22854, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

[root@hp-z210-01 xfstests-dev]# 
[root@hp-z210-01 xfstests-dev]# mount /dev/mapper/rhel_hp--z210--01-home /mnt/testarea/scratch
[root@hp-z210-01 xfstests-dev]# 
[root@hp-z210-01 xfstests-dev]# mount /dev/mapper/rhel_hp--z210--01-swap /mnt/testarea/test
[root@hp-z210-01 xfstests-dev]# xfs_info $a
meta-data=/dev/mapper/rhel_hp--z210--01-swap isize=256    agcount=4, agsize=251904 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=1007616, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
[root@hp-z210-01 xfstests-dev]# xfs_info $b
meta-data=/dev/mapper/rhel_hp--z210--01-home isize=256    agcount=4, agsize=11701504 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=46806016, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=22854, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
[root@hp-z210-01 xfstests-dev]# ./check 20
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 hp-z210-01 3.9.4
MKFS_OPTIONS  -- -f -bsize=4096 /dev/mapper/rhel_hp--z210--01-home
MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/mapper/rhel_hp--z210--01-home /mnt/testarea/scratch
020	<crashed immediately...>
CAI Qian
