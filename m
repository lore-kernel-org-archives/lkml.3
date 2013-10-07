Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab3JGFq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 01:46:29 -0400
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:40396
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751695Ab3JGFq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 01:46:27 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(zz98dI9371I936eI542I1432I4015Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bh8275dhz2dh2a8h839h8e2h8e3h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5hbe9i1155h)
From: Bhushan Bharat-R65777 <R65777@freescale.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "joro@8bytes.org" <joro@8bytes.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "agraf@suse.de" <agraf@suse.de>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: RE: [PATCH 2/7] iommu: add api to get iommu_domain of a device
Thread-Topic: [PATCH 2/7] iommu: add api to get iommu_domain of a device
Thread-Index: AQHOtQsGaQsPvJ8CfEu+dkEJoOsdkZnWszeAgA2xFOCAAGMFgIAAC5rAgAAM6gCAAABh8IAAECcAgAPjuzA=
Date: Mon, 7 Oct 2013 05:46:23 +0000
Message-ID: <6A3DF150A5B70D4F9B66A25E3F7C888D0719385B@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1379575763-2091-1-git-send-email-Bharat.Bhushan@freescale.com>
	 <1379575763-2091-3-git-send-email-Bharat.Bhushan@freescale.com>
	 <1380127533.3030.319.camel@ul30vt.home>
	 <6A3DF150A5B70D4F9B66A25E3F7C888D0718FD1C@039-SN2MPN1-011.039d.mgd.msft.net>
	 <1380901507.2673.204.camel@ul30vt.home>
	 <6A3DF150A5B70D4F9B66A25E3F7C888D07190F35@039-SN2MPN1-011.039d.mgd.msft.net>
	 <1380906772.25705.19.camel@ul30vt.home>
	 <6A3DF150A5B70D4F9B66A25E3F7C888D07191143@039-SN2MPN1-011.039d.mgd.msft.net>
 <1380910322.25705.56.camel@ul30vt.home>
In-Reply-To: <1380910322.25705.56.camel@ul30vt.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.14.2]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r975kjY2024841



