Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750846Ab3HSEoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 00:44:24 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:46258 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab3HSEoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 00:44:21 -0400
X-AuditID: 9c93017d-b7cdfae0000026c0-51-5211a2a42b72
Date: Mon, 19 Aug 2013 13:44:44 +0900
From: Minchan Kim <minchan@kernel.org>
To: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchand@redhat.com>, devel@driverdev.osuosl.org
Subject: Re: BUG: scheduling while atomic 3.10.7 in ZRAM Swap
Message-ID: <20130819044444.GD26832@bbox>
References: <CAKcLGm8EMruO5e8yw+nArTjyCGSvLB5pjnGZYvz0xdF9M99iwQ@mail.gmail.com>
 <52119B4E.4060409@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52119B4E.4060409@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Aug 19, 2013 at 12:13:02PM +0800, Michael wang wrote:
> Hi, Mitch
> 
> On 08/17/2013 10:01 PM, Mitch Harder wrote:
> > I'm encountering a BUG while using a ZRAM Swap device.
> > 
> > The call trace seems to involve the changes recently added to 3.10.6
> > by the patch:
> > zram: use zram->lock to protect zram_free_page() in swap free notify path
> > 
> > The hardware is a x86 single CPU AMD Athlon XP system with 1GB RAM.
> > 
> > I'm implementing a 352MB ZRAM swap device, and also have 1GB swap
> > space on the hard disk.
> 
> IMHO, it was caused by that swap_entry_free() was invoked with page
> spin-locked, thus zram_slot_free_notify() should not use rw-lock which
> may goto sleep.
> 
> CC folks related.

Thanks for Ccing me, Michael,

Mitch, It's known problem and it should be fixed by [1] in recent linux-next.

[1] a0c516cbfc, zram: don't grab mutex in zram_slot_free_noity

Thanks for the report!

> 
> Regards,
> Michael Wang
-- 
Kind regards,
Minchan Kim
