Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbaABSZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 13:25:25 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:21652 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaABSZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 13:25:23 -0500
Date: Thu, 2 Jan 2014 13:24:14 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, stefano.stabellini@eu.citrix.com,
        mukesh.rathor@oracle.com
Subject: Re: [PATCH v12 08/18] xen/pvh: Load GDT/GS in early PV bootup code
 for BSP.
Message-ID: <20140102182413.GB3021@pegasus.dumpdata.com>
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com>
 <1388550945-25499-9-git-send-email-konrad.wilk@oracle.com>
 <52C54E00.7010508@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52C54E00.7010508@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +		loadsegment(es, 0);
> > +		loadsegment(ds, 0);
> > +		loadsegment(fs, 0);
> > +#else
> > +		/* PVH: TODO Implement. */
> > +		BUG();
> > +#endif
> > +		return;    <==============
> > +	}
> >  	pv_cpu_ops.write_gdt_entry = xen_write_gdt_entry_boot;
> >  	pv_cpu_ops.load_gdt = xen_load_gdt_boot;
> 
> If PVH uses native GDT why are these (and possibly other?) GDT ops needed?

They aren't. There is a 'return' there. I marked it for you with
'<======'.


> 
> David
