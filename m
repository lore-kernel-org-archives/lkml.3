Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab3BVELl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 23:11:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756132Ab3BVELc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 23:11:32 -0500
Message-ID: <1361506273.2801.327.camel@bling.home>
Subject: Re: [PATCH] iommu: making IOMMU sysfs nodes API public
From: Alex Williamson <alex.williamson@redhat.com>
To: David Gibson <david@gibson.dropbear.id.au>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, Joerg Roedel <joerg.roedel@amd.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org
Date: Thu, 21 Feb 2013 21:11:13 -0700
In-Reply-To: <20130222000415.GI21011@truffula.fritz.box>
References: <1360628713.3248.8.camel@bling.home>
	 <1360642004-7419-1-git-send-email-aik@ozlabs.ru>
	 <1360645643.3248.91.camel@bling.home> <511A54DC.9030908@ozlabs.ru>
	 <1360689304.3248.154.camel@bling.home> <5121C709.80007@ozlabs.ru>
	 <1361251440.2801.142.camel@bling.home>
	 <20130219073853.GS21067@truffula.fritz.box>
	 <1361304711.2801.232.camel@bling.home>
	 <20130222000415.GI21011@truffula.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-22 at 11:04 +1100, David Gibson wrote:
> On Tue, Feb 19, 2013 at 01:11:51PM -0700, Alex Williamson wrote:
> > On Tue, 2013-02-19 at 18:38 +1100, David Gibson wrote:
> > > On Mon, Feb 18, 2013 at 10:24:00PM -0700, Alex Williamson wrote:
> > > > On Mon, 2013-02-18 at 17:15 +1100, Alexey Kardashevskiy wrote:
> [snip]
> > > >  Adding the window size to sysfs seems more readily convenient,
> > > > but is it so hard for userspace to open the files and call a couple
> > > > ioctls to get far enough to call IOMMU_GET_INFO?  I'm unconvinced the
> > > > clutter in sysfs more than just a quick fix.  Thanks,
> > > 
> > > And finally, as Alexey points out, isn't the point here so we know how
> > > much rlimit to give qemu?  Using ioctls we'd need a special tool just
> > > to check the dma window sizes, which seems a bit hideous.
> > 
> > Is it more hideous that using iommu groups to report a vfio imposed
> > restriction?  Are a couple open files and a handful of ioctls worse than
> > code to parse directory entries and the future maintenance of an
> > unrestricted grab bag of sysfs entries?
> 
> The fact that the memory is locked is a vfio restriction, but the
> actual dma window size is, genuinely, a property of the group.

A group is an association of devices based on isolation and visibility.
The dma window happens to be associated with a group on your platform,
but that's not always the case.  This is why I was hoping something in
sysfs already reported the dma window so that we could point to it
rather than creating an interface where it doesn't really belong.
Thanks,

Alex

