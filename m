Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbaC1NIj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 09:08:39 -0400
Received: from smtprelay0037.hostedemail.com ([216.40.44.37]:48621 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751664AbaC1NIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 09:08:38 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 57,3.5,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2525:2553:2560:2563:2682:2685:2693:2828:2859:2901:2903:2909:2917:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3354:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:5007:6117:6119:7652:8527:9010:9025:10013:10400:10848:11026:11232:11658:11914:12043:12438:12517:12519:12555:12663:12740:13071:13095:13160:13161:13229:13894:21060,0,RBL:none,CacheI
X-HE-Tag: crate92_ff00bce25850
X-Filterd-Recvd-Size: 3759
Message-ID: <1396012107.31134.21.camel@joe-AO722>
Subject: Re: [PATCH 3/3] staging/ozwpan: coding style ether_addr_copy
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: =?ISO-8859-1?Q?J=E9r=F4me?= Pinot <ngc891@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Chris Kelly <ckelly@ozmodevices.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 28 Mar 2014 06:08:27 -0700
In-Reply-To: <20140328111801.GD6991@mwanda>
References: <20140312100132.GA18954@star> <20140312144533.GA3410@kroah.com>
	 <20140313012144.GD30138@star> <20140313022821.GA9084@kroah.com>
	 <20140313153911.GA17881@star> <20140328111801.GD6991@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding Andrew Morton, David Miller and LKML to cc's)

On Fri, 2014-03-28 at 14:18 +0300, Dan Carpenter wrote:
> On Fri, Mar 14, 2014 at 12:39:11AM +0900, Jérôme Pinot wrote:
> > On 03/13/14 02:28, Greg Kroah-Hartman wrote:
> > > On Thu, Mar 13, 2014 at 10:21:44AM +0900, Jérôme Pinot wrote:
> > [...]
> > > > diff --git a/drivers/staging/ozwpan/ozcdev.c b/drivers/staging/ozwpan/ozcdev.c
> > > > index 5de5981..10c0a96 100644
> > > > --- a/drivers/staging/ozwpan/ozcdev.c
> > > > +++ b/drivers/staging/ozwpan/ozcdev.c
> > > > @@ -217,7 +217,7 @@ static int oz_set_active_pd(const u8 *addr)
> > > >  	pd = oz_pd_find(addr);
> > > >  	if (pd) {
> > > >  		spin_lock_bh(&g_cdev.lock);
> > > > -		memcpy(g_cdev.active_addr, addr, ETH_ALEN);
> > > > +		ether_addr_copy(g_cdev.active_addr, addr);
> > > 
> > > Are you sure this will work?
> > 
> > No. But the ozwpan driver uses already ether_addr_equal which is not
> > alignment-safe. As
> > https://www.kernel.org/doc/Documentation/unaligned-memory-access.txt 
> > said:
> > 
> > "This alignment-unsafe function is still useful as it is a decent
> > optimization for the cases when you can ensure alignment, which is
> > true almost all of the time in ethernet networking context."
> > 
> > I expected the maintainer to confirm/infirm this. I'm just seeing that's
> > actually Chris Kelly who did write this part of code, so I'm CC'ing him
> > too.
> > 
> 
> It is aligned ok, but don't rely on the maintainer to fix your bugs.
> Don't send patches which you are not sure about.
> 
> Joe, this seems like a very bad warning message from checkpatch.pl
> because people will constantly send us patches over and over which
> introduce bugs and they rely on the maintainer to catch it every time.
> Can we get rid of the warning or move it under --strict or something?

Hi Dan.

Maybe.

The checkpatch message is:

"Prefer ether_addr_copy() over memcpy() if the Ethernet addresses are __aligned(2)"

My personal preference would be to add YA inline function
for unaligned copies ether_addr_copy_unaligned for symmetry
to ether_addr_equal_unaligned to etherdevice.h though.

Then the message could be changed to something like
"Prefer ether_addr_copy[_unaligned] to memcpy(foo, bar, ETH_ALEN)"

> Do we have a mailing list yet for checkpatch issues?

No and I'm not going to advocate for one. I think the
subscriber count would be about 4 people total.

You could add yourself to the checkpatch MAINTAINERS entry
if you want to see more of the patches and discussions.

They are pretty rare.

