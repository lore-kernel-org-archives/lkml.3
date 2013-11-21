Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab3KUUr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 15:47:27 -0500
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:19815
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751508Ab3KUUrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 15:47:25 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -6
X-BigFish: VS-6(zz98dI9371I936eI542I1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097hz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h1155h)
Message-ID: <1385066835.1403.489.camel@snotra.buserror.net>
Subject: Re: [PATCH 0/9 v2] vfio-pci: add support for Freescale IOMMU (PAMU)
From: Scott Wood <scottwood@freescale.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Bharat Bhushan <Bharat.Bhushan@freescale.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "agraf@suse.de" <agraf@suse.de>,
        Stuart Yoder <stuart.yoder@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 21 Nov 2013 14:47:15 -0600
In-Reply-To: <1385066603.2879.414.camel@ul30vt.home>
References: <1384838233-24847-1-git-send-email-Bharat.Bhushan@freescale.com>
	 <1384973243.2879.361.camel@ul30vt.home>
	 <6A3DF150A5B70D4F9B66A25E3F7C888D0721D9AC@039-SN2MPN1-012.039d.mgd.msft.net>
	 <1385066603.2879.414.camel@ul30vt.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-11-21 at 13:43 -0700, Alex Williamson wrote:
> On Thu, 2013-11-21 at 11:20 +0000, Bharat Bhushan wrote:
> > 
> > > -----Original Message-----
> > > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > > Sent: Thursday, November 21, 2013 12:17 AM
> > > To: Bhushan Bharat-R65777
> > > Cc: joro@8bytes.org; bhelgaas@google.com; agraf@suse.de; Wood Scott-B07421;
> > > Yoder Stuart-B08248; iommu@lists.linux-foundation.org; linux-
> > > pci@vger.kernel.org; linuxppc-dev@lists.ozlabs.org; linux-
> > > kernel@vger.kernel.org; Bhushan Bharat-R65777
> > > Subject: Re: [PATCH 0/9 v2] vfio-pci: add support for Freescale IOMMU (PAMU)
> > > 
> > > Is VFIO_IOMMU_PAMU_GET_MSI_BANK_COUNT per aperture (ie. each vfio user has
> > > $COUNT regions at their disposal exclusively)?
> > 
> > Number of msi-bank count is system wide and not per aperture, But will be setting windows for banks in the device aperture.
> > So say if we are direct assigning 2 pci device (both have different iommu group, so 2 aperture in iommu) to VM.
> > Now qemu can make only one call to know how many msi-banks are there but it must set sub-windows for all banks for both pci device in its respective aperture.
> 
> I'm still confused.  What I want to make sure of is that the banks are
> independent per aperture.  For instance, if we have two separate
> userspace processes operating independently and they both chose to use
> msi bank zero for their device, that's bank zero within each aperture
> and doesn't interfere.  Or another way to ask is can a malicious user
> interfere with other users by using the wrong bank.  Thanks,

They can interfere.  With this hardware, the only way to prevent that is
to make sure that a bank is not shared by multiple protection contexts.
For some of our users, though, I believe preventing this is less
important than the performance benefit.

-Scott



