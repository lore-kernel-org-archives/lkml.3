Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367Ab3LaS6K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 13:58:10 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:37318 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756320Ab3LaS6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 13:58:08 -0500
Date: Tue, 31 Dec 2013 13:56:56 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        mukesh.rathor@oracle.com, jbeulich@suse.com
Subject: Re: [Xen-devel] [PATCH v11 09/12] xen/pvh: Piggyback on PVHVM XenBus
 and event channels for PVH.
Message-ID: <20131231185656.GB3129@phenom.dumpdata.com>
References: <1387313503-31362-1-git-send-email-konrad.wilk@oracle.com>
 <1387313503-31362-10-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.02.1312181827280.8667@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1312181827280.8667@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > --- a/drivers/xen/xenbus/xenbus_client.c
> > +++ b/drivers/xen/xenbus/xenbus_client.c
> > @@ -45,6 +45,7 @@
> >  #include <xen/grant_table.h>
> >  #include <xen/xenbus.h>
> >  #include <xen/xen.h>
> > +#include <xen/features.h>
> >  
> >  #include "xenbus_probe.h"
> >  
> > @@ -743,7 +744,7 @@ static const struct xenbus_ring_ops ring_ops_hvm = {
> >  
> >  void __init xenbus_ring_ops_init(void)
> >  {
> > -	if (xen_pv_domain())
> > +	if (xen_pv_domain() && !xen_feature(XENFEAT_auto_translated_physmap))
> 
> Can we just change this test to
> 
> if (!xen_feature(XENFEAT_auto_translated_physmap))
> 
> ?

No. If we do then the HVM domains (which are also !auto-xlat)
will end up using the PV version of ring_ops.
> 
> 
> >  		ring_ops = &ring_ops_pv;
> >  	else
> >  		ring_ops = &ring_ops_hvm;
> > -- 
> > 1.8.3.1
> > 
> > 
> > _______________________________________________
> > Xen-devel mailing list
> > Xen-devel@lists.xen.org
> > http://lists.xen.org/xen-devel
> > 
