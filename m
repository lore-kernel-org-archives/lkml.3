Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbaC2XaI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 19:30:08 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:31281 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbaC2XaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 19:30:06 -0400
Date: Sun, 30 Mar 2014 02:29:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: =?iso-8859-1?B?Suly9G1l?= Pinot <ngc891@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Chris Kelly <ckelly@ozmodevices.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] staging/ozwpan: coding style ether_addr_copy
Message-ID: <20140329232952.GF19296@mwanda>
References: <20140312100132.GA18954@star>
 <20140312144533.GA3410@kroah.com>
 <20140313012144.GD30138@star>
 <20140313022821.GA9084@kroah.com>
 <20140313153911.GA17881@star>
 <20140328111801.GD6991@mwanda>
 <1396012107.31134.21.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1396012107.31134.21.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 06:08:27AM -0700, Joe Perches wrote:
> (adding Andrew Morton, David Miller and LKML to cc's)
> 
> On Fri, 2014-03-28 at 14:18 +0300, Dan Carpenter wrote:
> > On Fri, Mar 14, 2014 at 12:39:11AM +0900, Jérôme Pinot wrote:
> > > On 03/13/14 02:28, Greg Kroah-Hartman wrote:
> > > > On Thu, Mar 13, 2014 at 10:21:44AM +0900, Jérôme Pinot wrote:
> > > [...]
> > > > > diff --git a/drivers/staging/ozwpan/ozcdev.c b/drivers/staging/ozwpan/ozcdev.c
> > > > > index 5de5981..10c0a96 100644
> > > > > --- a/drivers/staging/ozwpan/ozcdev.c
> > > > > +++ b/drivers/staging/ozwpan/ozcdev.c
> > > > > @@ -217,7 +217,7 @@ static int oz_set_active_pd(const u8 *addr)
> > > > >  	pd = oz_pd_find(addr);
> > > > >  	if (pd) {
> > > > >  		spin_lock_bh(&g_cdev.lock);
> > > > > -		memcpy(g_cdev.active_addr, addr, ETH_ALEN);
> > > > > +		ether_addr_copy(g_cdev.active_addr, addr);
> > > > 
> > > > Are you sure this will work?
> > > 
> > > No. But the ozwpan driver uses already ether_addr_equal which is not
> > > alignment-safe. As
> > > https://www.kernel.org/doc/Documentation/unaligned-memory-access.txt 
> > > said:
> > > 
> > > "This alignment-unsafe function is still useful as it is a decent
> > > optimization for the cases when you can ensure alignment, which is
> > > true almost all of the time in ethernet networking context."
> > > 
> > > I expected the maintainer to confirm/infirm this. I'm just seeing that's
> > > actually Chris Kelly who did write this part of code, so I'm CC'ing him
> > > too.
> > > 
> > 
> > It is aligned ok, but don't rely on the maintainer to fix your bugs.
> > Don't send patches which you are not sure about.
> > 
> > Joe, this seems like a very bad warning message from checkpatch.pl
> > because people will constantly send us patches over and over which
> > introduce bugs and they rely on the maintainer to catch it every time.
> > Can we get rid of the warning or move it under --strict or something?
> 
> Hi Dan.
> 
> Maybe.
> 
> The checkpatch message is:
> 
> "Prefer ether_addr_copy() over memcpy() if the Ethernet addresses are __aligned(2)"
> 
> My personal preference would be to add YA inline function
> for unaligned copies ether_addr_copy_unaligned for symmetry
> to ether_addr_equal_unaligned to etherdevice.h though.
> 
> Then the message could be changed to something like
> "Prefer ether_addr_copy[_unaligned] to memcpy(foo, bar, ETH_ALEN)"
> 

Sure if we had a function which didn't introduce bugs then that would be
great.  As it is submitters ignore the alignment requirements and rely
on us to catch bugs.

In Smatch, I constantly explain to people that I don't care about false
positives because this is not GCC where you have to eliminate every
warning.  These days in the kernel we treat checkpatch.pl and GCC
warnings the same so it sucks when they are something conditional.

regards,
dan carpenter

