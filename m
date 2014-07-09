Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561AbaGIRB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 13:01:26 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:60928 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337AbaGIRBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 13:01:25 -0400
Date: Wed, 9 Jul 2014 13:01:22 -0400
From: "James A. Shackleford" <shack@linux.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        florian.c.schilhabel@googlemail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] staging: rtl8712: remove inapplicable comment
Message-ID: <20140709170122.GA4315@xavier>
References: <1403664761-15728-1-git-send-email-shack@linux.com>
 <1403664761-15728-2-git-send-email-shack@linux.com>
 <1403664761-15728-3-git-send-email-shack@linux.com>
 <1403664761-15728-4-git-send-email-shack@linux.com>
 <1403664761-15728-5-git-send-email-shack@linux.com>
 <1403664761-15728-6-git-send-email-shack@linux.com>
 <1403664761-15728-7-git-send-email-shack@linux.com>
 <1403664761-15728-8-git-send-email-shack@linux.com>
 <20140708101653.GJ25880@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140708101653.GJ25880@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 01:16:53PM +0300, Dan Carpenter wrote:
> On Tue, Jun 24, 2014 at 10:52:41PM -0400, James A Shackleford wrote:
> > Signed-off-by: James A Shackleford <shack@linux.com>
> > ---
> >  drivers/staging/rtl8712/osdep_service.h |    5 -----
> >  1 file changed, 5 deletions(-)
> > 
> > diff --git a/drivers/staging/rtl8712/osdep_service.h b/drivers/staging/rtl8712/osdep_service.h
> > index 77b1443..3dfc473 100644
> > --- a/drivers/staging/rtl8712/osdep_service.h
> > +++ b/drivers/staging/rtl8712/osdep_service.h
> > @@ -95,11 +95,6 @@ static inline void _set_workitem(_workitem *pwork)
> >  	#define BIT(x)	(1 << (x))
> >  #endif
> >  
> > -/*
> > -For the following list_xxx operations,
> > -caller must guarantee the atomic context.
> > -Otherwise, there will be racing condition.
> > -*/
> >  static inline u32 _down_sema(struct semaphore *sema)
> >  {
> >  	if (down_interruptible(sema))
> 
> This function sucks obviously just like the wrappers you deleted earlier.
> 
> Only one of the callers checks the return value.
> 
> TODO-list: 2014-07-08: rtl8712: delete _down_sema().
> 
> regards,
> dan carpenter
> 

I completely agree -- most of the stuff in this header is pretty ugly.  More
clean-up patches are in the pipe.

Regards,
James Shackleford
