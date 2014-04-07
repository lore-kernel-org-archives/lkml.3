Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbaDGQ2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 12:28:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36308 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbaDGQ2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 12:28:50 -0400
Date: Mon, 7 Apr 2014 09:31:19 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Johannes Thumshirn <johannes.thumshirn@men.de>
Cc: Christoph Jaeger <christophjaeger@linux.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: mcb: fix memory leak in chameleon_parse_cells()
 error path
Message-ID: <20140407163119.GB5658@kroah.com>
References: <1396638298-3173-1-git-send-email-christophjaeger@linux.com>
 <20140407140206.GA23383@jtlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140407140206.GA23383@jtlinux>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 04:02:06PM +0200, Johannes Thumshirn wrote:
> On Fri, Apr 04, 2014 at 09:04:58PM +0200, Christoph Jaeger wrote:
> > chameleon_parse_cells() bails out if chameleon descriptor type is
> > invalid but does not free the storage 'header' points to.
> >
> > Signed-off-by: Christoph Jaeger <christophjaeger@linux.com>
> > ---
> >  drivers/mcb/mcb-parse.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/mcb/mcb-parse.c b/drivers/mcb/mcb-parse.c
> > index d1278b5..0049269 100644
> > --- a/drivers/mcb/mcb-parse.c
> > +++ b/drivers/mcb/mcb-parse.c
> > @@ -141,6 +141,7 @@ int chameleon_parse_cells(struct mcb_bus *bus, phys_addr_t mapbase,
> >  		default:
> >  			pr_err("Invalid chameleon descriptor type 0x%x\n",
> >  				dtype);
> > +			kfree(header);
> >  			return -EINVAL;
> >  		}
> >  		num_cells++;
> > --
> > 1.9.0
> >
> 
> *Doh*
> 
> Thanks for the patch.
> 
> @Greg, how should be the process here? Should I collect MCB related patches
> somewhere and forward them to you, or do you pick them up yourself?

Please collect them up and forward them on to me, that's what a
maintainer's job is :)

thanks,

greg k-h
