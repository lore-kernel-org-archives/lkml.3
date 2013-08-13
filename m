Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477Ab3HMEd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 00:33:57 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:54179 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3HMEd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 00:33:56 -0400
X-AuditID: 9c93017e-b7c76ae000003897-7a-5209b7326165
Date: Tue, 13 Aug 2013 13:33:58 +0900
From: Minchan Kim <minchan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Thomas Backlund <tmb@mageia.org>, Jordi Pujol <jordipujolp@gmail.com>,
        stable@vger.kernel.org, Jiang Liu <jiang.liu@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: ZRAM 3.10.6 Buffer I/O error
Message-ID: <20130813043358.GD3101@bbox>
References: <1998314.O9XRMyhM6u@pcjordi>
 <52090FD2.9030702@mageia.org>
 <20130813013900.GC3101@bbox>
 <20130813035802.GA24637@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130813035802.GA24637@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,

On Mon, Aug 12, 2013 at 08:58:02PM -0700, Greg Kroah-Hartman wrote:
> On Tue, Aug 13, 2013 at 10:39:00AM +0900, Minchan Kim wrote:
> > Hello,
> > 
> > On Mon, Aug 12, 2013 at 07:39:46PM +0300, Thomas Backlund wrote:
> > > 12.08.2013 17:27, Jordi Pujol skrev:
> > > >Hello,
> > > >
> > > >zram shows an error when mounting a swap partition,
> > > >current version Linux kernel 3.10.6,
> > > >previous versions worked, I suppose that latest zram patches have some
> > > >problem,
> > > >
> > > >machine is an AMD64 dual core, 4GB RAM
> > > >
> > > >+ modprobe -qb zram num_devices=2
> > > >+ echo 104857600 > /sys/block/zram0/disksize
> > > >
> > > ># mkswap /dev/zram0
> > > >Setting up swapspace version 1, size = 102396 KiB
> > > >no label, UUID=6c249930-2ba0-46cf-a8c6-766481942b7d
> > > >
> > > ># pager /var/log/dmesg
> > > >(no more errors shown)
> > > >
> > > ># swapon /dev/zram0
> > > >
> > > ># pager /var/log/dmesg
> > > >...
> > > >[  309.300479] Buffer I/O error on device zram0, logical block 25599
> > > >[  309.300491] Buffer I/O error on device zram0, logical block 25599
> > > >[  309.300514] Buffer I/O error on device zram0, logical block 25599
> > > >[  345.205887] Adding 102396k swap on /dev/zram0.  Priority:-2 extents:1
> > > >across:102396k SSFS
> > > >
> > > >full log files and the kernel source are stored in the address:
> > > >
> > > >http://livenet.selfip.com/ftp/debian/zram_3.10.6_IO_error/
> > > >
> > > 
> > > 
> > > I think this one should fix it and belongs in 3.10 stable too:
> > 
> > Very true. Let's Cc Greg, explicitely.
> 
> -ENOCONTEXT

https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/drivers/staging/zram?id=75c7caf5a052ffd8db3312fa7864ee2d142890c4

It seems you already merge "zram:allow request end to conincide with disksize" to stable.
So there is no concern any more.

Thanks.


-- 
Kind regards,
Minchan Kim
