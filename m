Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab3ASEhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 23:37:54 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:18524 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab3ASEhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 23:37:53 -0500
Date: Fri, 18 Jan 2013 23:37:25 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Matt Sealey <matt@genesi-usa.com>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: Re: Compilation problem with drivers/staging/zsmalloc when !SMP on
 ARM
Message-ID: <20130119043725.GB5391@phenom.dumpdata.com>
References: <CAKGA1b=ACTQHo9=B7EAG5nrFCO9u-J+sy7dXtYk3Rk6OUcW3cQ@mail.gmail.com>
 <20130118210859.GH23505@n2100.arm.linux.org.uk>
 <20130118214527.GA913@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130118214527.GA913@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 01:45:27PM -0800, Greg Kroah-Hartman wrote:
> On Fri, Jan 18, 2013 at 09:08:59PM +0000, Russell King - ARM Linux wrote:
> > On Fri, Jan 18, 2013 at 02:24:15PM -0600, Matt Sealey wrote:
> > > Hello all,
> > > 
> > > I wonder if anyone can shed some light on this linking problem I have
> > > right now. If I configure my kernel without SMP support (it is a very
> > > lean config for i.MX51 with device tree support only) I hit this error
> > > on linking:
> > 
> > Yes, I looked at this, and I've decided that I will _not_ fix this export,
> > neither will I accept a patch to add an export.
> > 
> > As far as I can see, this code is buggy in a SMP environment.  There's
> > apparantly no guarantee that:
> > 
> > 1. the mapping will be created on a particular CPU.
> > 2. the mapping will then be used only on this specific CPU.
> > 3. no guarantee that another CPU won't speculatively prefetch from this
> >    region.

I thought the code had per_cpu for it - so that you wouldn't do that unless
you really went out the way to do it.

> > 4. when the mapping is torn down, no guarantee that it's the same CPU that
> >    used the happing.

With per_cpu that actually would be the case.
> > 
> > So, the use of the local TLB flush leaves all the other CPUs potentially
> > containing TLB entries for this mapping.

Right. That is the point of a local TLB flush.
> > 
> > Finally, there is no TODO file for this driver, which I believe is a
> > requirement for anything to be in stable.  So as far as I can see, it
> > should be deleted or a TODO file added.  I'm not sure why Greg decided
> > to add it without a TODO file.

A TODO file can certainly be added and it is welcome.
> 
> I don't know, I'm cursing the day I took the whole zsmalloc, zcache,
> zram mess that we have in the staging tree now.  People are working to
> get them out of staging, which is good, but the churn involved is
> driving me crazy.

Oh oh.
