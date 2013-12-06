Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab3LFER0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 23:17:26 -0500
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:59454
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751268Ab3LFERY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 23:17:24 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(zz98dI9371I936eI542I1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275dh1de097hz2dh109h2a8h839h8e2h8e3h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h21a6h2216h22d0h2336hbe9i1155h)
From: Bharat Bhushan <Bharat.Bhushan@freescale.com>
To: Scott Wood <scottwood@freescale.com>
CC: Alex Williamson <alex.williamson@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "agraf@suse.de" <agraf@suse.de>,
        Stuart Yoder <stuart.yoder@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/9 v2] vfio-pci: add support for Freescale IOMMU (PAMU)
Thread-Topic: [PATCH 0/9 v2] vfio-pci: add support for Freescale IOMMU (PAMU)
Thread-Index: AQHO5OdyKeXB/EytyUeVGr+Ok97IOJoueBeAgAENqwCAAKUSgIAAARWAgAADyQCABUQ/0IAQ7rQAgABGhdA=
Date: Fri, 6 Dec 2013 04:17:15 +0000
Message-ID: <6A3DF150A5B70D4F9B66A25E3F7C888D07251EFF@039-SN2MPN1-012.039d.mgd.msft.net>
References: <1384838233-24847-1-git-send-email-Bharat.Bhushan@freescale.com>
	 <1384973243.2879.361.camel@ul30vt.home>
	 <6A3DF150A5B70D4F9B66A25E3F7C888D0721D9AC@039-SN2MPN1-012.039d.mgd.msft.net>
	 <1385066603.2879.414.camel@ul30vt.home>
	 <1385066835.1403.489.camel@snotra.buserror.net>
	 <1385067648.2879.421.camel@ul30vt.home>
	 <6A3DF150A5B70D4F9B66A25E3F7C888D0722C180@039-SN2MPN1-012.039d.mgd.msft.net>
 <1386288052.7375.100.camel@snotra.buserror.net>
In-Reply-To: <1386288052.7375.100.camel@snotra.buserror.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.134.82]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rB64HVp6014789



> -----Original Message-----
> From: Wood Scott-B07421
> Sent: Friday, December 06, 2013 5:31 AM
> To: Bhushan Bharat-R65777
> Cc: Alex Williamson; linux-pci@vger.kernel.org; agraf@suse.de; Yoder Stuart-
> B08248; iommu@lists.linux-foundation.org; bhelgaas@google.com; linuxppc-
> dev@lists.ozlabs.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 0/9 v2] vfio-pci: add support for Freescale IOMMU (PAMU)
> 
> On Sun, 2013-11-24 at 23:33 -0600, Bharat Bhushan wrote:
> >
> > > -----Original Message-----
> > > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > > Sent: Friday, November 22, 2013 2:31 AM
> > > To: Wood Scott-B07421
> > > Cc: Bhushan Bharat-R65777; linux-pci@vger.kernel.org; agraf@suse.de;
> > > Yoder Stuart-B08248; iommu@lists.linux-foundation.org;
> > > bhelgaas@google.com; linuxppc- dev@lists.ozlabs.org;
> > > linux-kernel@vger.kernel.org
> > > Subject: Re: [PATCH 0/9 v2] vfio-pci: add support for Freescale
> > > IOMMU (PAMU)
> > >
> > > On Thu, 2013-11-21 at 14:47 -0600, Scott Wood wrote:
> > > > On Thu, 2013-11-21 at 13:43 -0700, Alex Williamson wrote:
> > > > > On Thu, 2013-11-21 at 11:20 +0000, Bharat Bhushan wrote:
> > > > > >
> > > > > > > -----Original Message-----
> > > > > > > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > > > > > > Sent: Thursday, November 21, 2013 12:17 AM
> > > > > > > To: Bhushan Bharat-R65777
> > > > > > > Cc: joro@8bytes.org; bhelgaas@google.com; agraf@suse.de;
> > > > > > > Wood Scott-B07421; Yoder Stuart-B08248;
> > > > > > > iommu@lists.linux-foundation.org; linux-
> > > > > > > pci@vger.kernel.org; linuxppc-dev@lists.ozlabs.org; linux-
> > > > > > > kernel@vger.kernel.org; Bhushan Bharat-R65777
> > > > > > > Subject: Re: [PATCH 0/9 v2] vfio-pci: add support for
> > > > > > > Freescale IOMMU (PAMU)
> > > > > > >
> > > > > > > Is VFIO_IOMMU_PAMU_GET_MSI_BANK_COUNT per aperture (ie. each
> > > > > > > vfio user has $COUNT regions at their disposal exclusively)?
> > > > > >
> > > > > > Number of msi-bank count is system wide and not per aperture,
> > > > > > But will be
> > > setting windows for banks in the device aperture.
> > > > > > So say if we are direct assigning 2 pci device (both have
> > > > > > different iommu
> > > group, so 2 aperture in iommu) to VM.
> > > > > > Now qemu can make only one call to know how many msi-banks are
> > > > > > there but
> > > it must set sub-windows for all banks for both pci device in its
> > > respective aperture.
> > > > >
> > > > > I'm still confused.  What I want to make sure of is that the
> > > > > banks are independent per aperture.  For instance, if we have
> > > > > two separate userspace processes operating independently and
> > > > > they both chose to use msi bank zero for their device, that's
> > > > > bank zero within each aperture and doesn't interfere.  Or
> > > > > another way to ask is can a malicious user interfere with other users by
> using the wrong bank.
> > > > > Thanks,
> > > >
> > > > They can interfere.
> >
> > Want to be sure of how they can interfere?
> 
> If more than one VFIO user shares the same MSI group, one of the users can send
> MSIs to another user, by using the wrong interrupt within the bank.  Unexpected
> MSIs could cause misbehavior or denial of service.
> 
> > >>  With this hardware, the only way to prevent that
> > > > is to make sure that a bank is not shared by multiple protection contexts.
> > > > For some of our users, though, I believe preventing this is less
> > > > important than the performance benefit.
> >
> > So should we let this patch series in without protection?
> 
> No, there should be some sort of opt-in mechanism similar to IOMMU-less VFIO --
> but not the same exact one, since one is a much more serious loss of isolation
> than the other.

Can you please elaborate "opt-in mechanism"?

> 
> > > I think we need some sort of ownership model around the msi banks then.
> > > Otherwise there's nothing preventing another userspace from
> > > attempting an MSI based attack on other users, or perhaps even on
> > > the host.  VFIO can't allow that.  Thanks,
> >
> > We have very few (3 MSI bank on most of chips), so we can not assign
> > one to each userspace.
> 
> That depends on how many users there are.

What I think we can do is:
 - Reserve one MSI region for host. Host will not share MSI region with Guest.
 - For upto 2 Guest (MAX msi with host - 1) give then separate MSI sub regions
 - Additional Guest will share MSI region with other guest.

Any better suggestion are most welcome.

Thanks
-Bharat
> 
> -Scott
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
