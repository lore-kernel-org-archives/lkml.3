Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761383Ab3EAO6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 10:58:12 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:16906 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937Ab3EAO6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 10:58:00 -0400
Date: Wed, 1 May 2013 10:57:53 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 8/9] xen/smp/pvhvm: Don't initialize IRQ_WORKER as we are
 using the native one.
Message-ID: <20130501145753.GB6614@phenom.dumpdata.com>
References: <1366142947-18655-1-git-send-email-konrad.wilk@oracle.com>
 <1366142947-18655-9-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.02.1304261726260.4180@kaball.uk.xensource.com>
 <20130429183404.GA9431@phenom.dumpdata.com>
 <alpine.DEB.2.02.1305011424461.5398@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1305011424461.5398@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 02:25:16PM +0100, Stefano Stabellini wrote:
> On Mon, 29 Apr 2013, Konrad Rzeszutek Wilk wrote:
> > On Fri, Apr 26, 2013 at 05:27:20PM +0100, Stefano Stabellini wrote:
> > > On Tue, 16 Apr 2013, Konrad Rzeszutek Wilk wrote:
> > > > There is no need to use the PV version of the IRQ_WORKER mechanism
> > > > as under PVHVM we are using the native version. The native
> > > > version is using the SMP API.
> > > > 
> > > > They just sit around unused:
> > > > 
> > > >   69:          0          0  xen-percpu-ipi       irqwork0
> > > >   83:          0          0  xen-percpu-ipi       irqwork1
> > > > 
> > > > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > > 
> > > Might be worth trying to make it work instead?
> > > Is it just because we don't set the apic->send_IPI_* functions to the
> > > xen specific version on PVHVM?
> > > 
> > 
> > Right. We use the baremetal mechanism to do it. And it works fine.
> 
> OK, it works fine, but won't it generate many mores trap and emulate
> cycles?

No idea. We can certainly make use of the PV IPI mechanism for IRQ_WORKER
type mechaism but I would have to play with xentrace to get a good handle
of what is involved (And how the v Posted interrupt thing affects this).

Right now that is something I can't do (buried in bugs).
