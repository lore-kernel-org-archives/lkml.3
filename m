Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbaA0IQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 03:16:30 -0500
Received: from mail-by2lp0238.outbound.protection.outlook.com ([207.46.163.238]:5564
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751059AbaA0IQ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 03:16:29 -0500
From: Varun Sethi <Varun.Sethi@freescale.com>
To: Kai Huang <dev.kai.huang@gmail.com>
CC: Alex Williamson <alex.williamson@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH] vfio/iommu_type1: Multi-IOMMU domain support
Thread-Topic: [RFC PATCH] vfio/iommu_type1: Multi-IOMMU domain support
Thread-Index: AQHPE8PT6BnndueXIU+jZO3SkYX87JqNrb0QgAAiEACAAA83UIAJ5HaAgABrkHA=
Date: Mon, 27 Jan 2014 08:16:25 +0000
Message-ID: <72231d1d2bce4bdea0a0de508d8b012d@BL2PR03MB468.namprd03.prod.outlook.com>
References: <20140117203126.11429.25235.stgit@gimli.home>
	<4bc6dcb96df44b0e94152d9729958d60@BL2PR03MB468.namprd03.prod.outlook.com>
	<1390234886.8705.142.camel@bling.home>
	<f4597c60b5a04e8e8baa225a279abd0d@BL2PR03MB468.namprd03.prod.outlook.com>
 <CAOtp4Kp0-yZBd_P82CV8-VKPmsTByP8pn_C2T9ctbP3oOke3LA@mail.gmail.com>
