Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbaIXJmn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:42:43 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:27569 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbaIXJml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:42:41 -0400
Date: Wed, 24 Sep 2014 12:42:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: devel@driverdev.osuosl.org, lidza.louina@gmail.com,
        driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 2/3] staging: dgap: adds missing iounmap for re_map_port
 in dgap_release_remap()
Message-ID: <20140924094229.GB5811@mwanda>
References: <20140923002208.GA20768@devel>
 <20140924093648.GA5811@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924093648.GA5811@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 12:36:48PM +0300, Dan Carpenter wrote:
> On Tue, Sep 23, 2014 at 09:22:08AM +0900, Daeseok Youn wrote:
> > Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> > ---
> >  drivers/staging/dgap/dgap.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
> > index 779d144..637ea8a 100644
> > --- a/drivers/staging/dgap/dgap.c
> > +++ b/drivers/staging/dgap/dgap.c
> > @@ -1026,6 +1026,7 @@ static void dgap_release_remap(struct board_t *brd)
> >  	release_mem_region(brd->membase, 0x200000);
> >  	release_mem_region(brd->membase + PCI_IO_OFFSET, 0x200000);
> >  	iounmap(brd->re_map_membase);
> > +	iounmap(brd->re_map_port);
> 
> 
> I don't think it matters, but at least aesthetically it would be better
> to unmap first and then release the regions.  (You can do this in a
> different patch).
> 

Also dgap_do_remap() unwinds in the wrong order and is sucky.  It should
use gotos.

Also the name dgap_do_remap() isn't great.  Remap is a verb not a noun
so the "_do" isn't needed.  Just dgap_remap() and dgap_release_remap()
could be changed to dgap_unmap().

regards,
dan carpenter

