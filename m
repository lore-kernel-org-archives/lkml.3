Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526Ab3LJFx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 00:53:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722Ab3LJFx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 00:53:28 -0500
Message-ID: <1386654800.22974.2.camel@ul30vt.home>
Subject: Re: [PATCH 0/9 v2] vfio-pci: add support for Freescale IOMMU (PAMU)
From: Alex Williamson <alex.williamson@redhat.com>
To: "Bharat.Bhushan@freescale.com" <Bharat.Bhushan@freescale.com>
Cc: Scott Wood <scottwood@freescale.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "agraf@suse.de" <agraf@suse.de>,
        Stuart Yoder <stuart.yoder@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 09 Dec 2013 22:53:20 -0700
In-Reply-To: <326a93628a9141a9abce97b7bb4e04fd@BN1PR03MB266.namprd03.prod.outlook.com>
References: <1384838233-24847-1-git-send-email-Bharat.Bhushan@freescale.com>
	 <1384973243.2879.361.camel@ul30vt.home>
	 <6A3DF150A5B70D4F9B66A25E3F7C888D0721D9AC@039-SN2MPN1-012.039d.mgd.msft.net>
	 <1385066603.2879.414.camel@ul30vt.home>
	 <1385066835.1403.489.camel@snotra.buserror.net>
	 <1385067648.2879.421.camel@ul30vt.home>
	 <6A3DF150A5B70D4F9B66A25E3F7C888D0722C180@039-SN2MPN1-012.039d.mgd.msft.net>
	 <1385397493.2879.557.camel@ul30vt.home>
	 <6A3DF150A5B70D4F9B66A25E3F7C888D0723624C@039-SN2MPN1-012.039d.mgd.msft.net>
	 <1386289316.7375.107.camel@snotra.buserror.net>
	 <6A3DF150A5B70D4F9B66A25E3F7C888D07251EE4@039-SN2MPN1-012.039d.mgd.msft.net>
	 <1386356393.7375.118.camel@snotra.buserror.net>
	 <1386358226.25738.506.camel@ul30vt.home>
	 <326a93628a9141a9abce97b7bb4e04fd@BN1PR03MB266.namprd03.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-10 at 05:37 +0000, Bharat.Bhushan@freescale.com wrote:
> 
> > -----Original Message-----
> > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > Sent: Saturday, December 07, 2013 1:00 AM
> > To: Wood Scott-B07421
> > Cc: Bhushan Bharat-R65777; linux-pci@vger.kernel.org; agraf@suse.de; Yoder
> > Stuart-B08248; iommu@lists.linux-foundation.org; bhelgaas@google.com; linuxppc-
> > dev@lists.ozlabs.org; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH 0/9 v2] vfio-pci: add support for Freescale IOMMU (PAMU)
> > 
> > On Fri, 2013-12-06 at 12:59 -0600, Scott Wood wrote:
> > > On Thu, 2013-12-05 at 22:11 -0600, Bharat Bhushan wrote:
> > > >
> > > > > -----Original Message-----
> > > > > From: Wood Scott-B07421
> > > > > Sent: Friday, December 06, 2013 5:52 AM
> > > > > To: Bhushan Bharat-R65777
> > > > > Cc: Alex Williamson; linux-pci@vger.kernel.org; agraf@suse.de;
> > > > > Yoder Stuart- B08248; iommu@lists.linux-foundation.org;
> > > > > bhelgaas@google.com; linuxppc- dev@lists.ozlabs.org;
> > > > > linux-kernel@vger.kernel.org
> > > > > Subject: Re: [PATCH 0/9 v2] vfio-pci: add support for Freescale
> > > > > IOMMU (PAMU)
> > > > >
> > > > > On Thu, 2013-11-28 at 03:19 -0600, Bharat Bhushan wrote:
> > > > > >
> > > > > > > -----Original Message-----
> > > > > > > From: Bhushan Bharat-R65777
> > > > > > > Sent: Wednesday, November 27, 2013 9:39 PM
> > > > > > > To: 'Alex Williamson'
> > > > > > > Cc: Wood Scott-B07421; linux-pci@vger.kernel.org;
> > > > > > > agraf@suse.de; Yoder Stuart- B08248;
> > > > > > > iommu@lists.linux-foundation.org; bhelgaas@google.com;
> > > > > > > linuxppc- dev@lists.ozlabs.org; linux-kernel@vger.kernel.org
> > > > > > > Subject: RE: [PATCH 0/9 v2] vfio-pci: add support for
> > > > > > > Freescale IOMMU (PAMU)
> > > > > > >
> > > > > > > If we just provide the size of MSI bank to userspace then
> > > > > > > userspace cannot do anything wrong.
> > > > > >
> > > > > > So userspace does not know address, so it cannot mmap and cause
> > > > > > any
> > > > > interference by directly reading/writing.
> > > > >
> > > > > That's security through obscurity...  Couldn't the malicious user
> > > > > find out the address via other means, such as experimentation on
> > > > > another system over which they have full control?  What would
> > > > > happen if the user reads from their device's PCI config space?  Or
> > > > > gets the information via some back door in the PCI device they
> > > > > own?  Or pokes throughout the address space looking for something that
> > generates an interrupt to its own device?
> > > >
> > > > So how to solve this problem, Any suggestion ?
> > > >
> > > > We have to map one window in PAMU for MSIs and a malicious user can
> > > > ask its device to do DMA to MSI window region with any pair of
> > > > address and data, which can lead to unexpected MSIs in system?
> > >
> > > I don't think there are any solutions other than to limit each bank to
> > > one user, unless the admin turns some knob that says they're OK with
> > > the partial loss of isolation.
> > 
> > Even if the admin does opt-in to an allow_unsafe_interrupts options, it should
> > still be reasonably difficult for one guest to interfere with the other.  I
> > don't think we want to rely on the blind luck of making the full MSI bank
> > accessible to multiple guests and hoping they don't step on each other.
> 
> Not sure how to solve in this case (sharing MSI page)
> 
> >  That probably means that vfio needs to manage the space rather than the guest.
> 
> What you mean by " vfio needs to manage the space rather than the guest"?

I mean there needs to be some kernel component managing the contents of
the MSI page rather than just handing it out to the user and hoping for
the best.  The user API also needs to remain the same whether the user
has the MSI page exclusively or it's shared with others (kernel or
users).  Thanks,

Alex