In-Reply-To: <CAOtp4Kp0-yZBd_P82CV8-VKPmsTByP8pn_C2T9ctbP3oOke3LA@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.169.1]
x-forefront-prvs: 0104247462
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(377424004)(51704005)(377454003)(199002)(189002)(24454002)(13464003)(164054003)(54316002)(74316001)(81542001)(80976001)(90146001)(86362001)(81342001)(83322001)(56816005)(19580405001)(19580395003)(59766001)(77982001)(74366001)(74876001)(63696002)(79102001)(94316002)(66066001)(74706001)(65816001)(80022001)(92566001)(93136001)(85852003)(83072002)(56776001)(93516002)(2656002)(51856001)(47446002)(87266001)(31966008)(46102001)(76482001)(74502001)(74662001)(54356001)(53806001)(50986001)(47976001)(85306002)(33646001)(49866001)(4396001)(47736001)(76786001)(76796001)(87936001)(81686001)(76576001)(81816001)(69226001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB465;H:BL2PR03MB468.namprd03.prod.outlook.com;CLIP:192.88.169.1;FPR:;InfoNoRecordsA:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Kai Huang [mailto:dev.kai.huang@gmail.com]
> Sent: Monday, January 27, 2014 5:50 AM
> To: Sethi Varun-B16395
> Cc: Alex Williamson; iommu@lists.linux-foundation.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [RFC PATCH] vfio/iommu_type1: Multi-IOMMU domain support
> 
> On Tue, Jan 21, 2014 at 2:30 AM, Varun Sethi <Varun.Sethi@freescale.com>
> wrote:
> >
> >
> >> -----Original Message-----
> >> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> >> Sent: Monday, January 20, 2014 9:51 PM
> >> To: Sethi Varun-B16395
> >> Cc: iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org
> >> Subject: Re: [RFC PATCH] vfio/iommu_type1: Multi-IOMMU domain support
> >>
> >> On Mon, 2014-01-20 at 14:45 +0000, Varun Sethi wrote:
> >> >
> >> > > -----Original Message-----
> >> > > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> >> > > Sent: Saturday, January 18, 2014 2:06 AM
> >> > > To: Sethi Varun-B16395
> >> > > Cc: iommu@lists.linux-foundation.org;
> >> > > linux-kernel@vger.kernel.org
> >> > > Subject: [RFC PATCH] vfio/iommu_type1: Multi-IOMMU domain support
> >> > >
> >> > > RFC: This is not complete but I want to share with Varun the
> >> > > dirrection I'm thinking about.  In particular, I'm really not
> >> > > sure if we want to introduce a "v2" interface version with
> >> > > slightly different unmap semantics.  QEMU doesn't care about the
> >> > > difference, but other users might.  Be warned, I'm not even sure
> >> > > if this code
> >> works at the moment.
> >> > > Thanks,
> >> > >
> >> > > Alex
> >> > >
> >> > >
> >> > > We currently have a problem that we cannot support advanced
> >> > > features of an IOMMU domain (ex. IOMMU_CACHE), because we have no
> >> > > guarantee that those features will be supported by all of the
> >> > > hardware units involved with the domain over its lifetime.  For
> >> > > instance, the Intel VT-d architecture does not require that all
> >> > > DRHDs support snoop control.  If we create a domain based on a
> >> > > device behind a DRHD that does support snoop control and enable
> >> > > SNP support via the IOMMU_CACHE mapping option, we cannot then
> >> > > add a device behind a DRHD which does not support snoop control
> >> > > or we'll get reserved bit faults from the SNP bit in the
> >> > > pagetables.  To add to the complexity, we can't know the
> >> > > properties of a domain until a device
> >> is attached.
> >> > [Sethi Varun-B16395] Effectively, it's the same iommu and iommu_ops
> >> > are common across all bus types. The hardware feature differences
> >> > are abstracted by the driver.
> >>
> >> That's a simplifying assumption that is not made anywhere else in the
> >> code.  The IOMMU API allows entirely independent IOMMU drivers to
> >> register per bus_type.  There is no guarantee that all devices are
> >> backed by the same IOMMU hardware unit or make use of the same
> iommu_ops.
> >>
> > [Sethi Varun-B16395] ok
> >
> >> > > We could pass this problem off to userspace and require that a
> >> > > separate vfio container be used, but we don't know how to handle
> >> > > page accounting in that case.  How do we know that a page pinned
> >> > > in one container is the same page as a different container and
> >> > > avoid double billing the user for the page.
> >> > >
> >> > > The solution is therefore to support multiple IOMMU domains per
> >> > > container.  In the majority of cases, only one domain will be
> >> > > required since hardware is typically consistent within a system.
> >> > > However, this provides us the ability to validate compatibility
> >> > > of domains and support mixed environments where page table flags
> >> > > can be different between domains.
> >> > >
> >> > > To do this, our DMA tracking needs to change.  We currently try
> >> > > to coalesce user mappings into as few tracking entries as
> possible.
> >> > > The problem then becomes that we lose granularity of user
> mappings.
> >> > > We've never guaranteed that a user is able to unmap at a finer
> >> > > granularity than the original mapping, but we must honor the
> >> > > granularity of the original mapping.  This coalescing code is
> >> > > therefore removed, allowing only unmaps covering complete maps.
> >> > > The change in accounting is fairly small here, a typical QEMU VM
> >> > > will start out with roughly a dozen entries, so it's arguable if
> >> > > this
> >> coalescing was ever needed.
> >> > >
> >> > > We also move IOMMU domain creation to the point where a group is
> >> > > attached to the container.  An interesting side-effect of this is
> >> > > that we now have access to the device at the time of domain
> >> > > creation and can probe the devices within the group to determine
> the bus_type.
> >> > > This finally makes vfio_iommu_type1 completely device/bus
> agnostic.
> >> > > In fact, each IOMMU domain can host devices on different buses
> >> > > managed by different physical IOMMUs, and present a single DMA
> >> > > mapping interface to the user.  When a new domain is created,
> >> > > mappings are replayed to bring the IOMMU pagetables up to the
> >> > > state of the current container.  And of course, DMA mapping and
> >> > > unmapping automatically traverse all of the configured IOMMU
> domains.
> >> > >
> >> > [Sethi Varun-B16395] This code still checks to see that devices
> >> > being attached to the domain are connected to the same bus type. If
> >> > we intend to merge devices from different bus types but attached to
> >> > compatible domains in to a single domain, why can't we avoid the
> >> > bus check? Why can't we remove the bus dependency from domain
> allocation?
> >>
> >> So if I were to test iommu_ops instead of bus_type (ie. assume that
> >> if a if an IOMMU driver manages iommu_ops across bus_types that it
> >> can accept the devices), would that satisfy your concern?
> > [Sethi Varun-B16395] I think so. Checking for iommu_ops should allow
> iommu groups from different bus_types, to share a domain.
> >
> >>
> >> It may be possible to remove the bus_type dependency from domain
> >> allocation, but the IOMMU API currently makes the assumption that
> >> there's one IOMMU driver per bus_type.
> > [Sethi Varun-B16395] Is that a valid assumption?
> >
> >> Your fix to remove the bus_type
> >> dependency from iommu_domain_alloc() adds an assumption that there is
> >> only one IOMMU driver for all bus_types.  That may work on your
> >> platform, but I don't think it's a valid assumption in the general
> case.
> > [Sethi Varun-B16395] ok
> >
> >> If you'd like to propose alternative ways to remove the bus_type
> >> dependency, please do.  Thanks,
> >>
> > [Sethi Varun-B16395] My main concern, was to allow devices from
> different bus types, to share the iommu domain. I am fine if this can be
> handled from within vfio.
> >
> > -Varun
> >
> What's the reason that we need to share one domain cross multiple bus
> type (and are we talking the iommu_domain structure in iommu framework,
> right)? I am not familiar with the background info, and new to vfio, but
> from hardware point of view, I don't think it's good idea to share one
> domain cross bus types. Although IOMMUs all basically provide DMA
> remapping, interrupt remapping, etc, but it's possible that some hardware
> capability differences can't be commonly abstracted. For example, some
> old IOMMU just implements very simple functionality, it even can't
> support per-BDF DMA remapping, which means it just can't provide multiple
> domains. And also, I think sharing domain cross bus types should just
> implies that the domain can only support the *common* functionality of
> IOMMUs on bus types that are shared.
> 
> Another point is, the IOMMUs on different types may on a hierarchical
> relationship, but not at the same level, in which case the IOMMUs also
> work hierarchically. Take DMA remapping as example, if PCIE bus is not
> the root bus but under some higher level system bus (which also
> implements DMA remapping), the DMA address will be first translated by
> PCIE IOMMU and then IOMMU on that higher level system bus. I am not sure
> in such case, if sharing domain cross bus types works or not, but looks
> it's not a good idea.
> 
I believe the case you are mentioning  is similar to what Alex stated. I wasn't aware of a scenario where properties of different IOMMUs may vary. I was mostly concerned about the case where devices belonging to different bus types can be added to the same vfio container. This could be possible on the embedded platforms, where you could have platform devices and pcie devices sharing the same iommu domain (it's possible that both are connected to the same iommu).

So, we should certainly consider the possibility where the domain can be shared by different bus types.

-Varun
