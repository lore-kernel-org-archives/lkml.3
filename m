Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760181Ab3HOGQZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 02:16:25 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:50554 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab3HOGQX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 02:16:23 -0400
From: Caizhiyong <caizhiyong@huawei.com>
To: Brian Norris <computersforpeace@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Karel Zak <kzak@redhat.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wanglin (Albert)" <albert.wanglin@huawei.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Huang Shijie <b32955@freescale.com>
Subject: RE: [PATCH] block: add command line partition parser
Thread-Topic: [PATCH] block: add command line partition parser
Thread-Index: AQHOl+qqJeZC0CvH906unOBo+NYxZJmUzWsAgAAUuICAAKUVMP//q3WAgACI4RA=
Date: Thu, 15 Aug 2013 06:16:04 +0000
Message-ID: <C3050A4DBA34F345975765E43127F10F1C064357@szxeml512-mbx.china.huawei.com>
References: <C3050A4DBA34F345975765E43127F10F1C061D75@szxeml512-mbs.china.huawei.com>
 <20130805152206.76462cc4a42e51b16a0532f1@linux-foundation.org>
 <C3050A4DBA34F345975765E43127F10F1C06237C@szxeml512-mbs.china.huawei.com>
 <20130814155742.d3cd651e40e552696667e4f2@linux-foundation.org>
 <CAN8TOE-aGcKQNayzEVQaS1wJ_Uqp3RAZ5pTuVEhaaY9f487-xA@mail.gmail.com>
 <C3050A4DBA34F345975765E43127F10F1C063B36@szxeml512-mbx.china.huawei.com>
 <20130815050007.GA23474@brian-ubuntu>
In-Reply-To: <20130815050007.GA23474@brian-ubuntu>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.67.223.18]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Brian Norris [mailto:computersforpeace@gmail.com]
> Sent: Thursday, August 15, 2013 1:00 PM
> To: Caizhiyong
> Cc: Andrew Morton; Karel Zak; linux-mtd@lists.infradead.org;
> linux-kernel@vger.kernel.org; Wanglin (Albert); Artem Bityutskiy; Shmulik Ladkani;
> Huang Shijie
> Subject: Re: [PATCH] block: add command line partition parser
> 
> On Thu, Aug 15, 2013 at 03:38:47AM +0000, Caizhiyong wrote:
> > > -----Original Message-----
> > > From: Brian Norris [mailto:computersforpeace@gmail.com]
> > > Sent: Thursday, August 15, 2013 8:12 AM
> > > To: Andrew Morton
> > > Cc: Caizhiyong; Karel Zak; linux-mtd@lists.infradead.org;
> > > linux-kernel@vger.kernel.org; Wanglin (Albert); Artem Bityutskiy; Shmulik
> Ladkani;
> > > Huang Shijie
> > > Subject: Re: [PATCH] block: add command line partition parser
> > >
> > > On Wed, Aug 14, 2013 at 3:57 PM, Andrew Morton
> > > <akpm@linux-foundation.org> wrote:
> > > > On Tue, 13 Aug 2013 06:02:17 +0000 Caizhiyong <caizhiyong@huawei.com> wrote:
> > > >
> > > >> move the command line parser to a separate module, and change it into
> > > >> library-style code.
> > > >>
> > > >> reference: https://lkml.org/lkml/2013/8/6/550
> > >
> > > The most recent patch is an addendum to this linked patch then?
> > >
> > > > Well OK.  But to prove the library's usefulness and to generally clean
> > > > up the kernel, someone needs to sign up to the task of converting
> > > > drivers/mtd/cmdlinepart.c to use this code.
> > > >
> > > > I've been hopefully cc'ing various MTD people but am not being
> > > > overwhelmed with waves of enthusiasm ;)
> > >
> > > "I've been" implies that you have done so prior to this email. And
> > > "people" implies more than one person. I see that you CC'd David
> > > Woodhouse over a week ago, but he's fairly silent these days on MTD
> > > things. It's Artem or me who handle most of the day-to-day of MTD. And
> > > this is the first time I've seen this! (BTW, please include
> > > linux-mtd@lists.infradead.org for anything involving MTD.)
> > >
> > > This seems reasonable, and I'd be willing to work with this proposal.
> > >
> > > Caizhiyong, can you submit a clear single patch (or series of
> > > patches), CC'd to linux-mtd at least? Then we can see about supporting
> > > it in MTD. It doesn't look too difficult, but I need to check that it
> > > faithfully mimics the capability we currently rely on. There have been
> > > previous discussions on changing it, but this was rejected in favor of
> > > allowing more flexibility. Here's part of one such conversation:
> > >
> > > http://lists.infradead.org/pipermail/linux-mtd/2012-August/043599.html
> > > http://lists.infradead.org/pipermail/linux-mtd/2012-September/043825.html
> > > http://lists.infradead.org/pipermail/linux-mtd/2012-December/045322.html
> > >
> > > So I would recommend:
> > > (1) consider carefully the implications of your command-line format
> > > now, rather than later
> > > (2) if you want MTD to use it, it needs to support the features we use now
> >
> > It is fully functional reference MTD, :-).
> 
> I realize that. I just want to be clear that we have to reconcile (1)
> and (2). IOW, if block device requirements stray too far from MTD
> requirements, then we might as well drop the idea of integration now.
> But if they agree, then we can move forward.
> 
> > > Some particular cases to consider: overlapping partitions (how do
> > > block devices handle overlapping partitions?), out-of-order
> > > specification, zero sized partitions, mixed syntax (some specified
> > > with an offset, some not), multiple '-' partitions.
> >
> > I think the 'offset' just is used to hide some MTD space.
> 
> No, it specifies offset as a distance from the beginning of the flash,
> so partitions can be numbered out of order. This is intentionally
> utilized by some users, for example, to ensure that a particular
> partition is always /dev/mtd0, even if it is not the first partition
> physically.
> 
> > There are two way:
> > 1) redefine the 'offset' as a gap between forward partition and next partition.
> > 2) add code forbid command line partitions overlapping and out-of-order.
> >
> > I recommend 1), it seems to solve those problem(overlapping and out-of-order),
> but it will affect habit.
> 
> The linked discussion is where MTD settled on retaining old practice. I
> brought it up not so that we change it here, but so that you would
> understand what you are agreeing to if you adopt a common MTD and block
> device parsing infrastructure.
> 
> [Note that I am much less familiar with block device mechanics than with
> MTD.] Are any of the problem areas I mentioned actually forbidden on
> block devices? I know, for instance, that an MBR partition table can
> specify partitions out of order. And I've googled around and seen some
> posts about people (unintentionally) ending up with overlapping hard
> disk partitions.
> 
> So from my primitive knowledge, it sounds like a block devices parser
> could agree with the same principle put forward by Shmulik in that
> second URL:
> 
>  "So far, mtdparts commandline parsing has been very lenient and liberal.
>   I think we should keep this approach; give the user the flexibility,
>   he'll be responsible to provide meaningful cmdline parts for his
>   system."
> 
> Brian

I want to use the MTD command line partition method on block devices (eMMC).
It is very suitable for embedded systems. I think, in embedded system partition method,
if somebody need some feature on MTD device, he may be also need it on block device.
so I fully functional reference MTD command line partition.

I tested the out-of-order and overlapping on my system, used command line partition, It is work ok.
The block device code is not make any restrictions on partition out-of-order and overlapping.

I hope extend the flexibility to block device.

