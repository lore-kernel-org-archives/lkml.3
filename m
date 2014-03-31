Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbaCaSr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 14:47:57 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:16999
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753071AbaCaSry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 14:47:54 -0400
From: Stuart Yoder <stuart.yoder@freescale.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        Alexander Graf <agraf@suse.de>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "a.rigo@virtualopensystems.com" <a.rigo@virtualopensystems.com>,
        Michal Hocko <mhocko@suse.cz>, Scott Wood <scottwood@freescale.com>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        "Dmitry Kasatkin" <d.kasatkin@samsung.com>, Tejun Heo <tj@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        "tech@virtualopensystems.com" <tech@virtualopensystems.com>,
        Toshi Kani <toshi.kani@hp.com>, Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "Joe Perches" <joe@perches.com>,
        "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>
Subject: RE: mechanism to allow a driver to bind to any device
Thread-Topic: mechanism to allow a driver to bind to any device
Thread-Index: AQHPSJRgFHMkQGxjC0eybU50Rv9ZeprzcXyAgAAHKQCAABT0AIAAYVKAgAefSTA=
Date: Mon, 31 Mar 2014 18:47:51 +0000
Message-ID: <7d1b495cdb6a415e8d3b7f60f409991c@DM2PR03MB352.namprd03.prod.outlook.com>
References: <1391880580-471-1-git-send-email-a.motakis@virtualopensystems.com>
	 <1391880580-471-2-git-send-email-a.motakis@virtualopensystems.com>
	 <20140214222716.GA11838@kroah.com>
	 <ba7597fd8c9f4d91bbccfb42e31a165e@DM2PR03MB352.namprd03.prod.outlook.com>
	 <20140215024725.GA2542@kroah.com>
	 <7043e1edd9974de590dcb392cd8aff14@DM2PR03MB352.namprd03.prod.outlook.com>
	 <20140215173348.GA8056@kroah.com>
	 <b6374a0f30194969ba4622ff2f58ae65@DM2PR03MB352.namprd03.prod.outlook.com>
	 <20140220224337.GA20097@kroah.com>
	 <54cd150235ba4954becdd12f725c5ebd@DM2PR03MB352.namprd03.prod.outlook.com>
	 <20140326144025.GA18387@phenom.dumpdata.com>
	 <D45FC8F2-7807-4BBB-A253-8EFCD091D6BD@suse.de>
	 <1395850862.632.247.camel@ul30vt.home>
 <1395871761.632.316.camel@ul30vt.home>
