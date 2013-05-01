Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761431Ab3EAPHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 11:07:42 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:53194 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755688Ab3EAPHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 11:07:36 -0400
X-IronPort-AV: E=Sophos;i="4.87,589,1363132800"; 
   d="scan'208";a="21567567"
Date: Wed, 1 May 2013 16:07:07 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 8/9] xen/smp/pvhvm: Don't initialize IRQ_WORKER as we
 are using the native one.
In-Reply-To: <20130501145753.GB6614@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1305011606320.5398@kaball.uk.xensource.com>
References: <1366142947-18655-1-git-send-email-konrad.wilk@oracle.com> <1366142947-18655-9-git-send-email-konrad.wilk@oracle.com> <alpine.DEB.2.02.1304261726260.4180@kaball.uk.xensource.com> <20130429183404.GA9431@phenom.dumpdata.com>
 <alpine.DEB.2.02.1305011424461.5398@kaball.uk.xensource.com> <20130501145753.GB6614@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 May 2013, Konrad Rzeszutek Wilk wrote:
> On Wed, May 01, 2013 at 02:25:16PM +0100, Stefano Stabellini wrote:
> > On Mon, 29 Apr 2013, Konrad Rzeszutek Wilk wrote:
> > > On Fri, Apr 26, 2013 at 05:27:20PM +0100, Stefano Stabellini wrote:
> > > > On Tue, 16 Apr 2013, Konrad Rzeszutek Wilk wrote:
> > > > > There is no need to use the PV version of the IRQ_WORKER mechanism
> > > > > as under PVHVM we are using the native version. The native
> > > > > version is using the SMP API.
> > > > > 
> > > > > They just sit around unused:
> > > > > 
> > > > >   69:          0          0  xen-percpu-ipi       irqwork0
> > > > >   83:          0          0  xen-percpu-ipi       irqwork1
> > > > > 
> > > > > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > > > 
> > > > Might be worth trying to make it work instead?
> > > > Is it just because we don't set the apic->send_IPI_* functions to the
> > > > xen specific version on PVHVM?
> > > > 
> > > 
> > > Right. We use the baremetal mechanism to do it. And it works fine.
> > 
> > OK, it works fine, but won't it generate many mores trap and emulate
> > cycles?
> 
> No idea. We can certainly make use of the PV IPI mechanism for IRQ_WORKER
> type mechaism but I would have to play with xentrace to get a good handle
> of what is involved (And how the v Posted interrupt thing affects this).
> 
> Right now that is something I can't do (buried in bugs).

OK
