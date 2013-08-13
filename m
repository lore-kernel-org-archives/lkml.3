Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab3HMFqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 01:46:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60075 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab3HMFqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 01:46:14 -0400
Date: Mon, 12 Aug 2013 22:47:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Thomas Backlund <tmb@mageia.org>
Cc: Jordi Pujol <jordipujolp@gmail.com>, stable@vger.kernel.org,
        Jiang Liu <jiang.liu@huawei.com>, linux-kernel@vger.kernel.org
Subject: Re: ZRAM 3.10.6 Buffer I/O error
Message-ID: <20130813054740.GA22700@kroah.com>
References: <1998314.O9XRMyhM6u@pcjordi>
 <52090FD2.9030702@mageia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52090FD2.9030702@mageia.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 07:39:46PM +0300, Thomas Backlund wrote:
> 12.08.2013 17:27, Jordi Pujol skrev:
> > Hello,
> >
> > zram shows an error when mounting a swap partition,
> > current version Linux kernel 3.10.6,
> > previous versions worked, I suppose that latest zram patches have some
> > problem,
> >
> > machine is an AMD64 dual core, 4GB RAM
> >
> > + modprobe -qb zram num_devices=2
> > + echo 104857600 > /sys/block/zram0/disksize
> >
> > # mkswap /dev/zram0
> > Setting up swapspace version 1, size = 102396 KiB
> > no label, UUID=6c249930-2ba0-46cf-a8c6-766481942b7d
> >
> > # pager /var/log/dmesg
> > (no more errors shown)
> >
> > # swapon /dev/zram0
> >
> > # pager /var/log/dmesg
> > ...
> > [  309.300479] Buffer I/O error on device zram0, logical block 25599
> > [  309.300491] Buffer I/O error on device zram0, logical block 25599
> > [  309.300514] Buffer I/O error on device zram0, logical block 25599
> > [  345.205887] Adding 102396k swap on /dev/zram0.  Priority:-2 extents:1
> > across:102396k SSFS
> >
> > full log files and the kernel source are stored in the address:
> >
> > http://livenet.selfip.com/ftp/debian/zram_3.10.6_IO_error/
> >
> 
> 
> I think this one should fix it and belongs in 3.10 stable too:
> 
>  From 75c7caf5a052ffd8db3312fa7864ee2d142890c4 Mon Sep 17 00:00:00 2001
> From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Date: Sat, 22 Jun 2013 14:21:00 +0000
> Subject: zram: allow request end to coincide with disksize

Now applied, thanks.

greg k-h
