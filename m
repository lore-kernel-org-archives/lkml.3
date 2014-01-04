Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414AbaADC0x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 21:26:53 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:23336 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbaADC0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 21:26:52 -0500
Date: Fri, 3 Jan 2014 21:25:30 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Mukesh Rathor <mukesh.rathor@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org, boris.ostrovsky@oracle.com,
        stefano.stabellini@eu.citrix.com
Subject: Re: [PATCH v12 10/18] xen/pvh: Update E820 to work with PVH (v2)
Message-ID: <20140104022526.GA14630@pegasus.dumpdata.com>
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com>
 <1388550945-25499-11-git-send-email-konrad.wilk@oracle.com>
 <52C59068.1040603@citrix.com>
 <20140102184133.GE3021@pegasus.dumpdata.com>
 <20140103172337.1e077e56@mantra.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140103172337.1e077e56@mantra.us.oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 03, 2014 at 05:23:37PM -0800, Mukesh Rathor wrote:
> On Thu, 2 Jan 2014 13:41:34 -0500
> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> 
> > On Thu, Jan 02, 2014 at 04:14:32PM +0000, David Vrabel wrote:
> > > On 01/01/14 04:35, Konrad Rzeszutek Wilk wrote:
> > > > From: Mukesh Rathor <mukesh.rathor@oracle.com>
> > > > 
> > > > In xen_add_extra_mem() we can skip updating P2M as it's managed
> > > > by Xen. PVH maps the entire IO space, but only RAM pages need
> > > > to be repopulated.
> > > 
> > > So this looks minimal but I can't work out what PVH actually needs
> > > to do here.  This code really doesn't need to be made any more
> > > confusing.
> > 
> > I gather you prefer Mukesh's original version?
> 
> I think Konrad thats easier to follow as one can quickly spot
> the PVH difference... but your call.

I prefer the one that re-uses the existing logic. That has been - both
in the hypervisor and in the Linux kernel for PVH - the path - just do
nice little one-offs that do something simpler and easier than the
old PV path.

That way one can easily spot how PV vs PVH works for certain operations.

It also from a testing coverage perspective means we end up using the
same codepath for both PV and PVH - so we do get more testing exposure
for different modes.

> 
> thanks
> mukesh
> 
