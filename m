Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397Ab3EODpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 23:45:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756041Ab3EODp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 23:45:29 -0400
Date: Wed, 15 May 2013 11:44:56 +0800
From: Asias He <asias@redhat.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        target-devel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <rdunlap@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-scsi: Depend on NET for memcpy_fromiovec
Message-ID: <20130515034456.GA18256@hj.localdomain>
References: <20130515095558.918f2b29ba318a477eb5dde2@canb.auug.org.au>
 <1368579583-13097-1-git-send-email-asias@redhat.com>
 <1368587420.9012.36.camel@haakon3.risingtidesystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368587420.9012.36.camel@haakon3.risingtidesystems.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 08:10:20PM -0700, Nicholas A. Bellinger wrote:
> On Wed, 2013-05-15 at 08:59 +0800, Asias He wrote:
> > scsi.c includes vhost.c which uses memcpy_fromiovec.
> > 
> > This patch fixes this build failure.
> > 
> >    From Randy Dunlap:
> >    '''
> >    on x86_64:
> > 
> >    ERROR: "memcpy_fromiovec" [drivers/vhost/vhost_scsi.ko] undefined!
> > 
> >    It needs to depend on NET since net/core/ provides that function.
> >    '''
> > 
> > Reported-by: Randy Dunlap <rdunlap@infradead.org>
> > Signed-off-by: Asias He <asias@redhat.com>
> 
> Hey Asias & MST,
> 
> FYI, I'll be sending a PULL request to Linus in the next couple of days
> for -rc2.
> 
> Let me know if you'd like this to be picked up.

Yes, this is 3.10 material. Sounds good to me.

> --nab
> 
> > ---
> >  drivers/vhost/Kconfig | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> > index 8b9226d..0403323 100644
> > --- a/drivers/vhost/Kconfig
> > +++ b/drivers/vhost/Kconfig
> > @@ -12,7 +12,7 @@ config VHOST_NET
> >  
> >  config VHOST_SCSI
> >  	tristate "VHOST_SCSI TCM fabric driver"
> > -	depends on TARGET_CORE && EVENTFD && m
> > +	depends on NET && TARGET_CORE && EVENTFD && m
> >  	select VHOST_RING
> >  	default n
> >  	---help---
> 
> 

-- 
Asias
