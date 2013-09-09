Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab3IINMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:12:31 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:37010 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab3IINMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:12:30 -0400
Date: Mon, 9 Sep 2013 09:12:18 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>, jeremy@goop.org,
        stefano.stabellini@eu.citrix.com, linux-kernel@vger.kernel.org,
        stefan.bader@canonical.com, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com
Subject: Re: [Xen-devel] [PATCH] Bug-fixes to enable PV ticketlock to work
 under Xen PVHVM with Linux v3.12. (v1)
Message-ID: <20130909131218.GD21435@phenom.dumpdata.com>
References: <1378561605-18998-1-git-send-email-konrad.wilk@oracle.com>
 <522DA442.4050803@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522DA442.4050803@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 11:34:42AM +0100, David Vrabel wrote:
> On 07/09/13 14:46, Konrad Rzeszutek Wilk wrote:
> > After a bit of false starts, lots of debugging, and tons of help from Stefano and
> > David on how event mechanism is suppose to work I am happy to present a set
> > of bug-fixes that make PV ticketlocks work under Xen PVHVM with Linux v3.12.
> > 
> > v3.12 has now thanks to commit 816434ec4a674fcdb3c2221a6dffdc8f34020550
> > (Merge branch 'x86-spinlocks-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip)
> > PV ticketlocks. That means:
> >  - Xen PV bytelock has been replaced by Xen PV ticketlock.
> >  - Xen PVHVM is using ticketlock (not PV variant) - this patch makes it PV.
> >  - baremetal is still using ticketlocks.
> > 
> > In other words everything in the kernel is ticketlock based with the virtualizations
> > having the 'PV' part to aid.
> > 
> > Please take a look at the patches. If you are interested in testing them
> > out I will post a git tree on Monday based on v3.11 and v3.12-rc0. 
> > 
> > Note that I had not run any performance tests and I am not sure when I will
> > be able to (got other bugs to squash now). I've asked our internal performance
> > engineer to do some benchmarking - but those results won't be available for
> > some time as it takes time to do good benchmarking.
> 
> If there was favourable performance data I would be happy for these to
> go in 3.12, without I think they'll have to wait for 3.13.

Then they will have to wait.

I am not going to be able to provide those within this month.
> 
> David
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