> -----Original Message-----
> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Friday, October 04, 2013 11:42 PM
> To: Bhushan Bharat-R65777
> Cc: joro@8bytes.org; benh@kernel.crashing.org; galak@kernel.crashing.org; linux-
> kernel@vger.kernel.org; linuxppc-dev@lists.ozlabs.org; linux-
> pci@vger.kernel.org; agraf@suse.de; Wood Scott-B07421; iommu@lists.linux-
> foundation.org
> Subject: Re: [PATCH 2/7] iommu: add api to get iommu_domain of a device
> 
> On Fri, 2013-10-04 at 17:23 +0000, Bhushan Bharat-R65777 wrote:
> >
> > > -----Original Message-----
> > > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > > Sent: Friday, October 04, 2013 10:43 PM
> > > To: Bhushan Bharat-R65777
> > > Cc: joro@8bytes.org; benh@kernel.crashing.org;
> > > galak@kernel.crashing.org; linux- kernel@vger.kernel.org;
> > > linuxppc-dev@lists.ozlabs.org; linux- pci@vger.kernel.org;
> > > agraf@suse.de; Wood Scott-B07421; iommu@lists.linux- foundation.org
> > > Subject: Re: [PATCH 2/7] iommu: add api to get iommu_domain of a
> > > device
> > >
> > > On Fri, 2013-10-04 at 16:47 +0000, Bhushan Bharat-R65777 wrote:
> > > >
> > > > > -----Original Message-----
> > > > > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > > > > Sent: Friday, October 04, 2013 9:15 PM
> > > > > To: Bhushan Bharat-R65777
> > > > > Cc: joro@8bytes.org; benh@kernel.crashing.org;
> > > > > galak@kernel.crashing.org; linux- kernel@vger.kernel.org;
> > > > > linuxppc-dev@lists.ozlabs.org; linux- pci@vger.kernel.org;
> > > > > agraf@suse.de; Wood Scott-B07421; iommu@lists.linux-
> > > > > foundation.org
> > > > > Subject: Re: [PATCH 2/7] iommu: add api to get iommu_domain of a
> > > > > device
> > > > >
> > > > > On Fri, 2013-10-04 at 09:54 +0000, Bhushan Bharat-R65777 wrote:
> > > > > >
> > > > > > > -----Original Message-----
> > > > > > > From: linux-pci-owner@vger.kernel.org
> > > > > > > [mailto:linux-pci-owner@vger.kernel.org]
> > > > > > > On Behalf Of Alex Williamson
> > > > > > > Sent: Wednesday, September 25, 2013 10:16 PM
> > > > > > > To: Bhushan Bharat-R65777
> > > > > > > Cc: joro@8bytes.org; benh@kernel.crashing.org;
> > > > > > > galak@kernel.crashing.org; linux- kernel@vger.kernel.org;
> > > > > > > linuxppc-dev@lists.ozlabs.org; linux- pci@vger.kernel.org;
> > > > > > > agraf@suse.de; Wood Scott-B07421; iommu@lists.linux-
> > > > > > > foundation.org; Bhushan Bharat-R65777
> > > > > > > Subject: Re: [PATCH 2/7] iommu: add api to get iommu_domain
> > > > > > > of a device
> > > > > > >
> > > > > > > On Thu, 2013-09-19 at 12:59 +0530, Bharat Bhushan wrote:
> > > > > > > > This api return the iommu domain to which the device is attached.
> > > > > > > > The iommu_domain is required for making API calls related to
> iommu.
> > > > > > > > Follow up patches which use this API to know iommu maping.
> > > > > > > >
> > > > > > > > Signed-off-by: Bharat Bhushan
> > > > > > > > <bharat.bhushan@freescale.com>
> > > > > > > > ---
> > > > > > > >  drivers/iommu/iommu.c |   10 ++++++++++
> > > > > > > >  include/linux/iommu.h |    7 +++++++
> > > > > > > >  2 files changed, 17 insertions(+), 0 deletions(-)
> > > > > > > >
> > > > > > > > diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> > > > > > > > index
> > > > > > > > fbe9ca7..6ac5f50 100644
> > > > > > > > --- a/drivers/iommu/iommu.c
> > > > > > > > +++ b/drivers/iommu/iommu.c
> > > > > > > > @@ -696,6 +696,16 @@ void iommu_detach_device(struct
> > > > > > > > iommu_domain *domain, struct device *dev)  }
> > > > > > > > EXPORT_SYMBOL_GPL(iommu_detach_device);
> > > > > > > >
> > > > > > > > +struct iommu_domain *iommu_get_dev_domain(struct device *dev) {
> > > > > > > > +	struct iommu_ops *ops = dev->bus->iommu_ops;
> > > > > > > > +
> > > > > > > > +	if (unlikely(ops == NULL || ops->get_dev_iommu_domain ==
> NULL))
> > > > > > > > +		return NULL;
> > > > > > > > +
> > > > > > > > +	return ops->get_dev_iommu_domain(dev); }
> > > > > > > > +EXPORT_SYMBOL_GPL(iommu_get_dev_domain);
> > > > > > >
> > > > > > > What prevents this from racing iommu_domain_free()?  There's
> > > > > > > no references acquired, so there's no reason for the caller
> > > > > > > to assume the
> > > > > pointer is valid.
> > > > > >
> > > > > > Sorry for late query, somehow this email went into a folder
> > > > > > and escaped;
> > > > > >
> > > > > > Just to be sure, there is not lock at generic "struct
> > > > > > iommu_domain", but IP
> > > > > specific structure (link FSL domain) linked in
> > > > > iommu_domain->priv have a lock, so we need to ensure this race
> > > > > in FSL iommu code (say drivers/iommu/fsl_pamu_domain.c), right?
> > > > >
> > > > > No, it's not sufficient to make sure that your use of the
> > > > > interface is race free.  The interface itself needs to be
> > > > > designed so that it's difficult to use incorrectly.
> > > >
> > > > So we can define iommu_get_dev_domain()/iommu_put_dev_domain();
> > > > iommu_get_dev_domain() will return domain with the lock held, and
> > > > iommu_put_dev_domain() will release the lock? And
> > > > iommu_get_dev_domain() must always be followed by
> > > > iommu_get_dev_domain().
> > >
> > > What lock?  get/put are generally used for reference counting, not
> > > locking in the kernel.
> > >
> > > > > That's not the case here.  This is a backdoor to get the iommu
> > > > > domain from the iommu driver regardless of who is using it or how.
> > > > > The iommu domain is created and managed by vfio, so shouldn't we
> > > > > be looking at how to do this through vfio?
> > > >
> > > > Let me first describe what we are doing here:
> > > > During initialization:-
> > > >  - vfio talks to MSI system to know the MSI-page and size
> > > >  - vfio then interacts with iommu to map the MSI-page in iommu
> > > > (IOVA is decided by userspace and physical address is the
> > > > MSI-page)
> > > >  - So the IOVA subwindow mapping is created in iommu and yes VFIO
> > > > know about
> > > this mapping.
> > > >
> > > > Now do SET_IRQ(MSI/MSIX) ioctl:
> > > >  - calls pci_enable_msix()/pci_enable_msi_block(): which is
> > > > supposed to set
> > > MSI address/data in device.
> > > >  - So in current implementation (this patchset) msi-subsystem gets
> > > > the IOVA
> > > from iommu via this defined interface.
> > > >  - Are you saying that rather than getting this from iommu, we
> > > > should get this
> > > from vfio? What difference does this make?
> > >
> > > Yes, you just said above that vfio knows the msi to iova mapping, so
> > > why go outside of vfio to find it later?  The difference is one case
> > > you can have a proper reference to data structures to make sure the
> > > pointer you get back actually has meaning at the time you're using
> > > it vs the code here where you're defining an API that returns a
> > > meaningless value
> >
> > With FSL-PAMU we will always get consistant data from iommu or vfio-data
> structure.
> 
> Great, but you're trying to add a generic API to the IOMMU subsystem that's
> difficult to use correctly.  The fact that you use it correctly does not justify
> the API.
> 
> > > because you can't check or
> > > enforce that an arbitrary caller is using it correctly.
> >
> > I am not sure what is arbitrary caller? pdev is known to vfio, so vfio
> > will only make pci_enable_msix()/pci_enable_msi_block() for this pdev.
> > If anyother code makes then it is some other unexpectedly thing
> > happening in system, no?
> 
> What's proposed here is a generic IOMMU API.  Anybody can call this.
> What if the host SCSI driver decides to go get the iommu domain for it's device
> (or any other device)?  Does that fit your usage model?
> 
> > >  It's not maintainable.
> > > Thanks,
> >
> > I do not have any issue with this as well, can you also describe the
> > type of API you are envisioning; I can think of defining some function
> > in vfio.c/vfio_iommu*.c, make them global and declare then in
> > include/Linux/vfio.h And include <Linux/vfio.h> in caller file
> > (arch/powerpc/kernel/msi.c)
> 
> Do you really want module dependencies between vfio and your core kernel MSI
> setup?  Look at the vfio external user interface that we've already defined.
> That allows other components of the kernel to get a proper reference to a vfio
> group.  From there you can work out how to get what you want.  Another
> alternative is that vfio could register an MSI to IOVA mapping with architecture
> code when the mapping is created.  The MSI setup path could then do a lookup in
> architecture code for the mapping.  You could even store the MSI to IOVA mapping
> in VFIO and create an interface where SET_IRQ passes that mapping into setup
> code.

Ok, What I want is to get IOVA associated with a physical address (physical address of MSI-bank).
And currently I do not see a way to know IOVA of a physical address and doing all this domain get and then search through all of iommu-windows of that domain.

What if we add an iommu-API which can return the IOVA mapping of a physical address. Current use case is setting up MSI's for aperture type of IOMMU also getting a phys_to_iova() mapping is independent of VFIO, your thought?

Thanks
-Bharat

> Thanks,
> 
> Alex
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
