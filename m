Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330AbaDERY0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 13:24:26 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:62333 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbaDERYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 13:24:24 -0400
X-Nat-Received: from [202.181.97.72]:53603 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1396718617.19278
To: thomas@archlinux.org, ak@linux.intel.com
Cc: viro@ZenIV.linux.org.uk, geert@linux-m68k.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        tpowa@archlinux.org
Subject: Re: 3.13: <module> disagrees about version of symbol <symbol>
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <5339F739.2060207@archlinux.org>
	<20140331233450.GI32556@tassilo.jf.intel.com>
	<5339FC62.8060207@archlinux.org>
	<20140405011332.GR32556@tassilo.jf.intel.com>
	<5340134B.4010705@archlinux.org>
In-Reply-To: <5340134B.4010705@archlinux.org>
Message-Id: <201404060223.FJI17489.LFMOVtOSFQFOHJ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 6 Apr 2014 02:23:32 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 05042014 #7774726, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas B臘hler wrote:
> >> For convenience, here is a copy-and-paste of the full text:
> > 
> > I did some experiments know and I can't find any 32bit modules 
> > that do not load with 32bit MODVERSIONS on or off with 
> > a current tree.
> > 
> > Do you have a specific config?
> > Specific compiler version?
> 
> Using gcc 4.8 from Arch Linux with the configuration at [1] and Linux 3.14.
> 
> [1]
> https://projects.archlinux.org/svntogit/packages.git/tree/trunk/config?h=packages/linux
> 

I installed ArchLinux i686 and compiled
https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.14.tar.xz using [1]
as of commit bbf3d68a without any changes.

It seems to me that everything is working well.
Which modules you cannot load?

[root@localhost ~]# ls -lrt /boot/*3.14.0-ARCH*
-rw-r--r-- 1 root root 3619792 Apr  6 10:44 /boot/vmlinuz-3.14.0-ARCH
-rw-r--r-- 1 root root 3076964 Apr  6 11:08 /boot/initramfs-3.14.0-ARCH.img
[root@localhost ~]# cat /proc/version
Linux version 3.14.0-ARCH (root@localhost) (gcc version 4.8.2 20140206 (prerelease) (GCC) ) #3 SMP PREEMPT Sun Apr 6 10:28:24 JST 2014
[root@localhost ~]# lsmod | grep ext4
ext4                  434862  1
crc16                   1091  1 ext4
mbcache                 4458  1 ext4
jbd2                   70413  1 ext4
