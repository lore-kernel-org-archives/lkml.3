Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583Ab3HGALu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 20:11:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57544 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755125Ab3HGALt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 20:11:49 -0400
Date: Tue, 6 Aug 2013 17:10:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Caizhiyong <caizhiyong@huawei.com>
Cc: Karel Zak <kzak@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wanglin (Albert)" <albert.wanglin@huawei.com>,
        Quyaxin <quyaxin@huawei.com>, Jens Axboe <axboe@kernel.dk>,
        David Woodhouse <dwmw2@infradead.org>, Marius Groeger <mag@sysgo.de>
Subject: Re: [PATCH] block: support embedded device command line partition
Message-Id: <20130806171018.e9e315b2.akpm@linux-foundation.org>
In-Reply-To: <C3050A4DBA34F345975765E43127F10F1C061F3D@szxeml512-mbs.china.huawei.com>
References: <C3050A4DBA34F345975765E43127F10F1C061D75@szxeml512-mbs.china.huawei.com>
	<20130805152206.76462cc4a42e51b16a0532f1@linux-foundation.org>
	<C3050A4DBA34F345975765E43127F10F1C061F3D@szxeml512-mbs.china.huawei.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Aug 2013 10:53:01 +0000 Caizhiyong <caizhiyong@huawei.com> wrote:

> > -----Original Message-----
> > From: Andrew Morton [mailto:akpm@linux-foundation.org]
> > Sent: Tuesday, August 06, 2013 6:22 AM
> > To: Caizhiyong
> > Cc: Karel Zak; linux-kernel@vger.kernel.org; Wanglin (Albert); Quyaxin; Jens Axboe;
> > David Woodhouse; Marius Groeger
> > Subject: Re: [PATCH] block: support embedded device command line partition
> > 
> > On Sat, 3 Aug 2013 09:57:04 +0000 Caizhiyong <caizhiyong@huawei.com> wrote:
> > 
> > > From: Cai Zhiyong <caizhiyong@huawei.com>
> > >
> > > Read block device partition table from command line.
> > > The partition used for fixed block device (eMMC) embedded device.
> > > It is no MBR, save storage space. Bootloader can be easily accessed by
> > > absolute address of data on the block device.
> > > Users can easily change the partition.
> > >
> > > This code reference MTD partition, source "drivers/mtd/cmdlinepart.c"
> > > About the partition verbose reference
> > "Documentation/block/cmdline-partition.txt"
> > >
> > 
> > Seems OK to me.
> > 
> > The obvious question is: can we consolidate this with
> > drivers/mtd/cmdlinepart.c in some fashion so the kernel doesn't have
> > two parsers which do the same thing?
> 
> I will move the parser to "lib/cmdline.c".
> 

block/cmdline.c is an appropriate place for block-subsystem library
code.

But simply moving the file doesn't achieve anything.  To prove that the
code is indeed library-style code, we should actually *use* it in some
client code.  Such as MTD!
