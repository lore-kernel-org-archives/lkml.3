Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbaACPFR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 10:05:17 -0500
Received: from smtp.citrix.com ([66.165.176.89]:59609 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbaACPFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 10:05:16 -0500
X-IronPort-AV: E=Sophos;i="4.95,598,1384300800"; 
   d="scan'208";a="89554863"
Date: Fri, 3 Jan 2014 15:04:27 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        <mukesh.rathor@oracle.com>, <jbeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH v11 09/12] xen/pvh: Piggyback on PVHVM XenBus
 and event channels for PVH.
In-Reply-To: <20131231185656.GB3129@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1401031501180.8667@kaball.uk.xensource.com>
References: <1387313503-31362-1-git-send-email-konrad.wilk@oracle.com> <1387313503-31362-10-git-send-email-konrad.wilk@oracle.com> <alpine.DEB.2.02.1312181827280.8667@kaball.uk.xensource.com> <20131231185656.GB3129@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Dec 2013, Konrad Rzeszutek Wilk wrote:
> > > --- a/drivers/xen/xenbus/xenbus_client.c
> > > +++ b/drivers/xen/xenbus/xenbus_client.c
> > > @@ -45,6 +45,7 @@
> > >  #include <xen/grant_table.h>
> > >  #include <xen/xenbus.h>
> > >  #include <xen/xen.h>
> > > +#include <xen/features.h>
> > >  
> > >  #include "xenbus_probe.h"
> > >  
> > > @@ -743,7 +744,7 @@ static const struct xenbus_ring_ops ring_ops_hvm = {
> > >  
> > >  void __init xenbus_ring_ops_init(void)
> > >  {
> > > -	if (xen_pv_domain())
> > > +	if (xen_pv_domain() && !xen_feature(XENFEAT_auto_translated_physmap))
> > 
> > Can we just change this test to
> > 
> > if (!xen_feature(XENFEAT_auto_translated_physmap))
> > 
> > ?
> 
> No. If we do then the HVM domains (which are also !auto-xlat)
> will end up using the PV version of ring_ops.

Actually HVM guests have XENFEAT_auto_translated_physmap, so in this
case they would get &ring_ops_hvm.


> > >  		ring_ops = &ring_ops_pv;
> > >  	else
> > >  		ring_ops = &ring_ops_hvm;
> > > -- 
> > > 1.8.3.1
> > > 
> > > 
> > > _______________________________________________
> > > Xen-devel mailing list
> > > Xen-devel@lists.xen.org
> > > http://lists.xen.org/xen-devel
> > > 
> 
