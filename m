Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbaFPIOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 04:14:11 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:29361 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426AbaFPIOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 04:14:09 -0400
Date: Mon, 16 Jun 2014 11:13:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Benedict Boerger <benedict.boerger@cs.tu-dortmund.de>,
        matlackdavid@gmail.com, devel@driverdev.osuosl.org,
        peter.p.waskiewicz.jr@intel.com, linux-kernel@vger.kernel.org,
        liodot@gmail.com, charrer@alacritech.com,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH] staging: slicoss: Fix coding style issue
Message-ID: <20140616081350.GC5500@mwanda>
References: <1402674753-3466-1-git-send-email-benedict.boerger@cs.tu-dortmund.de>
 <20140613170435.GA18608@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140613170435.GA18608@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 10:04:35AM -0700, Greg KH wrote:
> On Fri, Jun 13, 2014 at 05:52:33PM +0200, Benedict Boerger wrote:
> > Fix a coding style issue found by checkpatch.pl.
> > Use ether_addr_copy instead of memcpy.
> > 
> > Done to complete a eudyptula task.
> > 
> > Signed-off-by: Benedict Boerger <benedict.boerger@cs.tu-dortmund.de>
> > 
> > ---
> >  drivers/staging/slicoss/slicoss.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
> > index 48841e7..02807a3 100644
> > --- a/drivers/staging/slicoss/slicoss.c
> > +++ b/drivers/staging/slicoss/slicoss.c
> > @@ -1790,7 +1790,7 @@ static int slic_mcast_add_list(struct adapter *adapter, char *address)
> >  	if (mcaddr == NULL)
> >  		return 1;
> >  
> > -	memcpy(mcaddr->address, address, ETH_ALEN);
> > +	ether_addr_copy(mcaddr->address, address);
> >  
> >  	mcaddr->next = adapter->mcastaddrs;
> >  	adapter->mcastaddrs = mcaddr;
> 
> Are you sure this is correct?  It's not always a one-to-one replacement
> from what I have been told.

I hate this checkpatch.pl warning because it just encourages people to
add bugs.

regards,
dan carpenter

