Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab3HMFS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 01:18:29 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:61743 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658Ab3HMFS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 01:18:27 -0400
X-AuditID: 9c93016f-b7cf0ae00000518f-71-5209c1a17407
Date: Tue, 13 Aug 2013 14:18:29 +0900
From: Minchan Kim <minchan@kernel.org>
To: Thomas Backlund <tmb@mageia.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jordi Pujol <jordipujolp@gmail.com>, stable@vger.kernel.org,
        Jiang Liu <jiang.liu@huawei.com>, linux-kernel@vger.kernel.org
Subject: Re: ZRAM 3.10.6 Buffer I/O error
Message-ID: <20130813051829.GE3101@bbox>
References: <1998314.O9XRMyhM6u@pcjordi>
 <52090FD2.9030702@mageia.org>
 <20130813013900.GC3101@bbox>
 <20130813035802.GA24637@kroah.com>
 <20130813043358.GD3101@bbox>
 <5209BD97.6000605@mageia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5209BD97.6000605@mageia.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 08:01:11AM +0300, Thomas Backlund wrote:
> Minchan Kim skrev 13.8.2013 07:33:
> >Hello Greg,
> >
> >On Mon, Aug 12, 2013 at 08:58:02PM -0700, Greg Kroah-Hartman wrote:
> >>On Tue, Aug 13, 2013 at 10:39:00AM +0900, Minchan Kim wrote:
> >>>Hello,
> >>>
> >>>On Mon, Aug 12, 2013 at 07:39:46PM +0300, Thomas Backlund wrote:
> >>>>12.08.2013 17:27, Jordi Pujol skrev:
> >>>>>Hello,
> >>>>>
> >>>>>zram shows an error when mounting a swap partition,
> >>>>>current version Linux kernel 3.10.6,
> >>>>>previous versions worked, I suppose that latest zram patches have some
> >>>>>problem,
> >>>>>
> >>>>>machine is an AMD64 dual core, 4GB RAM
> >>>>>
> >>>>>+ modprobe -qb zram num_devices=2
> >>>>>+ echo 104857600 > /sys/block/zram0/disksize
> >>>>>
> >>>>># mkswap /dev/zram0
> >>>>>Setting up swapspace version 1, size = 102396 KiB
> >>>>>no label, UUID=6c249930-2ba0-46cf-a8c6-766481942b7d
> >>>>>
> >>>>># pager /var/log/dmesg
> >>>>>(no more errors shown)
> >>>>>
> >>>>># swapon /dev/zram0
> >>>>>
> >>>>># pager /var/log/dmesg
> >>>>>...
> >>>>>[  309.300479] Buffer I/O error on device zram0, logical block 25599
> >>>>>[  309.300491] Buffer I/O error on device zram0, logical block 25599
> >>>>>[  309.300514] Buffer I/O error on device zram0, logical block 25599
> >>>>>[  345.205887] Adding 102396k swap on /dev/zram0.  Priority:-2 extents:1
> >>>>>across:102396k SSFS
> >>>>>
> >>>>>full log files and the kernel source are stored in the address:
> >>>>>
> >>>>>http://livenet.selfip.com/ftp/debian/zram_3.10.6_IO_error/
> >>>>>
> >>>>
> >>>>
> >>>>I think this one should fix it and belongs in 3.10 stable too:
> >>>
> >>>Very true. Let's Cc Greg, explicitely.
> >>
> >>-ENOCONTEXT
> >
> >https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/drivers/staging/zram?id=75c7caf5a052ffd8db3312fa7864ee2d142890c4
> >
> >It seems you already merge "zram:allow request end to conincide with disksize" to stable.
> >So there is no concern any more.
> 
> Nope...
> 
> thats master branch wich tracks upstream tree...
> 
> it's not in the 3.10 stable as of 3.10.6 (or current stable queue)
> 
> https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/log/drivers/staging/zram?h=linux-3.10.y

Okay, Then, we should explain it to Greg.

While Jiang was fixing a BUG A with [1], [1] made another BUG B.
So, Sergey fixed BUG B with [2]. But unfortunately, [1] was in stable
now but [2] wasn't so [2] should go to the stable to fix BUG B.

[1] 12a7ad3b8, zram: avoid access beyond the zram device
[2] 75c7caf5a, zram: allow request end to coincide with disksize

> 
> --
> 
> Thomas
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Kind regards,
Minchan Kim
