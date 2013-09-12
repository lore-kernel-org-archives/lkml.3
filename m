Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab3ILQnB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 12:43:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55918 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab3ILQnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 12:43:00 -0400
Date: Thu, 12 Sep 2013 09:42:58 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Cc: Minchan Kim <minchan@kernel.org>,
        Michael wang <wangyun@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchand@redhat.com>, devel@driverdev.osuosl.org
Subject: Re: BUG: scheduling while atomic 3.10.7 in ZRAM Swap
Message-ID: <20130912164258.GC11614@kroah.com>
References: <CAKcLGm8EMruO5e8yw+nArTjyCGSvLB5pjnGZYvz0xdF9M99iwQ@mail.gmail.com>
 <52119B4E.4060409@linux.vnet.ibm.com>
 <20130819044444.GD26832@bbox>
 <CAKcLGm-wJjBeSczCi7-XkyDMd444HoQcFVfmpkPYZ2WcExCxaA@mail.gmail.com>
 <CAKcLGm_NrnK8yCfsBWoT0mBC+kyG3kgVt61ORfazbWaRBDya7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKcLGm_NrnK8yCfsBWoT0mBC+kyG3kgVt61ORfazbWaRBDya7A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 06:08:08PM -0500, Mitch Harder wrote:
> On Tue, Aug 20, 2013 at 9:51 AM, Mitch Harder
> <mitch.harder@sabayonlinux.org> wrote:
> > On Sun, Aug 18, 2013 at 11:44 PM, Minchan Kim <minchan@kernel.org> wrote:
> >> Hello,
> >>
> >> On Mon, Aug 19, 2013 at 12:13:02PM +0800, Michael wang wrote:
> >>> Hi, Mitch
> >>>
> >>> On 08/17/2013 10:01 PM, Mitch Harder wrote:
> >>> > I'm encountering a BUG while using a ZRAM Swap device.
> >>> >
> >>> > The call trace seems to involve the changes recently added to 3.10.6
> >>> > by the patch:
> >>> > zram: use zram->lock to protect zram_free_page() in swap free notify path
> >>> >
> >>> > The hardware is a x86 single CPU AMD Athlon XP system with 1GB RAM.
> >>> >
> >>> > I'm implementing a 352MB ZRAM swap device, and also have 1GB swap
> >>> > space on the hard disk.
> >>>
> >>> IMHO, it was caused by that swap_entry_free() was invoked with page
> >>> spin-locked, thus zram_slot_free_notify() should not use rw-lock which
> >>> may goto sleep.
> >>>
> >>> CC folks related.
> >>
> >> Thanks for Ccing me, Michael,
> >>
> >> Mitch, It's known problem and it should be fixed by [1] in recent linux-next.
> >>
> >> [1] a0c516cbfc, zram: don't grab mutex in zram_slot_free_noity
> >>
> >> Thanks for the report!
> >>
> >
> > Thanks.
> >
> > If I apply the zram patches from linux-next, the problem seems to be resolved.
> 
> Is it planned to send the patch: "zram: don't grab mutex in
> zram_slot_free_noity"  to stable?
> 
> I noticed that 3.10.11 still doesn't have this patch.

That's because it isn't in a released kernel from Linus yet.  Wait for
3.12-rc1 to come out, then I will queue it up.

thanks,

greg k-h
