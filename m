Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934176AbaDIXsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 19:48:17 -0400
Received: from gate.crashing.org ([63.228.1.57]:44483 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932977AbaDIXsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 19:48:16 -0400
Message-ID: <1397087273.3671.150.camel@pasglop>
Subject: Re: [BUG] kernel BUG at /.../block/cfq-iosched.c:3145!
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jens Axboe <axboe@fb.com>
Cc: Jan Kara <jack@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Brian J King <bjking1@us.ibm.com>
Date: Thu, 10 Apr 2014 09:47:53 +1000
In-Reply-To: <53454CBC.9060905@fb.com>
References: <1397018647.3671.123.camel@pasglop> <53454CBC.9060905@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-09 at 07:35 -0600, Jens Axboe wrote:
> On 04/08/2014 10:44 PM, Benjamin Herrenschmidt wrote:
> > Hi folks !
> >
> > While testing a branch of fixes before I send it to Linus, which
> > happens to be based on 18a1a7a1d862ae0794a0179473d08a414dd49234,
> > I hit this:
> >
> > kernel BUG at /home/benh/linux-powerpc-test/block/cfq-iosched.c:3145!
> > cpu 0x3c: Vector: 700 (Program Check) at [c000003ca69bb190]
> >      pc: c00000000033b05c: .cfq_dispatch_requests+0x90/0x99c
> >      lr: c00000000033b038: .cfq_dispatch_requests+0x6c/0x99c
> >      sp: c000003ca69bb410
> >     msr: 9000000000029032
> >    current = 0xc000003ca63d32a0
> >    paca    = 0xc00000000ffef000	 softe: 0	 irq_happened: 0x01
> >      pid   = 3487, comm = smartd
> > kernel BUG at /home/benh/linux-powerpc-test/block/cfq-iosched.c:3145!
> > enter ? for help
> > [c000003ca69bb4c0] c00000000032000c .elv_drain_elevator+0x70/0xc8
> > [c000003ca69bb540] c000000000320140 .__elv_add_request+0xdc/0x27c
> > [c000003ca69bb5e0] c0000000003286f8 .blk_execute_rq_nowait+0xc0/0xf8
> > [c000003ca69bb670] c0000000003287ec .blk_execute_rq+0xbc/0xe8
> > [c000003ca69bb810] c000000000332350 .sg_io+0x218/0x39c
> > [c000003ca69bb930] c000000000332c3c .scsi_cmd_ioctl+0x270/0x4ac
> > [c000003ca69bba70] c0000000005d559c .sd_ioctl+0xa4/0xd8
> > [c000003ca69bbb20] c00000000032eb1c .__blkdev_driver_ioctl+0x34/0x54
> > [c000003ca69bbb90] c00000000032f83c .blkdev_ioctl+0x7b8/0x850
> > [c000003ca69bbc40] c00000000018d6e0 .block_ioctl+0x4c/0x60
> > [c000003ca69bbcb0] c0000000001691cc .do_vfs_ioctl+0x5cc/0x670
> > [c000003ca69bbd90] c0000000001692b4 .SyS_ioctl+0x44/0x70
> > [c000003ca69bbe30] c00000000000a024 syscall_exit+0x0/0x98
> > --- Exception: c00 (System Call) at 00003fffb5240ee0
> >
> > The storage driver is our usual IBM "IPR".
> >
> > Is that a known issue ?
> 
> Nope, that's not a known issue. This must be related to the FIFO 
> changes... How reproducible is this?

Dunno yet, haven't had a chance to dig. I'll try to grab that machine
later today and reproduce &| bisect.

Cheers,
Ben.


