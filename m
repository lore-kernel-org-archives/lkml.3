Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab3HERSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 13:18:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127Ab3HERSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 13:18:39 -0400
Message-ID: <1375723092.31262.410.camel@ul30vt.home>
Subject: Re: [PATCH 03/10] vfio: add external user support
From: Alex Williamson <alex.williamson@redhat.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@samba.org>, Alexander Graf <agraf@suse.de>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Date: Mon, 05 Aug 2013 11:18:12 -0600
In-Reply-To: <51EE47DE.5020002@ozlabs.ru>
References: <1373936045-22653-1-git-send-email-aik@ozlabs.ru>
	  <1373936045-22653-4-git-send-email-aik@ozlabs.ru>
	 <1374546224.15429.8.camel@ul30vt.home> <51EE47DE.5020002@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-23 at 19:07 +1000, Alexey Kardashevskiy wrote:
> On 07/23/2013 12:23 PM, Alex Williamson wrote:
> > On Tue, 2013-07-16 at 10:53 +1000, Alexey Kardashevskiy wrote:
> >> VFIO is designed to be used via ioctls on file descriptors
> >> returned by VFIO.
> >>
> >> However in some situations support for an external user is required.
> >> The first user is KVM on PPC64 (SPAPR TCE protocol) which is going to
> >> use the existing VFIO groups for exclusive access in real/virtual mode
> >> on a host to avoid passing map/unmap requests to the user space which
> >> would made things pretty slow.
> >>
> >> The protocol includes:
> >>
> >> 1. do normal VFIO init operation:
> >> 	- opening a new container;
> >> 	- attaching group(s) to it;
> >> 	- setting an IOMMU driver for a container.
> >> When IOMMU is set for a container, all groups in it are
> >> considered ready to use by an external user.
> >>
> >> 2. User space passes a group fd to an external user.
> >> The external user calls vfio_group_get_external_user()
> >> to verify that:
> >> 	- the group is initialized;
> >> 	- IOMMU is set for it.
> >> If both checks passed, vfio_group_get_external_user()
> >> increments the container user counter to prevent
> >> the VFIO group from disposal before KVM exits.
> >>
> >> 3. The external user calls vfio_external_user_iommu_id()
> >> to know an IOMMU ID. PPC64 KVM uses it to link logical bus
> >> number (LIOBN) with IOMMU ID.
> >>
> >> 4. When the external KVM finishes, it calls
> >> vfio_group_put_external_user() to release the VFIO group.
> >> This call decrements the container user counter.
> >> Everything gets released.
> >>
> >> The "vfio: Limit group opens" patch is also required for the consistency.
> >>
> >> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> > 
> > This looks fine to me.  Is the plan to add this through the ppc tree
> > again?  Thanks,
> 
> 
> Nope, better to add this through your tree. And faster for sure :) Thanks!

Applied to my next branch for v3.12.  Thanks,

Alex


