Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbaACSjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 13:39:19 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:17925 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbaACSjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 13:39:18 -0500
X-IronPort-AV: E=Sophos;i="4.95,599,1384300800"; 
   d="scan'208";a="87431420"
Date: Fri, 3 Jan 2014 18:38:28 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <david.vrabel@citrix.com>, <boris.ostrovsky@oracle.com>,
        <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] allow xenfb initialization for hvm guests
In-Reply-To: <20131231145001.GA3349@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1401031837100.8667@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1312171738550.8667@kaball.uk.xensource.com> <20131231145001.GA3349@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Dec 2013, Konrad Rzeszutek Wilk wrote:
> On Tue, Dec 17, 2013 at 05:53:13PM +0000, Stefano Stabellini wrote:
> > There is no reasons why an HVM guest shouldn't be allowed to use xenfb.
> > As a matter of fact ARM guests, HVM from Linux POV, can use xenfb.
> > Given that no Xen toolstacks configure a xenfb backend for x86 HVM
> > guests, they are not affected.
> 
> Could you reference the upstream git commit that enables this.

The toolstack can already setup a xenfb frontend/backend pair for ARM
guests. However QEMU xenpv machine still needs few unapplied fixes to be
built on ARM:

http://marc.info/?l=qemu-devel&m=138739419700837&w=2


> And also CC the maintainers of drivers/video/*
>
> And lastly lets CC also David and Boris on it.

OK

> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > 
> > diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
> > index cd005c2..02e1c01 100644
> > --- a/drivers/video/xen-fbfront.c
> > +++ b/drivers/video/xen-fbfront.c
> > @@ -692,7 +692,7 @@ static DEFINE_XENBUS_DRIVER(xenfb, ,
> >  
> >  static int __init xenfb_init(void)
> >  {
> > -	if (!xen_pv_domain())
> > +	if (!xen_domain())
> >  		return -ENODEV;
> >  
> >  	/* Nothing to do if running in dom0. */
> 