In-Reply-To: <1395871761.632.316.camel@ul30vt.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.168.50]
x-forefront-prvs: 0167DB5752
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(13464003)(24454002)(164054003)(377454003)(189002)(199002)(51704005)(377424004)(46102001)(87266001)(86362001)(97186001)(79102001)(85852003)(93516002)(94316002)(33646001)(94946001)(59766001)(77982001)(31966008)(15975445006)(20776003)(51856001)(50986001)(74366001)(47736001)(83072002)(81686001)(63696002)(95416001)(90146001)(66066001)(93136001)(81816001)(74316001)(19580405001)(53806001)(4396001)(2656002)(54316002)(74502001)(76796001)(92566001)(98676001)(54356001)(65816001)(74706001)(80976001)(76482001)(97336001)(47446002)(47976001)(15202345003)(85306002)(76576001)(80022001)(74876001)(81542001)(56776001)(74662001)(99286001)(19580395003)(81342001)(76786001)(87936001)(83322001)(56816005)(95666003)(49866001)(69226001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB477;H:DM2PR03MB352.namprd03.prod.outlook.com;FPR:E66FF12D.84FA938C.FBE031B3.42E5D8C1.2075D;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2VIm8cW029342



> -----Original Message-----
> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Wednesday, March 26, 2014 5:09 PM
> To: Alexander Graf
> Cc: kvm@vger.kernel.org; jan.kiszka@siemens.com; will.deacon@arm.com;
> Yoder Stuart-B08248; a.rigo@virtualopensystems.com; Michal Hocko; Wood
> Scott-B07421; Sethi Varun-B16395; kvmarm@lists.cs.columbia.edu; Rafael J.
> Wysocki; Guenter Roeck; Dmitry Kasatkin; Tejun Heo; Bjorn Helgaas;
> Antonios Motakis; tech@virtualopensystems.com; Toshi Kani; Greg KH;
> linux-kernel@vger.kernel.org; iommu@lists.linux-foundation.org; Joe
> Perches; christoffer.dall@linaro.org
> Subject: Re: mechanism to allow a driver to bind to any device
> 
> On Wed, 2014-03-26 at 10:21 -0600, Alex Williamson wrote:
> > On Wed, 2014-03-26 at 23:06 +0800, Alexander Graf wrote:
> > >
> > > > Am 26.03.2014 um 22:40 schrieb Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com>:
> > > >
> > > >> On Wed, Mar 26, 2014 at 01:40:32AM +0000, Stuart Yoder wrote:
> > > >> Hi Greg,
> > > >>
> > > >> We (Linaro, Freescale, Virtual Open Systems) are trying get an
> issue
> > > >> closed that has been perculating for a while around creating a
> mechanism
> > > >> that will allow kernel drivers like vfio can bind to devices of
> any type.
> > > >>
> > > >> This thread with you:
> > > >> http://www.spinics.net/lists/kvm-arm/msg08370.html
> > > >> ...seems to have died out, so am trying to get your response
> > > >> and will summarize again.  Vfio drivers in the kernel (regardless
> of
> > > >> bus type) need to bind to devices of any type.  The driver's
> function
> > > >> is to simply export hardware resources of any type to user space.
> > > >>
> > > >> There are several approaches that have been proposed:
> > > >
> > > > You seem to have missed the one I proposed.
> > > >>
> > > >>   1.  new_id -- (current approach) the user explicitly registers
> > > >>       each new device type with the vfio driver using the new_id
> > > >>       mechanism.
> > > >>
> > > >>       Problem: multiple drivers will be resident that handle the
> > > >>       same device type...and there is nothing user space hotplug
> > > >>       infrastructure can do to help.
> > > >>
> > > >>   2.  "any id" -- the vfio driver could specify a wildcard match
> > > >>       of some kind in its ID match table which would allow it to
> > > >>       match and bind to any possible device id.  However,
> > > >>       we don't want the vfio driver grabbing _all_ devices...just
> the ones we
> > > >>       explicitly want to pass to user space.
> > > >>
> > > >>       The proposed patch to support this was to create a new flag
> > > >>       "sysfs_bind_only" in struct device_driver.  When this flag
> > > >>       is set, the driver can only bind to devices via the sysfs
> > > >>       bind file.  This would allow the wildcard match to work.
> > > >>
> > > >>       Patch is here:
> > > >>       https://lkml.org/lkml/2013/12/3/253
> > > >>
> > > >>   3.  "Driver initiated explicit bind" -- with this approach the
> > > >>       vfio driver would create a private 'bind' sysfs object
> > > >>       and the user would echo the requested device into it:
> > > >>
> > > >>       echo 0001:03:00.0 > /sys/bus/pci/drivers/vfio-pci/vfio_bind
> > > >>
> > > >>       In order to make that work, the driver would need to call
> > > >>       driver_probe_device() and thus we need this patch:
> > > >>       https://lkml.org/lkml/2014/2/8/175
> > > >
> > > > 4). Use the 'unbind' (from the original device) and 'bind' to vfio
> driver.
> > >
> > > This is approach 2, no?
> > >
> > > >
> > > > Which I think is what is currently being done. Why is that not
> sufficient?
> > >
> > > How would 'bind to vfio driver' look like?
> > >
> > > > The only thing I see in the URL is " That works, but it is ugly."
> > > > There is some mention of race but I don't see how - if you do the
> 'unbind'
> > > > on the original driver and then bind the BDF to the VFIO how would
> you get
> > > > a race?
> > >
> > > Typically on PCI, you do a
> > >
> > >   - add wildcard (pci id) match to vfio driver
> > >   - unbind driver
> > >   -> reprobe
> > >   -> device attaches to vfio driver because it is the least recent
> match
> > >   - remove wildcard match from vfio driver
> > >
> > > If in between you hotplug add a card of the same type, it gets
> attached to vfio - even though the logical "default driver" would be the
> device specific driver.
> >
> > I've mentioned drivers_autoprobe in the past, but I'm not sure we're
> > really factoring it into the discussion.  drivers_autoprobe allows us
> to
> > toggle two points:
> >
> > a) When a new device is added whether we automatically give drivers a
> > try at binding to it
> >
> > b) When a new driver is added whether it gets to try to bind to
> anything
> > in the system
> >
> > So we do have a mechanism to avoid the race, but the problem is that it
> > becomes the responsibility of userspace to:
> >
> > 1) turn off drivers_autoprobe
> > 2) unbind/new_id/bind/remove_id
> > 3) turn on drivers_autoprobe
> > 4) call drivers_probe for anything added between 1) & 3)
> >
> > Is the question about the ugliness of the current solution whether it's
> > unreasonable to ask userspace to do this?
> >
> > What we seem to be asking for above is more like an autoprobe flag per
> > driver where there's some way for this special driver to opt out of
> auto
> > probing.  Option 2. in Stuart's list does this by short-cutting ID
> > matching so that a "match" is only found when using the sysfs bind
> path,
> > option 3. enables a way for a driver to expose their own sysfs entry
> > point for binding.  The latter feels particularly chaotic since drivers
> > get to make-up their own bind mechanism.
> >
> > Another twist I'll throw in is that devices can be hot added to IOMMU
> > groups that are in-use by userspace.  When that happens we'd like to be
> > able to disable driver autoprobe of the device to avoid a host driver
> > automatically binding to the device.  I wonder if instead of looking at
> > the problem from the driver perspective, if we were to instead look at
> > it from the device perspective if we might find a solution that would
> > address both.  For instance, if devices had a driver_probe_id property
> > that was by default set to their bus specific ID match ("$VENDOR
> > $DEVICE" on PCI) could we use that to write new match IDs so that a
> > device could only bind to a given driver?  Effectively we could then
> > bind either using the current method of adding to the list of IDs a
> > driver will match of changing the ID that a device would match.  Does
> > that get us anywhere?  Thanks,
> 
> Here's one way this might work for PCI; note that we can do this
> entirely in the bus driver for PCI.  Bind/unbind would go like this:
> 
> # bind device to vfio-pci
> echo vfio-pci > /sys/bus/pci/devices/0000\:03\:00.0/preferred_driver
> echo 0000:03:00.0 > /sys/bus/pci/devices/0000\:03\:00.0/driver/unbind
> echo 0000:03:00.0 > /sys/bus/pci/drivers_probe
> 
> # bind device back to host driver
> echo > /sys/bus/pci/devices/0000\:03\:00.0/preferred_driver
> echo 0000:03:00.0 > /sys/bus/pci/devices/0000\:03\:00.0/driver/unbind
> echo 0000:03:00.0 > /sys/bus/pci/drivers_probe
> 
> When preferred_driver is set for a device it will match and bind only to
> a driver with a matching name.  This also means we can write random
> strings here to avoid a device being bound to any driver if we want.
> 
> In the example patch below I've put the preferred_driver in the struct
> pci_dev, but if this mechanism were adopted by multiple devices perhaps
> we could add it to struct device.  Would something like this work for
> platform devices?
> 
> Note 1, the below is just the core PCI driver change to support this,
> there's some trivial collateral damage from changing an exported
> function not shown here for brevity.
> 
> Note 2, PCI passes a struct pci_device_id to the driver probe function
> which would be NULL in the preferred driver case of the example below.
> We'd need to dynamically create one of these when calling the probe
> function to make this practical for drivers that use that data.  Thanks,

The paradigm of telling the device what the preferred driver is feels
more awkward to me than a sysfs flag for the driver to opt out of
auto-probing...but at this point if there is consensus that the
preferred_driver approach will be accepted upstream, I'm ok with it.
It think it works.

However, I am concerned about getting 'preferred driver' accepted
into the kernel and it's not immediately obvious to me how it is more
palatable than the 'opt out of auto-probe' approaches that were
proposed previously.

I also, was at the point where I thought we should perhaps just
go with current mechanisms and implement new_id for the platform
bus...but Greg's recent response is 'platform devices suck' and it sounds
like he would reject a new_id patch for the platform bus.  So it kind
of feels like we are stuck.

Thanks,
Stuart


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
