Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143Ab3LFTZU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 14:25:20 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:2279 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753417Ab3LFTZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 14:25:18 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -6
X-BigFish: VS-6(zz98dI9371I936eI542I1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275dh1de097hz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
Message-ID: <1386357907.7375.127.camel@snotra.buserror.net>
Subject: Re: [PATCH 0/9 v2] vfio-pci: add support for Freescale IOMMU (PAMU)
From: Scott Wood <scottwood@freescale.com>
To: Bharat Bhushan <Bharat.Bhushan@freescale.com>
CC: Alex Williamson <alex.williamson@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "agraf@suse.de" <agraf@suse.de>,
        Yoder Stuart-B08248 <stuart.yoder@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 6 Dec 2013 13:25:07 -0600
In-Reply-To: <6A3DF150A5B70D4F9B66A25E3F7C888D07251EFF@039-SN2MPN1-012.039d.mgd.msft.net>
References: <1384838233-24847-1-git-send-email-Bharat.Bhushan@freescale.com>
	 <1384973243.2879.361.camel@ul30vt.home>
	 <6A3DF150A5B70D4F9B66A25E3F7C888D0721D9AC@039-SN2MPN1-012.039d.mgd.msft.net>
	 <1385066603.2879.414.camel@ul30vt.home>
	 <1385066835.1403.489.camel@snotra.buserror.net>
	 <1385067648.2879.421.camel@ul30vt.home>
	 <6A3DF150A5B70D4F9B66A25E3F7C888D0722C180@039-SN2MPN1-012.039d.mgd.msft.net>
	 <1386288052.7375.100.camel@snotra.buserror.net>
	 <6A3DF150A5B70D4F9B66A25E3F7C888D07251EFF@039-SN2MPN1-012.039d.mgd.msft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-05 at 22:17 -0600, Bharat Bhushan wrote:
> 
> > -----Original Message-----
> > From: Wood Scott-B07421
> > Sent: Friday, December 06, 2013 5:31 AM
> > To: Bhushan Bharat-R65777
> > Cc: Alex Williamson; linux-pci@vger.kernel.org; agraf@suse.de; Yoder Stuart-
> > B08248; iommu@lists.linux-foundation.org; bhelgaas@google.com; linuxppc-
> > dev@lists.ozlabs.org; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH 0/9 v2] vfio-pci: add support for Freescale IOMMU (PAMU)
> >
> > On Sun, 2013-11-24 at 23:33 -0600, Bharat Bhushan wrote:
> > >
> > > > -----Original Message-----
> > > > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > > > Sent: Friday, November 22, 2013 2:31 AM
> > > > To: Wood Scott-B07421
> > > > Cc: Bhushan Bharat-R65777; linux-pci@vger.kernel.org; agraf@suse.de;
> > > > Yoder Stuart-B08248; iommu@lists.linux-foundation.org;
> > > > bhelgaas@google.com; linuxppc- dev@lists.ozlabs.org;
> > > > linux-kernel@vger.kernel.org
> > > > Subject: Re: [PATCH 0/9 v2] vfio-pci: add support for Freescale
> > > > IOMMU (PAMU)
> > > >
> > > > On Thu, 2013-11-21 at 14:47 -0600, Scott Wood wrote:
> > > > > They can interfere.
> > >
> > > Want to be sure of how they can interfere?
> >
> > If more than one VFIO user shares the same MSI group, one of the users can send
> > MSIs to another user, by using the wrong interrupt within the bank.  Unexpected
> > MSIs could cause misbehavior or denial of service.
> >
> > > >>  With this hardware, the only way to prevent that
> > > > > is to make sure that a bank is not shared by multiple protection contexts.
> > > > > For some of our users, though, I believe preventing this is less
> > > > > important than the performance benefit.
> > >
> > > So should we let this patch series in without protection?
> >
> > No, there should be some sort of opt-in mechanism similar to IOMMU-less VFIO --
> > but not the same exact one, since one is a much more serious loss of isolation
> > than the other.
> 
> Can you please elaborate "opt-in mechanism"?

The system should be secure by default.  If the administrator wants to
relax protection in order to accomplish some functionality, that should
require an explicit request such as a write to a sysfs file.

> > > > I think we need some sort of ownership model around the msi banks then.
> > > > Otherwise there's nothing preventing another userspace from
> > > > attempting an MSI based attack on other users, or perhaps even on
> > > > the host.  VFIO can't allow that.  Thanks,
> > >
> > > We have very few (3 MSI bank on most of chips), so we can not assign
> > > one to each userspace.
> >
> > That depends on how many users there are.
> 
> What I think we can do is:
>  - Reserve one MSI region for host. Host will not share MSI region with Guest.
>  - For upto 2 Guest (MAX msi with host - 1) give then separate MSI sub regions
>  - Additional Guest will share MSI region with other guest.
> 
> Any better suggestion are most welcome.

If the administrator does not opt into this partial loss of isolation,
then once you run out of MSI groups, new users should not be able to set
up MSIs.

-Scott



