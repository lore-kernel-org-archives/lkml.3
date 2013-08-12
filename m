Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab3HLO17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 10:27:59 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:63752 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab3HLO15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 10:27:57 -0400
From: Jordi Pujol <jordipujolp@gmail.com>
To: Jiang Liu <jiang.liu@huawei.com>, linux-kernel@vger.kernel.org
Subject: ZRAM 3.10.6 Buffer I/O error
Date: Mon, 12 Aug 2013 16:27:51 +0200
Message-ID: <1998314.O9XRMyhM6u@pcjordi>
User-Agent: KMail/4.10.5 (Linux/3.10.6-1-lnet-amd64; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

zram shows an error when mounting a swap partition,
current version Linux kernel 3.10.6,
previous versions worked, I suppose that latest zram patches have some 
problem,

machine is an AMD64 dual core, 4GB RAM

+ modprobe -qb zram num_devices=2
+ echo 104857600 > /sys/block/zram0/disksize

# mkswap /dev/zram0
Setting up swapspace version 1, size = 102396 KiB
no label, UUID=6c249930-2ba0-46cf-a8c6-766481942b7d

# pager /var/log/dmesg 
(no more errors shown)

# swapon /dev/zram0

# pager /var/log/dmesg 
...
[  309.300479] Buffer I/O error on device zram0, logical block 25599
[  309.300491] Buffer I/O error on device zram0, logical block 25599
[  309.300514] Buffer I/O error on device zram0, logical block 25599
[  345.205887] Adding 102396k swap on /dev/zram0.  Priority:-2 extents:1 
across:102396k SSFS

full log files and the kernel source are stored in the address:

http://livenet.selfip.com/ftp/debian/zram_3.10.6_IO_error/

Kind regards,

Jordi Pujol

Live never ending Tale
GNU/Linux Live forever!
http://livenet.selfip.com

